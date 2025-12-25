
#include "physics_utils.h"
static const char PHYSICS_CONTEXT_NAME[] = "__PhysicsContext";
static const uint32_t PHYSICS_CONTEXT_HASH = dmHashBuffer32(PHYSICS_CONTEXT_NAME, strlen(PHYSICS_CONTEXT_NAME));
static const dmhash_t HASH_POSITION = dmHashString64("position");
static char *COLLISION_OBJECT_EXT = "collisionobjectc";

namespace dmGameObject {
void GetComponentUserDataFromLua(lua_State *L, int index, HCollection collection, const char *component_ext, uintptr_t *out_user_data, dmMessage::URL *out_url, void **world);
PropertyResult GetProperty(HInstance instance, dmhash_t component_id, dmhash_t property_id, PropertyOptions options, PropertyDesc &out_value);
void *GetWorld(HCollection collection, uint32_t component_type_index);

} // namespace dmGameObject

namespace dmScript {
dmMessage::URL *CheckURL(lua_State *L, int index);
bool GetURL(lua_State *L, dmMessage::URL &out_url);
bool GetURL(lua_State *L, dmMessage::URL *out_url);
void GetGlobal(lua_State *L, uint32_t name_hash);

} // namespace dmScript

namespace dmGameSystem {
struct PhysicsScriptContext {
    dmMessage::HSocket m_Socket;
    uint32_t m_ComponentIndex;
};
struct CollisionWorld;
struct CollisionComponent;
uint16_t CompCollisionGetGroupBitIndex(CollisionWorld* world, uint64_t group_hash);
void RayCast(CollisionWorld* world, const dmPhysics::RayCastRequest &request, dmArray<dmPhysics::RayCastResponse> &results);
dmhash_t CompCollisionObjectGetIdentifier(CollisionComponent* component);
} // namespace dmGameSystem

namespace d954masPhysicsUtils {


int LuaPhysicsUtilsCountMask(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 1);
    uint32_t mask = 0;
    luaL_checktype(L, 1, LUA_TTABLE);

    dmScript::GetGlobal(L, PHYSICS_CONTEXT_HASH);
    dmGameSystem::PhysicsScriptContext *context = (dmGameSystem::PhysicsScriptContext *)lua_touserdata(L, -1);
    lua_pop(L, 1);

    dmGameObject::HInstance sender_instance = dmScript::CheckGOInstance(L);
    dmGameObject::HCollection collection = dmGameObject::GetCollection(sender_instance);
    dmGameSystem::CollisionWorld* world = (dmGameSystem::CollisionWorld*) dmGameObject::GetWorld(collection, context->m_ComponentIndex);
    if (world == 0x0) {
        return DM_LUA_ERROR("Physics world doesn't exist. Make sure you have at least one physics component in collection.");
    }

    lua_pushnil(L);
    while (lua_next(L, 1) != 0) {
        mask |= dmGameSystem::CompCollisionGetGroupBitIndex(world, dmScript::CheckHash(L, -1));
        lua_pop(L, 1);
    }
    lua_pushnumber(L, mask);
    return 1;
}

int LuaPhysicsUtilsRayCastSingleExist(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 1);

    dmMessage::URL sender;
    if (!dmScript::GetURL(L, &sender)) {
        return luaL_error(L, "could not find a requesting instance for physics.raycast");
    }

    dmScript::GetGlobal(L, PHYSICS_CONTEXT_HASH);
    dmGameSystem::PhysicsScriptContext *context = (dmGameSystem::PhysicsScriptContext *)lua_touserdata(L, -1);
    lua_pop(L, 1);

    dmGameObject::HInstance sender_instance = dmScript::CheckGOInstance(L);
    dmGameObject::HCollection collection = dmGameObject::GetCollection(sender_instance);
    dmGameSystem::CollisionWorld* world = (dmGameSystem::CollisionWorld*) dmGameObject::GetWorld(collection, context->m_ComponentIndex);
    if (world == 0x0) {
        return DM_LUA_ERROR("Physics world doesn't exist. Make sure you have at least one physics component in collection.");
    }

    dmVMath::Point3 from(*dmScript::CheckVector3(L, 1));
    dmVMath::Point3 to(*dmScript::CheckVector3(L, 2));

    uint32_t mask = luaL_checknumber(L, 3);

    dmArray<dmPhysics::RayCastResponse> hits;
    hits.SetCapacity(32);

    dmPhysics::RayCastRequest request;
    request.m_From = from;
    request.m_To = to;
    request.m_Mask = mask;
    request.m_ReturnAllResults = 0;

    dmGameSystem::RayCast(world, request, hits);
    lua_pushboolean(L, !hits.Empty());
    return 1;
}

int LuaPhysicsUtilsRayCastSingle(lua_State *L) {
    //  DM_LUA_STACK_CHECK(L, 4);

    dmMessage::URL sender;
    if (!dmScript::GetURL(L, &sender)) {
        return luaL_error(L, "could not find a requesting instance for physics.raycast");
    }

    dmScript::GetGlobal(L, PHYSICS_CONTEXT_HASH);
    dmGameSystem::PhysicsScriptContext *context = (dmGameSystem::PhysicsScriptContext *)lua_touserdata(L, -1);
    lua_pop(L, 1);

    dmGameObject::HInstance sender_instance = dmScript::CheckGOInstance(L);
    dmGameObject::HCollection collection = dmGameObject::GetCollection(sender_instance);
    dmGameSystem::CollisionWorld* world = (dmGameSystem::CollisionWorld*) dmGameObject::GetWorld(collection, context->m_ComponentIndex);
    if (world == 0x0) {
        dmLogError("dmLogError:Physics world doesn't exist. Make sure you have at least one physics component in collection.");
        lua_pushboolean(L, false);
        return 1;
        //return luaL_error(L, "Physics world doesn't exist. Make sure you have at least one physics component in collection.");
    }

    dmVMath::Point3 from(*dmScript::CheckVector3(L, 1));
    dmVMath::Point3 to(*dmScript::CheckVector3(L, 2));

    uint32_t mask = luaL_checknumber(L, 3);

    dmArray<dmPhysics::RayCastResponse> hits;
    hits.SetCapacity(32);

    dmPhysics::RayCastRequest request;
    request.m_From = from;
    request.m_To = to;
    request.m_Mask = mask;
    request.m_ReturnAllResults = 0;

    dmGameSystem::RayCast(world, request, hits);
    lua_pushboolean(L, !hits.Empty());
    if (hits.Empty()) {
        return 1;
    } else {
        dmPhysics::RayCastResponse &resp1 = hits[0];
        lua_pushnumber(L, resp1.m_Position.getX());
        lua_pushnumber(L, resp1.m_Position.getY());
        lua_pushnumber(L, resp1.m_Position.getZ());

        lua_pushnumber(L, resp1.m_Normal.getX());
        lua_pushnumber(L, resp1.m_Normal.getY());
        lua_pushnumber(L, resp1.m_Normal.getZ());

        dmhash_t id = dmGameSystem::CompCollisionObjectGetIdentifier((dmGameSystem::CollisionComponent*) resp1.m_CollisionObjectUserData);
        dmScript::PushHash(L, id);
        return 8;
    }
}
// endregion

}