#define EXTENSION_NAME LoadFromResources
#define LIB_NAME "LoadFromResources"
#define MODULE_NAME "load_from_resources"

#include <dmsdk/sdk.h>

namespace dmScript {
dmResource::HFactory GetResourceFactory(HContext context);
HContext GetScriptContext(lua_State *L);
} // namespace dmScript

namespace dmResource {
Result GetRaw(HFactory factory, const char *name, void **resource, uint32_t *resource_size);
}

static int LoadJsonFromResources(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 1);
    const char *filename = luaL_checkstring(L, 1);
    dmScript::HContext context = dmScript::GetScriptContext(L);

    void *resource;
    uint32_t resource_size;
    dmResource::Result r = dmResource::GetRaw(dmScript::GetResourceFactory(context), filename, &resource, &resource_size);
    if (r != dmResource::RESULT_OK) {
        return DM_LUA_ERROR("Failed to load resource %s. (code: %d)", filename, r);
    }
    int jsontop = lua_gettop(L);
    int ret = dmScript::JsonToLua(L, (const char *)resource, resource_size);
    if (ret != 1) {
        lua_pop(L, lua_gettop(L) - jsontop);
        lua_pushnil(L);
    }
    free(resource);
    return 1;
}


// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
    {"load_json", LoadJsonFromResources},
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
    printf("Registered %s Extension", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, 0, 0, InitializeMyExtension, 0, 0, 0)