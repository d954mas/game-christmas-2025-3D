#ifndef game_body_obj_h
#define game_body_obj_h

#include <dmsdk/sdk.h>
#include <box2d/box2d.h>
#include <body.h>

#include "base_userdata.h"


namespace box2dDefoldNE {

    class GameBodyObject  : public BaseUserData{
    public:
    dmVMath::Vector3* position;
    Body* physBody;

    GameBodyObject( Body* physBody, dmVMath::Vector3* position);
    virtual ~GameBodyObject();
};

int GameBodyObjectDestroy(lua_State *L);
int GameBodyObjectCreate(lua_State *L);
int GameBodyObjectsUpdate(lua_State *L);


}
#endif