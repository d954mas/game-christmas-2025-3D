#define EXTENSION_NAME BufferUtils
#define LIB_NAME "BufferUtils"
#define MODULE_NAME "buffer_utils"

#include <dmsdk/sdk.h>

static int FillStreamFloats(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    dmBuffer::HBuffer buffer = dmScript::CheckBufferUnpack(L, 1);
    dmhash_t streamName = dmScript::CheckHashOrString(L, 2);
    int componentsSize = lua_tonumber(L, 3);
    if (!lua_istable(L, 4)) {
        return DM_LUA_ERROR("data not table");
    }

    float *values = 0x0;
    uint32_t sizeBuffer = 0;
    uint32_t components = 0;
    uint32_t stride = 0;
    dmBuffer::Result dataResult = dmBuffer::GetStream(buffer, streamName, (void **)&values, &sizeBuffer, &components, &stride);
    if (dataResult != dmBuffer::RESULT_OK) {
        return DM_LUA_ERROR("can't get stream");
    }

    if (components != componentsSize) {
        return DM_LUA_ERROR("stream have: %d components. Need %d", components, componentsSize);
    }

    int size = luaL_getn(L, 3);
    if (size / components >= sizeBuffer) {
        return DM_LUA_ERROR("buffer not enough size");
    }

    for (int i = 0; i < sizeBuffer; ++i) {
        for (int j = 0; j < components; ++j) {
            lua_rawgeti(L, 4, i * components + j + 1);
            values[j] = lua_tonumber(L, -1);
            lua_pop(L, 1);
        }
        values += stride;
    }
    dmBuffer::UpdateContentVersion(buffer);
    return 0;
}

// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
    {"fill_stream_floats", FillStreamFloats},
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