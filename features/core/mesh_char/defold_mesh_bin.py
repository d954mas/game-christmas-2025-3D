# See https://docs.blender.org/api/blender_python_api_2_78_0/info_tutorial_addon.html for more info

bl_info = {
    "name": "Defold Mesh Binary Export",
    "author": "",
    "version": (1, 2),
    "blender": (3, 0, 0),
    "location": "File > Export > Defold Binary Mesh (.bin)",
    "description": "Export to Defold .mesh format",
    "warning": "",
    "wiki_url": "",
    "tracker_url": "",
    "category": "Import-Export"
}

import bpy, sys, struct
from pathlib import Path

def write_frame_data(precompute, bones, obj, f):
    matrix_local = obj.matrix_local
    (translation, rotation, scale) = obj.matrix_world.decompose()
    f.write(struct.pack('eee', *translation))
    f.write(struct.pack('eee', *rotation.to_euler()))
    f.write(struct.pack('eee', *scale))
    for pbone in bones:
        matrix = matrix_local.inverted() @ pbone.matrix @ pbone.bone.matrix_local.inverted() @ matrix_local if precompute else pbone.matrix
        f.write(struct.pack('eeee', *matrix[0]))
        f.write(struct.pack('eeee', *matrix[1]))
        f.write(struct.pack('eeee', *matrix[2]))
     
def write_shape_values(mesh, shapes, f):
    for shape in shapes:
        s = mesh.shape_keys.key_blocks.get(shape['name'])
        value = float("{:.2f}".format(s.value))
        f.write(struct.pack('i', len(shape['name'])))
        f.write(bytes(shape['name'], "ascii"))
        f.write(struct.pack('f', value))
                
def optimize(bones, vertices, vertex_groups, limit_per_vertex, keep_all_bones):
          
    def sort_weights(vg):
        return -vg.weight
    bones_map = {}
    if keep_all_bones:
        bones_map = {bone.name: True for bone in bones}
    else:
        bones_map = {bone.name: False for bone in bones}

    vertex_groups_per_vertex = []
    for vert in vertices:
        fixed_groups = []
        for wgrp in vert.groups:
            group = vertex_groups[wgrp.group]
            if wgrp.weight > 0 and group.name in bones_map:
                fixed_groups.append(wgrp)
                bones_map[group.name] = True
            
        fixed_groups.sort(key = sort_weights)

        # Store the length of fixed_groups before limit
        length_before_limit = len(fixed_groups)

        # Apply the limit
        fixed_groups = fixed_groups[:limit_per_vertex]

        # Check if the length is different before and after limit
        if length_before_limit != len(fixed_groups):
            print("Change in group size detected:")
            print("Size before limit:", length_before_limit)
            print("Size after limit:", len(fixed_groups))
        else:
            print("group bones:", len(fixed_groups), "limit:", limit_per_vertex, "no change")

        total = 0
        for vg in fixed_groups:
            total = total + vg.weight
        for vg in fixed_groups:
            vg.weight = vg.weight / total
        vertex_groups_per_vertex.append(fixed_groups)
            
        used_bones = []
        for bone in bones:
            if bones_map[bone.name]:
                used_bones.append(bone)
    return used_bones, vertex_groups_per_vertex

