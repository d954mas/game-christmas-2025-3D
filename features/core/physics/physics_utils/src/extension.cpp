#define EXTENSION_NAME PhysicsUtils
#define LIB_NAME "PhysicsUtils"
#define MODULE_NAME "physics_utils"

#include <dmsdk/sdk.h>
#include "physics_object_userdata.h"
#include "physics_utils.h"

// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
    {"new_physics_object", d954masPhysicsUtils::LuaCreatePhysicsObject},
    {"physics_objects_update_variables", d954masPhysicsUtils::LuaPhysicsObjectsUpdateVariables},
    {"physics_objects_update_linear_velocity", d954masPhysicsUtils::LuaPhysicsObjectsUpdateLinearVelocity},
    {"physics_raycast_single_exist", d954masPhysicsUtils::LuaPhysicsUtilsRayCastSingleExist},
    {"physics_raycast_single", d954masPhysicsUtils::LuaPhysicsUtilsRayCastSingle},
    {"physics_count_mask", d954masPhysicsUtils::LuaPhysicsUtilsCountMask},
    {0, 0}
};

static void LuaInit(lua_State *L) {
    int top = lua_gettop(L);
    luaL_register(L, MODULE_NAME, Module_methods);
    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result InitializeMyExtension(dmExtension::Params *params) {
    // Init Lua
    LuaInit(params->m_L);
    printf("Registered %s Extension\n", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, 0, 0, InitializeMyExtension, 0, 0, 0)