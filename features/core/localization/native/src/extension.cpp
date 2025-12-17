#define EXTENSION_NAME Localization
#define LIB_NAME "Localization"
#define MODULE_NAME "localization"

#include <dmsdk/sdk.h>

namespace dmScript {
    dmResource::HFactory GetResourceFactory(HContext context);
    HContext GetScriptContext(lua_State *L);
} // namespace dmScript


static int LoadLocalizationFromResources(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 1);
    const char *filename = luaL_checkstring(L, 1);
    dmScript::HContext context = dmScript::GetScriptContext(L);

    void *resource;
    uint32_t resource_size;
    dmResource::Result r = dmResource::GetRaw(dmScript::GetResourceFactory(context), filename, &resource, &resource_size);
    if (r != dmResource::RESULT_OK) {
        return DM_LUA_ERROR("Failed to load localization %s. (code: %d)", filename, r);
    }
    int jsontop = lua_gettop(L);
    int ret = dmScript::JsonToLua(L, (const char *)resource, resource_size);
    if (ret != 1) {
        lua_pop(L, lua_gettop(L) - jsontop);
        lua_pushnil(L);
    }
    free(resource);

    // Get the order array
    lua_getfield(L, jsontop + 1, "order");
    int order_idx = lua_gettop(L);
    int order_size = lua_objlen(L, order_idx);

    // Initialize the localization table with language keys
    for (int i = 1; i <= order_size; ++i) {
        lua_newtable(L);              // Create a new table for this language
        lua_rawgeti(L, order_idx, i); // Get the language code
        lua_pushvalue(L, -2);         // Duplicate the table
        lua_settable(L, jsontop + 1); // Set the field with the language code as the key
    }
    // Stack: ... (JSON table) (order array) (languages tables...)
    lua_getfield(L, jsontop + 1, "localization");
    // Stack: ... (JSON table) (order array) (languages tables...)(localization table)
    int localization_idx = lua_gettop(L);

    // Iterate over each key in the localization table
    lua_pushnil(L); // First key
    while (lua_next(L, localization_idx) != 0) {
        const char *key = lua_tostring(L, -2);
        int translations_idx = lua_gettop(L);
        // Iterate over the order array
        for (int i = 1; i <= order_size; ++i) {
            lua_rawgeti(L, translations_idx, i); // Get the translation
            lua_setfield(L, jsontop + 2 + i, key);
        }

        lua_pop(L, 1); // Pop the value, keep the key for the next iteration
        // Stack: ... (JSON table) (order array) (localization table) (key)
    }

    // Clean up the stack, remove original JSON table and order array
    lua_pushnil(L);
    lua_setfield(L, jsontop + 1, "localization");
    lua_pushnil(L);
    lua_setfield(L, jsontop + 1, "order");

    // pop all stack. Keep only json table
    lua_settop(L, jsontop + 1);

    return 1;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
    {"load_localization_from_resources", LoadLocalizationFromResources},
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