#ifndef d954mas_physics_utils_h
#define d954mas_physics_utils_h

#include <dmsdk/sdk.h>
#include "physics_defold.h"

namespace d954masPhysicsUtils {


int LuaPhysicsUtilsRayCastSingleExist(lua_State *L);
int LuaPhysicsUtilsRayCastSingle(lua_State *L);
int LuaPhysicsUtilsCountMask(lua_State *L);

}

#endif