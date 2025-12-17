// Extension lib defines
#define LIB_NAME "CryptExtension"
#define MODULE_NAME "crypt"

#include <dmsdk/sdk.h>
#include <dmsdk/dlib/crypt.h>

static int Crypt_Base64Encode(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 1);

    size_t srclen;
    const char* src = luaL_checklstring(L, 1, &srclen);

    // 4 characters to represent every 3 bytes with padding applied
    // for binary data which isn't an exact multiple of 3 bytes.
    // https://stackoverflow.com/a/7609180/1266551
    uint32_t dstlen = srclen * 4 / 3 + 4;
    uint8_t* dst = (uint8_t*)malloc(dstlen);

    if (dmCrypt::Base64Encode((const uint8_t*)src, srclen, dst, &dstlen))
    {
        lua_pushlstring(L, (char*)dst, dstlen);
    }
    else
    {
        lua_pushnil(L);
    }
    free(dst);
    return 1;
}
/*
static int Crypt_Base64Decode(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 1);

    size_t srclen;
    const char* src = luaL_checklstring(L, 1, &srclen);

    uint32_t dstlen = srclen * 3 / 4;
    uint8_t* dst = (uint8_t*)malloc(dstlen);

    if (dmCrypt::Base64Decode((const uint8_t*)src, srclen, dst, &dstlen))
    {
        lua_pushlstring(L, (char*)dst, dstlen);
    }
    else
    {
        lua_pushnil(L);
    }
    free(dst);
    return 1;
}*/

static int Crypt_Encrypt(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);

    size_t srclen;
    const char* src = luaL_checklstring(L, 1, &srclen);

    size_t keylen;
    const char* key = luaL_checklstring(L, 2, &keylen);

    uint32_t dstlen = srclen;
    char* dst = (char*) malloc(dstlen);
    memcpy(dst, src, dstlen);
    dmCrypt::Result result = dmCrypt::Encrypt(dmCrypt::ALGORITHM_XTEA, (uint8_t*)dst, dstlen, (uint8_t*)key, keylen);
    if(result != dmCrypt::RESULT_OK){
        free(dst);
        return luaL_error(L, "error when encrypt");
    }else{
        // 4 characters to represent every 3 bytes with padding applied
        // for binary data which isn't an exact multiple of 3 bytes.
        // https://stackoverflow.com/a/7609180/1266551
        uint32_t base64len = dstlen * 4 / 3 + 4;
        uint8_t* base64dst = (uint8_t*)malloc(base64len);
        if (dmCrypt::Base64Encode((const uint8_t*)dst, dstlen, base64dst, &base64len)){
            lua_pushlstring(L, (char*)base64dst, base64len);
            free(dst);
            free(base64dst);
        }else{
            lua_pushnil(L);
            free(dst);
            free(base64dst);
             return luaL_error(L, "error when encrypt. Base64Encode error");
        }
    }
    return 1;
}

static int Crypt_Decrypt(lua_State* L) {
    DM_LUA_STACK_CHECK(L, 1);

    size_t srclen;
    const char* src = luaL_checklstring(L, 1, &srclen);

    size_t keylen;
    const char* key = luaL_checklstring(L, 2, &keylen);

    // Decode Base64 first
    uint32_t dstlen = srclen * 3 / 4;
    char* dst = (char*)malloc(dstlen);
    if (!dmCrypt::Base64Decode((const uint8_t*)src, srclen,  (uint8_t*)dst, &dstlen)) {
        free(dst);
        return luaL_error(L, "error when decrypt. Base64Decode error");
    }


    dmCrypt::Result result = dmCrypt::Decrypt(dmCrypt::ALGORITHM_XTEA, (uint8_t*)dst, dstlen, (uint8_t*)key, keylen);
    if (result != dmCrypt::RESULT_OK) {
        free(dst);
        return luaL_error(L, "error when decrypt");
    } else {
        lua_pushlstring(L, dst, dstlen);
        free(dst);
    }

    return 1;
}


static const luaL_reg Module_methods[] =
{
    {"encode_base64", Crypt_Base64Encode},
   // {"decode_base64", Crypt_Base64Decode},
    {"encrypt", Crypt_Encrypt},
    {"decrypt", Crypt_Decrypt},
    {0, 0}
};

static void LuaInit(lua_State* L)
{
    int top = lua_gettop(L);

    // Register lua names
    luaL_register(L, MODULE_NAME, Module_methods);

    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

dmExtension::Result InitializeCryptExtension(dmExtension::Params* params)
{
    // Init Lua
    LuaInit(params->m_L);
    dmLogInfo("Registered %s Extension", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(CryptExtension, LIB_NAME, 0, 0, InitializeCryptExtension, 0, 0, 0)
