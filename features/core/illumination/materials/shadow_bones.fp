#version 140

uniform mediump sampler2D DIFFUSE_TEXTURE;
  #include "/features/core/illumination/assets/materials/shadow/shadow_fp_texture.glsl"
  #include "/features/core/illumination/assets/materials/light_fp_texture.glsl"
uniform highp sampler2D tex_anim;

in mediump vec2 var_texcoord0;
in highp vec3 var_world_position;
in mediump vec3 var_world_normal;
in highp vec3 var_camera_position;
in highp vec3 var_view_position;
  #include "/features/core/illumination/assets/materials/shadow/shadow_fp_in.glsl"

// Uniform-блок
uniform fs_uniforms {
    lowp vec4 tint;

    // Light uniforms
      #include "/features/core/illumination/assets/materials/light_fp_uniforms.glsl"

    // Shadow-specific constants
      #include "/features/core/illumination/assets/materials/shadow/shadow_fp_uniforms.glsl"
};


out lowp vec4 out_fragColor;

// Функции (декод, освещение и тени)
  #include "/features/core/illumination/assets/materials/light_fp_functions.glsl"
  #include "/features/core/illumination/assets/materials/shadow/shadow_fp_functions.glsl"

void main() {
    // Do not remove or shader compiler might optimize away textures
    vec4 texture_color = texture(DIFFUSE_TEXTURE, var_texcoord0) +
    texture(SHADOW_TEXTURE, var_texcoord0_shadow.xy) +
    texture(DATA_TEXTURE, var_texcoord0_shadow.xy) +
    texture(tex_anim, vec2(0.0)) +
    vec4(1.0);

    out_fragColor = float_to_rgba(gl_FragCoord.z) * min(1.0, texture_color.r);
}