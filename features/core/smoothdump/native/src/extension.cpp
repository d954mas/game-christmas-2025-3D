#define EXTENSION_NAME SmoothDump
#define LIB_NAME "SmoothDump"
#define MODULE_NAME "smooth_dump"

#include <dmsdk/sdk.h>

inline void check_arg_count(lua_State *L, int count_exact) {
    int count = lua_gettop(L);
    if (count != count_exact) {
        luaL_error(L, "This function requires %d arguments. Got %d.", count_exact, count);
    }
}


static int SmoothDumpV3(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
	check_arg_count(L, 7);

    dmVMath::Vector3 *currentV3 = dmScript::CheckVector3(L, 1);
    dmVMath::Vector3 current = *currentV3;
    dmVMath::Vector3 target = *dmScript::CheckVector3(L, 2);
    dmVMath::Vector3 *currentVelocity = dmScript::CheckVector3(L, 3);
    dmVMath::Vector3 velocity = *currentVelocity;

    float smoothTime = luaL_checknumber(L,4);
    float maxSpeed = luaL_checknumber(L,5);
    float maxDistance = luaL_checknumber(L,6);
    float dt = luaL_checknumber(L,7);


    smoothTime = fmax(0.0001, smoothTime);

    float num = (2.0 / smoothTime);
    float num2 = (num * dt);
    float d = (1.0 / (1.0 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2));



    dmVMath::Vector3 vector = (current - target);
    dmVMath::Vector3 vector2 = target;

    float maxLength = (maxSpeed * smoothTime);

    vector = Vectormath::Aos::length(vector) > maxLength ? (Vectormath::Aos::normalize(vector) * maxLength) : vector; // Clamp magnitude.
    dmVMath::Vector3 distance = (current - vector);

    dmVMath::Vector3 vector3 = ((velocity + num * vector) * dt);
    velocity = ((velocity - num * vector3) * d);

    dmVMath::Vector3 vector4 = (distance + (vector + vector3) * d);
    if(Vectormath::Aos::dot(vector2 - current,vector4 - vector2)>0){
        vector4 = vector2;
        velocity = ((vector4 - vector2) / dt);
    }

    *currentV3 = vector4;
    *currentVelocity = velocity;

    //check maxDistance
    vector = vector4-target;
    if(Vectormath::Aos::length(vector)>maxDistance){
        dmVMath::Vector3 dmove = Vectormath::Aos::normalize(vector) * maxDistance;
        *currentV3 =  target+dmove;
    }

	return 0;
}



// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
    { "smooth_dump_v3", SmoothDumpV3},
    {0, 0}
};

static void LuaInit(lua_State *L) {
    int top = lua_gettop(L);
    luaL_register(L, MODULE_NAME, Module_methods);
    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result AppInitializeMyExtension(dmExtension::AppParams *params) { return dmExtension::RESULT_OK; }
static dmExtension::Result InitializeMyExtension(dmExtension::Params *params) {
    // Init Lua
    LuaInit(params->m_L);
    printf("Registered %s Extension\n", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

static dmExtension::Result AppFinalizeMyExtension(dmExtension::AppParams *params) { return dmExtension::RESULT_OK; }

static dmExtension::Result FinalizeMyExtension(dmExtension::Params *params) { return dmExtension::RESULT_OK; }

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, AppInitializeMyExtension, AppFinalizeMyExtension, InitializeMyExtension, 0, 0, FinalizeMyExtension)