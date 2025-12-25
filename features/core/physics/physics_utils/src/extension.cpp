#define EXTENSION_NAME PhysicsUtils
#define LIB_NAME "PhysicsUtils"
#define MODULE_NAME "physics_utils"

#include <dmsdk/sdk.h>

// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
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