def write_some_data(context, filepath, export_anim_setting, export_hidden_settings, export_precompute_setting, export_mesh):
    
    f = open(filepath, 'wb')
     
    for obj in context.scene.objects:
        if obj.type != 'MESH':
            continue
        
        if obj.mode == 'EDIT':
            obj.mode_set(mode='OBJECT', toggle=False)
            
        mesh = obj.data
        
        mesh.calc_loop_triangles()
        mesh.calc_normals_split()
        
        
        if len(mesh.loop_triangles) == 0:
            continue
        
        if not obj.visible_get() and not export_hidden_settings:
            continue
        
        print(obj.name)

        f.write(struct.pack('i', 1 if export_mesh else 0))

        f.write(struct.pack('i', len(obj.name)))
        f.write(bytes(obj.name, "ascii"))
       
        #if obj.parent:
        #    f.write(struct.pack('i', len(obj.parent.name)))
        #    f.write(bytes(obj.parent.name, "ascii"))
        #else:
       #     f.write(struct.pack('i', 0)) #no parent flag
                        
        f.write(struct.pack('eee', *obj.location))
        f.write(struct.pack('eee', *obj.rotation_euler))
        f.write(struct.pack('eee', *obj.scale))
        
        #keep world transform in case we won't export parent object (e.g. ARMATURE)
        # !!!! problem here: if object or armature is moving - animations will look wrong
        (translation, rotation, scale) = obj.matrix_world.decompose()
        f.write(struct.pack('eee', *translation))
        f.write(struct.pack('eee', *rotation.to_euler()))
        f.write(struct.pack('eee', *scale))
        
        #---------------------read-materials-----------------------
        def find_nodes_to(socket, type):
            for link in socket.links:
                node = link.from_node
                #print(node.bl_static_type )
                if node.bl_static_type == type:
                    return [node]
                else:
                    for input in node.inputs:
                        n = find_nodes_to(input, type)
                        if n:
                            n.append(node)
                            return n
            return None
        
        def find_node(socket, type):
            nodes = find_nodes_to(socket, type)
            if nodes:
                #print([n.bl_static_type for n in nodes])
                return nodes[0]
            return None
                
        def find_texture(socket):
            node = find_node(socket, 'TEX_IMAGE')
            if node != None:
                texture = Path(node.image.filepath).name
                return texture
                
            return None
        
        def find_ramp(socket):
            node = find_node(socket, 'VALTORGB')
            if node and node.color_ramp:
                ramp = node.color_ramp
                e1 = ramp.elements[0]
                e2 = ramp.elements[len(ramp.elements)-1]
                return {'p1': e1.position, 'v1': e1.color[0], 'p2': e2.position, 'v2': e2.color[0]} 
                #simplified ramp, just intensity of first and last element, enough for specular\roughness
        
        materials = []
        for m in mesh.materials:
            #print("--------------------------")
            #print("material", m.name, m.blend_method)
            
            material = {'name': m.name, 'col':  m.diffuse_color, 'method': m.blend_method, 'spec_power': 0.0, 'roughness': 0.0, 'normal_strength': 1.0}
            materials.append(material)
            
            if m.node_tree:
     
                for principled in m.node_tree.nodes:
                    if principled.bl_static_type != 'BSDF_PRINCIPLED':
                        continue

                    specular = principled.inputs['Specular']
                    material['spec_power'] = specular.default_value
                    material['specular'] = find_texture(specular)
                   
                    if material.get('specular'):
                        material['specular_invert'] = 1 if find_node(specular, 'INVERT') else 0
                        material['specular_ramp'] = find_ramp(specular)
                        
                    roughness = principled.inputs['Roughness']
                    material['roughness'] = roughness.default_value
                    material['roughness_tex'] = find_texture(roughness)
                    material['roughness_ramp'] = find_ramp(roughness)
                   
                    normal_map = find_node(principled.inputs['Normal'], 'NORMAL_MAP')
                    if normal_map:
                        material['normal'] = find_texture(normal_map.inputs['Color'])
                        material['normal_strength'] = normal_map.inputs['Strength'].default_value
                    
                    base_color = principled.inputs['Base Color']
                    value = base_color.default_value

                    material['col'] = [value[0], value[1], value[2], principled.inputs['Alpha'].default_value]
                    
                    material['texture'] = find_texture(base_color)
                    
                    if material.get('texture') != None:
                        #print(material['texture'])
                        break #TODO objects with combined shaders
        
        #---------------------write-geometry------------------------
        if not export_mesh:
            #f.write(struct.pack('i', len(mesh.vertices)))
            f.write(struct.pack('i', 0))
        else:
            f.write(struct.pack('i', len(mesh.vertices)))

            for vert in mesh.vertices:
                f.write(struct.pack('eee', *vert.co))
                f.write(struct.pack('eee', *vert.normal))


        if not export_mesh:
            #f.write(struct.pack('i', len(mesh.loop_triangles)))
            f.write(struct.pack('i', 0))
            uv = []
            f.write(struct.pack('e' * len(uv), *uv))

        else:
            f.write(struct.pack('i', len(mesh.loop_triangles)))

            uv = []
            for face in mesh.loop_triangles:
                f.write(struct.pack('iii', *face.vertices))

                assert face.material_index == 0
                #f.write(struct.pack('i', face.material_index))

                for loop_idx in face.loops:
                    uv_cords = mesh.uv_layers.active.data[loop_idx].uv if mesh.uv_layers.active else (0, 0)
                    uv.extend(uv_cords)

                #if not face.use_smooth:
                  #  f.write(struct.pack('i', 1))
                  #  f.write(struct.pack('eee', *face.normal))
               # else:
                  #   f.write(struct.pack('i', 0))

            f.write(struct.pack('e' * len(uv), *uv))

                #f.close()
                #return {'FINISHED'}

        #---------------------write-bones------------------------

        armature = obj.find_armature()

        if armature:
            pose = armature.pose


            #optimizing bones, checking empty bones, etc
            #set limit to 4 bones per vertex
            #keep all bones to reuse animation

            used_bones, vertex_groups_per_vertex = optimize(pose.bones, mesh.vertices, obj.vertex_groups, 4, True)
            print("USED BONES: ", len(used_bones))
            # New code to print bone index and name
            for idx, bone in enumerate(used_bones):
                print(f"Bone Index: {idx}, Bone Name: {bone.name}")
            bones_map = {bone.name: i for i, bone in enumerate(used_bones)}
            f.write(struct.pack('i', len(used_bones)))

            if export_mesh:
                for groups in vertex_groups_per_vertex:
                    f.write(struct.pack('i', len(groups)))
                    for wgrp in groups:
                        group = obj.vertex_groups[wgrp.group]
                        bone_idx = bones_map[group.name]
                        f.write(struct.pack('i', bone_idx))
                        f.write(struct.pack('e', wgrp.weight))

                f.write(struct.pack('i', 1 if export_precompute_setting else 0))

                if not export_precompute_setting:
                    for pbone in used_bones:
                        #print(pbone.bone.name)
                        matrix = pbone.bone.matrix_local.inverted()
                        f.write(struct.pack('eeee', *matrix[0]))

                        f.write(struct.pack('eeee', *matrix[1]))
                        f.write(struct.pack('eeee', *matrix[2]))

            if export_anim_setting:
                f.write(struct.pack('i', context.scene.frame_end))

                frame_current = context.scene.frame_current

                for frame in range(context.scene.frame_end):
                    context.scene.frame_set(frame)

                    #there is an issue with IK bones (and maybe other simulations?)
                    #looks like Blender needs some time to compute it
                    context.scene.frame_set(frame) #twice to make sure IK computations is done?
                    context.view_layer.update() #not enough?

                    depsgraph = context.evaluated_depsgraph_get()

                    #TODO: support object and armature transformations, save this data for every frame

                    write_frame_data(export_precompute_setting, used_bones, obj, f)
                   # write_shape_values(mesh, shapes, f)

                context.scene.frame_set(frame_current) #as we work with object's global matrix in particular frame

            else:
                f.write(struct.pack('i', 1)) #single frame flag
                write_frame_data(export_precompute_setting, used_bones, obj, f)
                #write_shape_values(mesh, shapes, f)
        else:
            f.write(struct.pack('i', 0)) #no bones flag

    f.close()

    return {'FINISHED'}


