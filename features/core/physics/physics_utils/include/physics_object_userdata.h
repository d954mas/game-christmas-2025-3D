#ifndef d954mas_physics_utils_object_userdata_h
#define d954mas_physics_utils_object_userdata_h

#include <dmsdk/sdk.h>

namespace d954masPhysicsUtils {

class PhysicsObjectUserdata {
  public:
    dmGameObject::HInstance rootInstance;
    dmMessage::URL collisionUrl;
    dmGameObject::HInstance collisionInstance;
    dmVMath::Vector3 *position;
    dmVMath::Vector3 *velocity;
    bool updatePosition;
    bool inList;

    explicit PhysicsObjectUserdata(dmGameObject::HInstance rootInstance, dmMessage::URL collisionUrl, dmGameObject::HInstance collisionInstance,
                                   dmVMath::Vector3 *position, dmVMath::Vector3 *velocity);
    ~PhysicsObjectUserdata();
};

// lua binding
int LuaCreatePhysicsObject(lua_State *L);
int LuaPhysicsObjectsUpdateVariables(lua_State *L);
int LuaPhysicsObjectsUpdateLinearVelocity(lua_State *L);

} // namespace d954masPhysicsUtils

#endif