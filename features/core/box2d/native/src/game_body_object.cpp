#include "utils.h"
#include "game_body_object.h"

#define META_NAME "Box2d::GameBodyClass"
#define USERDATA_TYPE "game_obj_body"

namespace box2dDefoldNE {

dmArray<GameBodyObject*> objects_list;

GameBodyObject::GameBodyObject(Body* physBody,dmVMath::Vector3* position) :BaseUserData(USERDATA_TYPE){
    this->position = position;
    this->physBody = physBody;
    this->metatable_name = META_NAME;
    this->box2dObj = this;//base userdata should have object
    if(objects_list.Full()){
        objects_list.OffsetCapacity(10);
    }
    objects_list.Push(this);
}

GameBodyObject::~GameBodyObject() {

}

GameBodyObject* GameBodyObject_get_userdata_safe(lua_State *L, int index) {
    GameBodyObject *lua_obj = (GameBodyObject*) BaseUserData_get_userdata(L, index, USERDATA_TYPE);
    return lua_obj;
}

int GameBodyObjectDestroy(lua_State *L) {
    utils::check_arg_count(L, 1);
    GameBodyObject *obj = GameBodyObject_get_userdata_safe(L, 1);
    for(int i = 0; i < objects_list.Size(); i++){
         if(objects_list[i] == obj){
            objects_list.EraseSwap(i);
            break;
         }
    }
    obj->Destroy(L);
    delete obj;
    return 0;
}

int GameBodyObjectCreate(lua_State *L) {
    utils::check_arg_count(L, 2);

    Body *body = Body_get_userdata_safe(L, 1);
    Vectormath::Aos::Vector3 *position = dmScript::CheckVector3(L, 2);

    GameBodyObject* obj = new GameBodyObject(body,position);
    obj->Push(L);
    return 1;
}

int GameBodyObjectsUpdate(lua_State *L) {
    DM_LUA_STACK_CHECK(L, 0);
    utils::check_arg_count(L, 1);

    float physScale = lua_tonumber(L,1);


    for(int i=0;i<objects_list.Size();i++){
        GameBodyObject* obj = objects_list[i];
        const b2Vec2& position = obj->physBody->body->GetPosition();
        obj->position->setX(position.x/physScale);
        obj->position->setY(position.y/physScale);
    }

    return 0;
}

}

