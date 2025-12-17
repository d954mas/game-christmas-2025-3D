#define EXTENSION_NAME html_utils
#define LIB_NAME "html_utils"
#define MODULE_NAME "html_utils"

#include <dmsdk/sdk.h>

#if defined(DM_PLATFORM_HTML5)

typedef void (*LoadCallback)(int status, const char *data, int dataLength);

extern "C" void HtmlHtmlUtilsHideBg();
extern "C" bool HtmlHtmlUtilsCanvasFocus();
extern "C" bool HtmlHtmlUtilsLoadLiveUpdate();
extern "C" bool HtmlHtmlUtilsLoadLiveUpdateSetPercentage(float percentage);
extern "C" void HtmlHtmlUtilsLoad(const char *path, LoadCallback callback);
extern "C" void HtmlHtmlUtilsSave(const char *path, const char *data, LoadCallback callback);
extern "C" bool HtmlHtmlUtilsIsMobile();

static lua_State *g_L = 0x0;

static int LuaHtmlUtilsHideBg(lua_State *L) {
    HtmlHtmlUtilsHideBg();
    return 0;
}

static int LuaHtmlUtilsCanvasFocus(lua_State *L) {
    HtmlHtmlUtilsCanvasFocus();
    return 0;
}

void load_Callback(int status, const char *data, int length) {
    lua_State *L = g_L;
    lua_pushboolean(L, status == 1);
    lua_pushlstring(L, data, length);
}

static int LuaHtmlHtmlUtilsLoad(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 2);
    const char *path = luaL_checkstring(L, 1);
    g_L = L; // Save the Lua state globally
    HtmlHtmlUtilsLoad(path, (LoadCallback)load_Callback);
    g_L = 0x0;
    return 2;
}

static int LuaHtmlHtmlUtilsSave(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 2);
    const char *path = luaL_checkstring(L, 1);
    const char *data = luaL_checkstring(L, 2);
    g_L = L; // Save the Lua state globally
    HtmlHtmlUtilsSave(path, data, (LoadCallback)load_Callback);
    g_L = 0x0;
    return 2;
}

static int LuaHtmlHtmlUtilsLoadLiveUpdate(lua_State *L) {
    HtmlHtmlUtilsLoadLiveUpdate();
    return 0;
}

static int LuaHtmlUtilsLoadLiveUpdateSetPercentage(lua_State *L) {
    HtmlHtmlUtilsLoadLiveUpdateSetPercentage(lua_tonumber(L, 1));
    return 0;
}

static int LuaHtmlUtilsIsMobile(lua_State *L) {
    lua_pushboolean(L, HtmlHtmlUtilsIsMobile());
    return 1;
}

static const luaL_reg Module_methods[] = {
    {"hide_bg", LuaHtmlUtilsHideBg},
    {"focus", LuaHtmlUtilsCanvasFocus},
    {"load_data", LuaHtmlHtmlUtilsLoad},
    {"save_data", LuaHtmlHtmlUtilsSave},
    {"liveupdate_load", LuaHtmlHtmlUtilsLoadLiveUpdate},
    {"liveupdate_load_set_percentage", LuaHtmlUtilsLoadLiveUpdateSetPercentage},
    {"is_mobile", LuaHtmlUtilsIsMobile},
    {0, 0}};

static void LuaInit(lua_State *L) {
    int top = lua_gettop(L);
    luaL_register(L, MODULE_NAME, Module_methods);
    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result InitializeMyExtension(dmExtension::Params *params) {
    LuaInit(params->m_L);
    printf("Registered %s Extension\n", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

#else

static dmExtension::Result InitializeMyExtension(dmExtension::Params *params) { return dmExtension::RESULT_OK; }

#endif

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, 0, 0, InitializeMyExtension, 0, 0, 0)
