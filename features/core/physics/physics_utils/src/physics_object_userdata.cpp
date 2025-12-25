#include "physics_object_userdata.h"
#include <gameobject/gameobject_ddf.h> // dmGameObjectDDF enable/disable

#define USERDATA_METATABLE "PHYSICS_OBJECT_USERDATA"

static const dmhash_t LINEAR_VELOCITY_HASH = dmHashString64("linear_velocity");

namespace dmScript {
dmMessage::URL *CheckURL(lua_State *L, int index);
}

namespace dmGameObject {
PropertyResult GetProperty(HInstance instance, dmhash_t component_id, dmhash_t property_id, PropertyOptions options, PropertyDesc &out_value);
PropertyResult SetProperty(HInstance instance, dmhash_t component_id, dmhash_t property_id, PropertyOptions options, const PropertyVar &value);
} // namespace dmGameObject

namespace d954masPhysicsUtils {

static dmArray<PhysicsObjectUserdata *> physics_list;

static void PhysicsObjectRemove(PhysicsObjectUserdata *userdata) {
    for (int i = 0; i < physics_list.Size(); ++i) {
        if (physics_list[i] == userdata) {
            userdata->inList = false;
            physics_list.EraseSwap(i);
            return;
        }
    }
}

PhysicsObjectUserdata::PhysicsObjectUserdata(dmGameObject::HInstance rootInstance, dmMessage::URL collisionUrl, dmGameObject::HInstance collisionInstance,
                                             dmVMath::Vector3 *position, dmVMath::Vector3 *velocity) : rootInstance(rootInstance),
                                                                                                       collisionUrl(collisionUrl),
                                                                                                       collisionInstance(collisionInstance),
                                                                                                       position(position),
                                                                                                       velocity(velocity),
                                                                                                       updatePosition(true),
                                                                                                       inList(true) {
    if (physics_list.Full()) {
        physics_list.OffsetCapacity(16);
    }
    physics_list.Push(this);
}

PhysicsObjectUserdata::~PhysicsObjectUserdata() {
    if (inList) {
        dmLogWarning("PhysicsObjectUserdata was not removed.Removed by GC");
        PhysicsObjectRemove(this);
    }
}

static PhysicsObjectUserdata *PhysicsObjectUserdataCheck(lua_State *L, int index) {
    PhysicsObjectUserdata *object = *(PhysicsObjectUserdata **)luaL_checkudata(L, index, USERDATA_METATABLE);
    if (!object->inList) {
        luaL_error(L, "PhysicsObjectUserdata already destroyed");
    }
    return object;
}

static int LuaPhysicsObjectUserdataGC(lua_State *L) {
    PhysicsObjectUserdata *userdata = *(PhysicsObjectUserdata **)luaL_checkudata(L, 1, USERDATA_METATABLE);
    delete userdata;
    return 0;
}

static int LuaPhysicsObjectDestroy(lua_State *L) {
    PhysicsObjectUserdata *userdata = PhysicsObjectUserdataCheck(L, 1);
    PhysicsObjectRemove(userdata);
    return 0;
}

static int LuaPhysicsObjectSetUpdatePosition(lua_State *L) {
    PhysicsObjectUserdata *userdata = PhysicsObjectUserdataCheck(L, 1);
    userdata->updatePosition = lua_toboolean(L, 2);
    return 0;
}

static const luaL_Reg LuaPhysicsObjectMethods[] = {
    {"__gc", LuaPhysicsObjectUserdataGC},
    {"destroy", LuaPhysicsObjectDestroy},
    {"set_update_position", LuaPhysicsObjectSetUpdatePosition},
    {0, 0}};

int LuaCreatePhysicsObject(lua_State *L) {
    dmGameObject::HInstance rootInstance = dmScript::CheckGOInstance(L, 1);
    if (rootInstance == 0) {
        dmMessage::URL *rootUrl = dmScript::CheckURL(L, 1);
        return luaL_error(L, "Could not find any instance with id:%s", dmHashReverseSafe64(rootUrl->m_Path));
    }
    dmMessage::URL *collisionUrl = dmScript::CheckURL(L, 2);
    dmGameObject::HInstance collisionInstance = dmScript::CheckGOInstance(L, 2);  
    if (collisionInstance == 0) {
        return luaL_error(L, "Could not find any instance with id:%s", dmHashReverseSafe64(collisionUrl->m_Path));
    }
    Vectormath::Aos::Vector3 *position = dmScript::CheckVector3(L, 3);
    Vectormath::Aos::Vector3 *linear_velocity = dmScript::CheckVector3(L, 4);

    PhysicsObjectUserdata *userdata = new PhysicsObjectUserdata(rootInstance, *collisionUrl, collisionInstance, position, linear_velocity);
    PhysicsObjectUserdata **ud = (PhysicsObjectUserdata **)lua_newuserdata(L, sizeof(PhysicsObjectUserdata *));
    *ud = userdata;
    if (luaL_newmetatable(L, USERDATA_METATABLE)) {
        lua_pushvalue(L, -1);
        lua_setfield(L, -2, "__index");
        luaL_register(L, 0, LuaPhysicsObjectMethods);
    }
    lua_setmetatable(L, -2);
    return 1;
}

int LuaPhysicsObjectsUpdateVariables(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);

