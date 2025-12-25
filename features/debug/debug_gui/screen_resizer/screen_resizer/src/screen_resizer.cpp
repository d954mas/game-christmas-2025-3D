#define EXTENSION_NAME ScreenResizer
#define LIB_NAME "ScreenResizer"
#define MODULE_NAME "screen_resizer"

// include the Defold SDK
#include <dmsdk/sdk.h>

#include <math.h>

#if defined(DM_PLATFORM_OSX) || defined(DM_PLATFORM_WINDOWS) || defined(DM_PLATFORM_LINUX)
#include <stdlib.h>

#ifndef __APPLE__
#define SEA_MENU_IMPLEMENTATION
#endif
#include "sea_menu.h"

static seam_menu_data* g_CurrentMenu = 0x0;

#if defined(DM_PLATFORM_WINDOWS)
#include <Windows.h>
#endif

#if defined(DM_PLATFORM_OSX)
#import <AppKit/AppKit.h>
static NSWindow* g_Window = nil;
static NSView* g_View = nil;
#endif

#if defined(DM_PLATFORM_LINUX)
#include <X11/Xlib.h>
static Display* g_Display = NULL;
static Window g_Window = 0;
static Window g_Root = 0;
static int g_Screen = 0;
#endif

struct WinRect
{
    float x;
    float y;
    float w;
    float h;
};

#define CHECK_CURRENT_MENU() \
{ \
    if (g_CurrentMenu == 0x0) { \
        luaL_error(L, "Missing call to screen_resizer.menu_begin()!"); \
    } \
} \

static int ScreenResizer_MenuBegin(lua_State* L)
{
    if (g_CurrentMenu != 0x0) {
        seam_release(g_CurrentMenu);
        g_CurrentMenu = 0x0;
    }
    g_CurrentMenu = seam_begin();
    return 0;
}

static int ScreenResizer_MenuLabel(lua_State* L)
{
    CHECK_CURRENT_MENU();

    luaL_checktype(L, 2, LUA_TBOOLEAN);
    seam_item_label(g_CurrentMenu, luaL_checkinteger(L, 1), lua_toboolean(L, 2), (char*)luaL_checkstring(L, 3));
    return 0;
}

static int ScreenResizer_MenuFinish(lua_State* L)
{
    CHECK_CURRENT_MENU();
    seam_end( g_CurrentMenu );
    return 0;
}

static int ScreenResizer_MenuShow(lua_State* L)
{
    CHECK_CURRENT_MENU();
    lua_pushinteger(L, seam_open_menu( g_CurrentMenu, luaL_checkinteger(L, 1), luaL_checkinteger(L, 2) ));
    seam_release( g_CurrentMenu );
    g_CurrentMenu = 0x0;
    return 1;
}

static void ScreenResizer_InitPlatform()
{
#if defined(DM_PLATFORM_OSX)
    g_Window = dmGraphics::GetNativeOSXNSWindow();
    g_View = dmGraphics::GetNativeOSXNSView();
#endif

#if defined(DM_PLATFORM_LINUX)
    g_Display = XOpenDisplay(NULL);
    if (g_Display) {
        g_Screen = DefaultScreen(g_Display);
        g_Window = dmGraphics::GetNativeX11Window();
        g_Root = XDefaultRootWindow(g_Display);
    }
#endif
}

static void ScreenResizer_FinalPlatform()
{
#if defined(DM_PLATFORM_LINUX)
    if (g_Display) {
        XCloseDisplay(g_Display);
        g_Display = NULL;
        g_Window = 0;
        g_Root = 0;
        g_Screen = 0;
    }
#endif
}

static void ScreenResizer_SetViewSize(float x, float y, float w, float h)
{
#if defined(DM_PLATFORM_WINDOWS)
    HWND window = dmGraphics::GetNativeWindowsHWND();
    if (isnan(x) || isnan(y))
    {
        HMONITOR hMonitor = MonitorFromWindow(window, MONITOR_DEFAULTTONEAREST);
        MONITORINFO monitorInfo;
        monitorInfo.cbSize = sizeof(monitorInfo);
        GetMonitorInfo(hMonitor, &monitorInfo);
        if (isnan(x)) { x = (monitorInfo.rcMonitor.left + monitorInfo.rcMonitor.right - w) / 2; }
        if (isnan(y)) { y = (monitorInfo.rcMonitor.top + monitorInfo.rcMonitor.bottom - h) / 2; }
    }

    RECT rect = {0, 0, (int)w, (int)h};
    DWORD style = (DWORD)GetWindowLongPtr(window, GWL_STYLE);
    AdjustWindowRect(&rect, style, false);
    SetWindowPos(window, window, (int)x, (int)y, rect.right - rect.left, rect.bottom - rect.top, SWP_NOZORDER);
#endif

#if defined(DM_PLATFORM_OSX)
    if (!g_Window || !g_View) { return; }
    if (isnan(x)) {
        NSRect frame = g_Window.screen.frame;
        x = floorf(frame.origin.x + (frame.size.width - w) * 0.5f);
    }
    float win_y;
    if (isnan(y)) {
        NSRect frame = g_Window.screen.frame;
        win_y = floorf(frame.origin.y + (frame.size.height - h) * 0.5f);
    } else {
        win_y = NSMaxY(NSScreen.screens[0].frame) - h - y;
    }

    NSRect viewFrame = [g_View convertRect:g_View.bounds toView:nil];
    NSRect windowFrame = g_Window.frame;
    NSRect rect = NSMakeRect(
        x - viewFrame.origin.x,
        win_y - viewFrame.origin.x,
        w + viewFrame.origin.x + windowFrame.size.width - viewFrame.size.width,
        h + viewFrame.origin.y + windowFrame.size.height - viewFrame.size.height
    );
    [g_Window setFrame:rect display:YES];
#endif

#if defined(DM_PLATFORM_LINUX)
    if (!g_Display) { return; }
    if (isnan(x) || isnan(y))
    {
        int screen_w = DisplayWidth(g_Display, g_Screen);
        int screen_h = DisplayHeight(g_Display, g_Screen);
        if (isnan(x)) { x = (screen_w - w) / 2.0f; }
        if (isnan(y)) { y = (screen_h - h) / 2.0f; }
    }

    XMoveResizeWindow(g_Display, g_Window, (int)x, (int)y, (unsigned int)w, (unsigned int)h);
    XFlush(g_Display);
#endif
}