# ExportHelper is a helper class, defines filename and
# invoke() function which calls the file selector.
from bpy_extras.io_utils import ExportHelper
from bpy.props import StringProperty, BoolProperty, EnumProperty
from bpy.types import Operator

class DefoldExport(Operator, ExportHelper):
    """This appears in the tooltip of the operator and in the generated docs"""
    bl_idname = "export_mesh.defold_binary"  # important since its how bpy.ops.import_test.some_data is constructed
    bl_label = "Export binary"
    bl_description  = "Export Defold binary mesh data"

    # ExportHelper mixin class uses this
    filename_ext = ".bin"

    filter_glob: StringProperty(
        default="*.bin",
        options={'HIDDEN'},
        maxlen=255,  # Max internal buffer length, longer would be clamped.
    )
    
    export_precompute: BoolProperty(
        name="Precompute bones",
        description="less calculations in runtime, but avoid runtime animation blending",
        default=True,
    )
    
    export_anim: BoolProperty(
        name="Export animations",
        description="Only for armatures",
        default=False,
    )
    
    export_hidden: BoolProperty(
        name="Export hidden meshes",
        description="",
        default=False,
    )

    export_mesh: BoolProperty(
        name="Export mesh",
        description="If false only animation will be export",
        default=True,
    )


    def execute(self, context):
        return write_some_data(context, self.filepath, self.export_anim, self.export_hidden, self.export_precompute, self.export_mesh)


# Only needed if you want to add into a dynamic menu
def menu_func_export(self, context):
    self.layout.operator(DefoldExport.bl_idname, text="Defold Binary Mesh (.bin)")

# Register and add to the "file selector" menu (required to use F3 search "Text Export Operator" for quick access)
def register():
    bpy.utils.register_class(DefoldExport)
    bpy.types.TOPBAR_MT_file_export.append(menu_func_export)


def unregister():
    bpy.utils.unregister_class(DefoldExport)
    bpy.types.TOPBAR_MT_file_export.remove(menu_func_export)


if __name__ == "__main__":
    register()

    # test call
    bpy.ops.export_mesh.defold_binary('INVOKE_DEFAULT')