    for (int i = 0; i < physics_list.Size(); i++) {
        PhysicsObjectUserdata *obj = physics_list[i];
        if (!obj->updatePosition) {
            continue;
        }

        *obj->position = Vectormath::Aos::Vector3(GetPosition(obj->rootInstance));

        // linear velocity
        dmGameObject::PropertyOptions property_options;
        dmGameObject::PropertyDesc property_desc;
        property_options.m_Index = 0;
        property_options.m_HasKey = 0;

        dmGameObject::PropertyResult result = dmGameObject::GetProperty(obj->collisionInstance, obj->collisionUrl.m_Fragment, LINEAR_VELOCITY_HASH, property_options, property_desc);
        switch (result) {
        case dmGameObject::PROPERTY_RESULT_OK: {
            break;
        }
        case dmGameObject::PROPERTY_RESULT_RESOURCE_NOT_FOUND: {
            luaL_error(L, "Property '%s' not found!", dmHashReverseSafe64(LINEAR_VELOCITY_HASH));
        }
        case dmGameObject::PROPERTY_RESULT_INVALID_INDEX: {
            return luaL_error(L, "Invalid index %d for property '%s'", property_options.m_Index + 1, dmHashReverseSafe64(LINEAR_VELOCITY_HASH));
        }
        case dmGameObject::PROPERTY_RESULT_INVALID_KEY: {
            return luaL_error(L, "Invalid key '%s' for property '%s'", dmHashReverseSafe64(property_options.m_Key), dmHashReverseSafe64(LINEAR_VELOCITY_HASH));
        }
        case dmGameObject::PROPERTY_RESULT_NOT_FOUND: {
            const char *path = dmHashReverseSafe64(obj->collisionUrl.m_Path);
            const char *property = dmHashReverseSafe64(LINEAR_VELOCITY_HASH);
            if (obj->collisionUrl.m_Fragment) {
                luaL_error(L, "'%s#%s' does not have any property called '%s'", path, dmHashReverseSafe64(obj->collisionUrl.m_Fragment), property);
            }
            luaL_error(L, "'%s' does not have any property called '%s'", path, property);
        }
        case dmGameObject::PROPERTY_RESULT_COMP_NOT_FOUND:
            return luaL_error(L, "Could not find component '%s' when resolving '%s'", dmHashReverseSafe64(obj->collisionUrl.m_Fragment), lua_tostring(L, 1));
        default:
            // Should never happen, programmer error
            return luaL_error(L, "go.get failed with error code %d", result);
        }

        obj->velocity->setX(property_desc.m_Variant.m_V4[0]);
        obj->velocity->setY(property_desc.m_Variant.m_V4[1]);
        obj->velocity->setZ(property_desc.m_Variant.m_V4[2]);

        // dmLogInfo("velocity:%f %f %f",property_desc.m_Variant.m_V4[0],property_desc.m_Variant.m_V4[1],property_desc.m_Variant.m_V4[2]);
    }

    return 0;
}

int LuaPhysicsObjectsUpdateLinearVelocity(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);

    for(int i=0;i<physics_list.Size();i++){
        PhysicsObjectUserdata* obj = physics_list[i];
        if(!obj->updatePosition){continue;}

        dmGameObject::PropertyOptions property_options;
        property_options.m_Index = 0;
        property_options.m_HasKey = 0;

        dmGameObject::PropertyVar property_var;
        property_var.m_Type =  dmGameObject::PROPERTY_TYPE_VECTOR3;
        property_var.m_V4[0] = obj->velocity->getX();
        property_var.m_V4[1] = obj->velocity->getY();
        property_var.m_V4[2] = obj->velocity->getZ();

        dmGameObject::PropertyResult result = dmGameObject::SetProperty(obj->collisionInstance, obj->collisionUrl.m_Fragment, LINEAR_VELOCITY_HASH, property_options, property_var);
        switch (result){
            case dmGameObject::PROPERTY_RESULT_OK:
                break;
           default:
                // Should never happen, programmer error
                luaL_error(L, "go.set failed with error code %d", result);
        }
    }

 return 0;
}

} // namespace d954masGame