static WinRect ScreenResizer_GetViewSize()
{
    WinRect rect = {0.0f, 0.0f, 0.0f, 0.0f};
#if defined(DM_PLATFORM_WINDOWS)
    HWND window = dmGraphics::GetNativeWindowsHWND();
    RECT wrect;
    GetClientRect(window, &wrect);
    POINT pos = {wrect.left, wrect.top};
    ClientToScreen(window, &pos);
    rect.x = (float)pos.x;
    rect.y = (float)pos.y;
    rect.w = (float)(wrect.right - wrect.left);
    rect.h = (float)(wrect.bottom - wrect.top);
#endif

#if defined(DM_PLATFORM_OSX)
    if (!g_Window || !g_View) { return rect; }
    NSRect viewFrame = [g_View convertRect:g_View.bounds toView:nil];
    NSRect windowFrame = [g_Window frame];
    viewFrame.origin.x += windowFrame.origin.x;
    viewFrame.origin.y += windowFrame.origin.y;
    rect.x = viewFrame.origin.x;
    rect.y = NSMaxY(NSScreen.screens[0].frame) - NSMaxY(viewFrame);
    rect.w = viewFrame.size.width;
    rect.h = viewFrame.size.height;
#endif

#if defined(DM_PLATFORM_LINUX)
    if (!g_Display) { return rect; }
    int x, y;
    unsigned int w, h, bw, depth;
    Window dummy;
    XGetGeometry(g_Display, g_Window, &dummy, &x, &y, &w, &h, &bw, &depth);
    XTranslateCoordinates(g_Display, g_Window, g_Root, 0, 0, &x, &y, &dummy);
    rect.x = (float)x;
    rect.y = (float)y;
    rect.w = (float)w;
    rect.h = (float)h;
#endif

    return rect;
}

static int ScreenResizer_SetViewSizeLua(lua_State* L){

    float x = nanf("");
    if (!lua_isnil(L, 1))
    {
        x = luaL_checknumber(L, 1);
    }
    float y = nanf("");
    if (!lua_isnil(L, 2))
    {
        y = luaL_checknumber(L, 2);
    }
    float w = luaL_checknumber(L, 3);
    float h = luaL_checknumber(L, 4);
    ScreenResizer_SetViewSize(x, y, w, h);
    return 0;
}

static int ScreenResizer_GetViewSizeLua(lua_State* L){
    WinRect rect = ScreenResizer_GetViewSize();
    lua_pushnumber(L, rect.x);
    lua_pushnumber(L, rect.y);
    lua_pushnumber(L, rect.w);
    lua_pushnumber(L, rect.h);
    return 4;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] ={
    {"menu_begin", ScreenResizer_MenuBegin},
    {"menu_label", ScreenResizer_MenuLabel},
    {"menu_finish", ScreenResizer_MenuFinish},
    {"menu_show", ScreenResizer_MenuShow},
    {"set_view_size", ScreenResizer_SetViewSizeLua},
    {"get_view_size", ScreenResizer_GetViewSizeLua},
    {0, 0}
};

static void LuaInit(lua_State* L){
    int top = lua_gettop(L);

    // Register lua names
    luaL_register(L, MODULE_NAME, Module_methods);

    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result InitializeMnu(dmExtension::Params* params){
    ScreenResizer_InitPlatform();
    LuaInit(params->m_L);
    return dmExtension::RESULT_OK;
}


static dmExtension::Result FinalizeMnu(dmExtension::Params* params){
    ScreenResizer_FinalPlatform();
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, 0, 0, InitializeMnu, 0, 0, FinalizeMnu)

#else

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, 0, 0, 0, 0, 0, 0)
#endif
