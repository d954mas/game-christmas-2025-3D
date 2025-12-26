#define EXTENSION_NAME mesh_char
#define LIB_NAME "mesh_char"
#define MODULE_NAME "mesh_char"

#define META_NAME_BONES "MeshUtils::BonesClass"


#include <dmsdk/sdk.h>
#include <dmsdk/dlib/transform.h>

static const dmhash_t HASH_BONES = dmHashString64("bones");
static const dmhash_t HASH_RGBA = dmHashString64("rgba");

using namespace Vectormath::Aos;

namespace dmScript {
    dmMessage::URL* CheckURL(lua_State* L, int index);
    bool GetURL(lua_State* L, dmMessage::URL& out_url);
    bool GetURL(lua_State* L, dmMessage::URL* out_url);
    void GetGlobal(lua_State*L, uint32_t name_hash);
}

namespace dmGameObject {
    PropertyResult GetProperty(HInstance instance, dmhash_t component_id, dmhash_t property_id, PropertyOptions options, PropertyDesc& out_value);
    PropertyResult SetProperty(HInstance instance, dmhash_t component_id, dmhash_t property_id, PropertyOptions options, const PropertyVar& value);
}

namespace MeshUtils {

class Bones {
public:
    dmVMath::Matrix4* matrices = NULL;
    int len;
    Bones(){

    }
    ~Bones(){
        delete[] matrices;
        matrices = NULL;
    }
};

}


static uint32_t as_uint(const float x) {
    return *(uint32_t*)&x;
}
static float as_float(const uint32_t x) {
    return *(float*)&x;
}

static float half_to_float(const uint16_t x) { // IEEE-754 16-bit floating-point format (without infinity): 1-5-10, exp-15, +-131008.0, +-6.1035156E-5, +-5.9604645E-8, 3.311 digits
    const uint32_t e = (x&0x7C00)>>10; // exponent
    const uint32_t m = (x&0x03FF)<<13; // mantissa
    const uint32_t v = as_uint((float)m)>>23; // evil log2 bit hack to count leading zeros in denormalized format
    return as_float((x&0x8000)<<16 | (e!=0)*((e+112)<<23|m) | ((e==0)&(m!=0))*((v-37)<<23|((m<<(150-v))&0x007FE000))); // sign : normalized : denormalized
}
static uint16_t float_to_half(const float x) { // IEEE-754 16-bit floating-point format (without infinity): 1-5-10, exp-15, +-131008.0, +-6.1035156E-5, +-5.9604645E-8, 3.311 digits
    const uint32_t b = as_uint(x)+0x00001000; // round-to-nearest-even: add last bit after truncated mantissa
    const uint32_t e = (b&0x7F800000)>>23; // exponent
    const uint32_t m = b&0x007FFFFF; // mantissa; in line below: 0x007FF000 = 0x00800000-0x00001000 = decimal indicator flag - initial rounding
    return (b&0x80000000)>>16 | (e>112)*((((e-112)<<10)&0x7C00)|m>>13) | ((e<113)&(e>101))*((((0x007FF000+m)>>(125-e))+1)>>1) | (e>143)*0x7FFF; // sign : normalized : denormalized : saturate
}

using namespace MeshUtils;


static Bones* Bones_get_userdata(lua_State* L, int index){
    if(luaL_checkudata(L, index, META_NAME_BONES) == NULL){
        luaL_error(L,"not bones userdata");
    }
    Bones *bones =  *static_cast<Bones**>(luaL_checkudata(L, index, META_NAME_BONES));
    return bones;
}

static int Bones_destroy(lua_State* L){
    delete *static_cast<Bones**>(luaL_checkudata(L, 1, META_NAME_BONES));
    return 0;
}
static int Bones_get_len(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    Bones* bones = Bones_get_userdata(L,1);
    lua_pushnumber(L, bones->len);

    return 1;
}
static int Bones_count_bone(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    Bones* bones = Bones_get_userdata(L,1);
    Bones* invLocalBones = Bones_get_userdata(L,2);
    dmVMath::Matrix4 local = *dmScript::CheckMatrix4(L, 3);
    dmVMath::Matrix4 inv_local_matrix = *dmScript::CheckMatrix4(L, 4);

    dmVMath::Matrix4* out = dmScript::CheckMatrix4(L, 5);
    int boneIdx = lua_tonumber(L,6);


    if (boneIdx<0) {
        return DM_LUA_ERROR("bone idx should be >=0");
    }
    if (boneIdx>bones->len) {
        return DM_LUA_ERROR("bone idx bigger that bones len");
    }

    *out = (local * invLocalBones->matrices[boneIdx] * bones->matrices[boneIdx] * inv_local_matrix);


    return 0;
}
static int Bones_get_bone_matrix(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    Bones* bones = Bones_get_userdata(L,1);
    int boneIdx = lua_tonumber(L,2);
    dmVMath::Matrix4 *result = dmScript::CheckMatrix4(L, 3);

    if (boneIdx<0) {
        return DM_LUA_ERROR("bone idx should be >=0");
    }
    if (boneIdx>bones->len) {
        return DM_LUA_ERROR("bone idx bigger that bones len");
    }

    *result = bones->matrices[boneIdx];
    return 0;
}

static int Bones_get_bone_transform(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    Bones* bones = Bones_get_userdata(L,1);
    int boneIdx = lua_tonumber(L,2);
    dmVMath::Vector3 *transform = dmScript::CheckVector3(L, 3);
    dmVMath::Vector3 *scale = dmScript::CheckVector3(L, 4);
    dmVMath::Quat *rotation = dmScript::CheckQuat(L, 5);

    if (boneIdx<0) {
        return DM_LUA_ERROR("bone idx should be >=0");
    }
    if (boneIdx>bones->len) {
        return DM_LUA_ERROR("bone idx bigger that bones len");
    }

    dmVMath::Matrix4 boneMtx = transpose(bones->matrices[boneIdx]);
    dmTransform::Transform t1 =  dmTransform::ToTransform(boneMtx);

    *transform = t1.GetTranslation();
    *scale = t1.GetScale();
    *rotation = t1.GetRotation();

    return 0;
}


static void Bones_push(lua_State *L, Bones* bones){
    *static_cast<Bones**>(lua_newuserdata(L, sizeof(Bones*))) = bones;
    if(luaL_newmetatable(L, META_NAME_BONES)){
        static const luaL_Reg functions[] =
        {
            {"__gc", Bones_destroy},
            {"get_len", Bones_get_len},
            {"count_bone", Bones_count_bone},
            {"get_bone_matrix", Bones_get_bone_matrix},
            {"get_bone_transform", Bones_get_bone_transform},
            {0, 0}
        };
        luaL_register(L, NULL,functions);
        lua_pushvalue(L, -1);
        lua_setfield(L, -1, "__index");
    }
    lua_setmetatable(L, -2);
}

static float Fract(float f){
    return f - floor(f);
}
//static float MIN_BORDER = 1000;
//static float MAX_BORDER = -1000;
#define ENCODE_MIN -128.0
#define ENCODE_MAX 128.0
static dmVMath::Vector4 EncodeFloatRGBA(float v){
    //if (v<MIN_BORDER){MIN_BORDER = v;}
    //if (v>MAX_BORDER){MAX_BORDER = v;}
    assert(v>=ENCODE_MIN);
    assert(v<ENCODE_MAX);
    v = (v- ENCODE_MIN)/(ENCODE_MAX-ENCODE_MIN);
    assert(v>=0.0);
    assert(v<1.0);
    dmVMath::Vector4 enc = dmVMath::Vector4(1.0, 255.0, 65025.0, 16581375.0) * v;
    double full;
    enc.setX(Fract(enc.getX()));
    enc.setY(Fract(enc.getY()));
    enc.setZ(Fract(enc.getZ()));
    enc.setW(Fract(enc.getW()));
    //enc = enc - dmVMath::Vector4(enc.getY()*1.0/255.0,enc.getZ()*1.0/255.0,enc.getW()*1.0/255.0,0.0);
    return enc;
}

static int GoSetBones(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);

    dmMessage::URL* rootUrl = dmScript::CheckURL(L, 1);
    if (!lua_istable(L, 2)) {
         return DM_LUA_ERROR("need bones table as 2 argument");
    }


    dmGameObject::HInstance rootInstance = dmScript::CheckGOInstance(L,1);
    if (rootInstance == 0){
        return DM_LUA_ERROR("Could not find any instance with id:%s", dmHashReverseSafe64(rootUrl->m_Path));
    }

    dmMessage::URL sender;
    dmScript::GetURL(L, &sender);


    if (sender.m_Socket != rootUrl->m_Socket){
        return DM_LUA_ERROR("go.set can only access instances within the same collection.");
    }
   int bones = luaL_getn(L, 2);

    for (int i = 1; i<=bones; ++i) {
        lua_rawgeti(L, 2, i);
        dmVMath::Vector4* boneV4 = dmScript::CheckVector4(L, 3);
        lua_pop(L,1);

        dmGameObject::PropertyOptions property_options;
        property_options.m_Index  = i-1;
        //property_options.m_HasKey = 0;

        dmGameObject::PropertyVar property_var;
        property_var.m_Type =  dmGameObject::PROPERTY_TYPE_VECTOR4;
        property_var.m_V4[0] = boneV4->getX();
        property_var.m_V4[1] = boneV4->getY();
        property_var.m_V4[2] = boneV4->getZ();
        property_var.m_V4[3] = boneV4->getW();


        dmGameObject::PropertyResult result = dmGameObject::SetProperty(rootInstance, rootUrl->m_Fragment, HASH_BONES, property_options, property_var);
        switch (result){
            case dmGameObject::PROPERTY_RESULT_OK:
                break;
           default:
                // Should never happen, programmer error
                return DM_LUA_ERROR("go.set failed with error code %d", result);
        }
    }

    return 0;
}


static int FillStreamV4(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    dmBuffer::HBuffer buffer = dmScript::CheckBufferUnpack(L, 1);
    dmhash_t streamName = dmScript::CheckHashOrString(L,2);
    if (!lua_istable(L, 3)) {
         return DM_LUA_ERROR("data not table");
    }

    float* values = 0x0;
    uint32_t sizeBuffer = 0;
    uint32_t components = 0;
    uint32_t stride = 0;
    dmBuffer::Result dataResult = dmBuffer::GetStream(buffer, streamName, (void**)&values, &sizeBuffer, &components, &stride);
    if (dataResult != dmBuffer::RESULT_OK) {
       return DM_LUA_ERROR("can't get stream");
    }

    if (components!=4){
         return DM_LUA_ERROR("stream have: %d components. Need 4", components);
    }

    int size = luaL_getn(L, 3);
    if (size>=sizeBuffer){
        return DM_LUA_ERROR("buffer not enough size");
    }
    
    for (int i=1; i<=size; ++i) {
        lua_rawgeti(L, 3, i);
        dmVMath::Vector4* v4 = dmScript::CheckVector4(L, -1);
        lua_pop(L,1);
        values[0] = v4->getX();
        values[1] = v4->getY();
        values[2] = v4->getZ();
        values[3] = v4->getW();
        values += stride;
    }
    dmBuffer::UpdateContentVersion(buffer);
    return 0;
}

static int FillStreamV3(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    dmBuffer::HBuffer buffer = dmScript::CheckBufferUnpack(L, 1);
    dmhash_t streamName = dmScript::CheckHashOrString(L,2);
    if (!lua_istable(L, 3)) {
         return DM_LUA_ERROR("data not table");
    }

    float* values = 0x0;
    uint32_t sizeBuffer = 0;
    uint32_t components = 0;
    uint32_t stride = 0;
    dmBuffer::Result dataResult = dmBuffer::GetStream(buffer, streamName, (void**)&values, &sizeBuffer, &components, &stride);
    if (dataResult != dmBuffer::RESULT_OK) {
       return DM_LUA_ERROR("can't get stream");
    }

    if (components!=3){
         return DM_LUA_ERROR("stream have: %d components. Need 3", components);
    }

    int size = luaL_getn(L, 3);
    if (size>=sizeBuffer){
        return DM_LUA_ERROR("buffer not enough size");
    }

    for (int i=1; i<=size; ++i) {
        lua_rawgeti(L, 3, i);
        dmVMath::Vector3* v4 = dmScript::CheckVector3(L, -1);
        lua_pop(L,1);
        values[0] = v4->getX();
        values[1] = v4->getY();
        values[2] = v4->getZ();
        values += stride;
    }
    dmBuffer::UpdateContentVersion(buffer);
    return 0;
}

static int FillStreamFloats(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    dmBuffer::HBuffer buffer = dmScript::CheckBufferUnpack(L, 1);
    dmhash_t streamName = dmScript::CheckHashOrString(L,2);
    int componentsSize = lua_tonumber(L,3);
    if (!lua_istable(L, 4)) {
         return DM_LUA_ERROR("data not table");
    }

    float* values = 0x0;
    uint32_t sizeBuffer = 0;
    uint32_t components = 0;
    uint32_t stride = 0;
    dmBuffer::Result dataResult = dmBuffer::GetStream(buffer, streamName, (void**)&values, &sizeBuffer, &components, &stride);
    if (dataResult != dmBuffer::RESULT_OK) {
       return DM_LUA_ERROR("can't get stream");
    }

    if (components!=componentsSize){
         return DM_LUA_ERROR("stream have: %d components. Need %d", components, componentsSize);
    }

    int size = luaL_getn(L, 3);
    if (size/components>=sizeBuffer){
        return DM_LUA_ERROR("buffer not enough size");
    }

    for (int i=0; i<sizeBuffer; ++i) {
        for (int j=0;j<components;++j){
            lua_rawgeti(L, 4, i*components+j+1);
            values[j] = lua_tonumber(L,-1);
            lua_pop(L,1);
        }
        values += stride;
    }
    dmBuffer::UpdateContentVersion(buffer);
    return 0;
}

static int FillStreamUInt8(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    dmBuffer::HBuffer buffer = dmScript::CheckBufferUnpack(L, 1);
    dmhash_t streamName = dmScript::CheckHashOrString(L,2);
    int componentsSize = lua_tonumber(L,3);
    if (!lua_istable(L, 4)) {
         return DM_LUA_ERROR("data not table");
    }

    uint8_t* values = 0x0;
    uint32_t sizeBuffer = 0;
    uint32_t components = 0;
    uint32_t stride = 0;
    dmBuffer::Result dataResult = dmBuffer::GetStream(buffer, streamName, (void**)&values, &sizeBuffer, &components, &stride);
    if (dataResult != dmBuffer::RESULT_OK) {
       return DM_LUA_ERROR("can't get stream");
    }

    if (components!=componentsSize){
         return DM_LUA_ERROR("stream have: %d components. Need %d", components, componentsSize);
    }

    int size = luaL_getn(L, 3);
    if (size/components>=sizeBuffer){
        return DM_LUA_ERROR("buffer not enough size");
    }

    for (int i=0; i<sizeBuffer; ++i) {
        for (int j=0;j<components;++j){
            lua_rawgeti(L, 4, i*components+j+1);
            values[j] = lua_tonumber(L,-1);
            lua_pop(L,1);
        }
        values += stride;
    }
    dmBuffer::UpdateContentVersion(buffer);
    return 0;
}


static int ReadFloat(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    const char* content =  luaL_checkstring(L, 1);
    int index = lua_tonumber(L,2)-1;

    const unsigned char *b = (const unsigned char *)(content+index);
    uint32_t temp = 0;
    temp = ((b[3] << 24) |
            (b[2] << 16) |
            (b[1] <<  8) |
             b[0]);
    lua_pushnumber(L, *((float *) &temp));
    return 1;
}

static int ReadInt(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    const char* content =  luaL_checkstring(L, 1);
    int index = lua_tonumber(L,2)-1;

    const unsigned char *b = (const unsigned char *)(content+index);
    int temp = ((b[3] << 24) |
            (b[2] << 16) |
            (b[1] <<  8) |
             b[0]);
    lua_pushnumber(L, temp);
    return 1;
}

static int ReadHalfFloat(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    const char* content =  luaL_checkstring(L, 1);
    int index = lua_tonumber(L,2)-1;

    const unsigned char *b = (const unsigned char *)(content+index);
    uint16_t temp = ((b[1] <<  8) |
             b[0]);
    lua_pushnumber(L, half_to_float(temp));
    return 1;
}

inline int ReadIntInline(const char* content, int index){
    const unsigned char *b = (const unsigned char *)(content+index);
    int temp = ((b[3] << 24) |
            (b[2] << 16) |
            (b[1] <<  8) |
             b[0]);
    return temp;
}

inline float ReadHalfFloatInline(const char* content, int index){
    const unsigned char *b = (const unsigned char *)(content+index);
    uint16_t temp = ((b[1] <<  8) | b[0]);
    return half_to_float(temp);
}

static int ReadVertices(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    const char* content =  luaL_checkstring(L, 1);
    int index = lua_tonumber(L,2)-1;
    int vertices = lua_tonumber(L,3);

    lua_newtable(L);
    for(int i=0;i<vertices;i++){
        lua_newtable(L);

        dmVMath::Vector3 p(ReadHalfFloatInline(content,index),ReadHalfFloatInline(content,index+2),ReadHalfFloatInline(content,index+4));
        index +=6;
        dmScript::PushVector3(L,p);
        lua_setfield(L,-2,"p");

        dmVMath::Vector3 n(ReadHalfFloatInline(content,index),ReadHalfFloatInline(content,index+2),ReadHalfFloatInline(content,index+4));
        index +=6;
        dmScript::PushVector3(L,n);
        lua_setfield(L,-2,"n");

        lua_rawseti(L,-2,i+1);
    }
    return 1;
}

static int ReadTexCoords(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    const char* content =  luaL_checkstring(L, 1);
    int index = lua_tonumber(L,2)-1;
    int faces = lua_tonumber(L,3);

    lua_newtable(L);
    for(int i=0;i<faces*6;i++){
        lua_pushnumber(L,ReadHalfFloatInline(content,index));
        index +=2;
        lua_rawseti(L,-2,i+1);
    }
    return 1;
}

static int ReadFaces(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    const char* content =  luaL_checkstring(L, 1);
    int index = lua_tonumber(L,2)-1;
    int faces = lua_tonumber(L,3);
    lua_newtable(L);

    for(int i=0;i<faces;++i){
        lua_newtable(L);
            lua_newtable(L);
                lua_pushnumber(L,ReadIntInline(content,index)+1);
                lua_rawseti(L,-2,1);
                lua_pushnumber(L,ReadIntInline(content,index+4)+1);
                lua_rawseti(L,-2,2);
                lua_pushnumber(L,ReadIntInline(content,index+8)+1);
                lua_rawseti(L,-2,3);
        lua_setfield(L,-2,"v");

        lua_rawseti(L,-2,i+1);

        index+=12;
    }


    return 1;
}

static int NewBonesObject(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);

    if (!lua_istable(L, 1)) {
        return DM_LUA_ERROR("need bones table as 1 argument");
    }

    int size = luaL_getn(L, 1);
    if (size%3!=0){
        return DM_LUA_ERROR("table size is bad");
    }


    Bones* bones = new Bones();
    bones->len = size/3;
    bones->matrices = new dmVMath::Matrix4[bones->len];

    for (int i=0; i<bones->len; ++i) {
        lua_rawgeti(L, 1, i*3+1);
        lua_rawgeti(L, 1, i*3 + 2);
        lua_rawgeti(L, 1, i*3 + 3);
        dmVMath::Matrix4* m = &bones->matrices[i];
        m->setCol0(*dmScript::CheckVector4(L, -3));
        m->setCol1(*dmScript::CheckVector4(L, -2));
        m->setCol2(*dmScript::CheckVector4(L, -1));
        //fixed matrix inited with 0. need identity
        m->setCol3(dmVMath::Vector4(0,0,0,1));
        lua_pop(L,3);
    }

    Bones_push(L,bones);
    return 1;
}

static int NewBonesObjectEmpty(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    int size = lua_tonumber(L, 1);
    if (size<=0){
        return DM_LUA_ERROR("should be bigger that 0");
    }

    Bones* bones = new Bones();
    bones->len = size;
    bones->matrices = new dmVMath::Matrix4[bones->len];

    for (int i=0; i<bones->len; ++i) {
        dmVMath::Matrix4* m = &bones->matrices[i];
        m->setCol1(dmVMath::Vector4(1,0,0,0));
        m->setCol1(dmVMath::Vector4(0,1,0,0));
        m->setCol2(dmVMath::Vector4(0,0,1,0));
        m->setCol3(dmVMath::Vector4(0,0,0,1));
    }

    Bones_push(L,bones);
    return 1;
}

static int BonesObjectCopy(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    Bones* out = Bones_get_userdata(L,1);
    Bones* bones = Bones_get_userdata(L,2);

    if (out->len != bones->len){return DM_LUA_ERROR("bad len"); }

    for(int i=0;i<out->len;i++){
        out->matrices[i] = bones->matrices[i];
    }

    return 0;
}

static int ReadBonesObject(lua_State* L){
    DM_LUA_STACK_CHECK(L, 1);
    const char* content =  luaL_checkstring(L, 1);
    int index = lua_tonumber(L,2)-1;
    int size = lua_tonumber(L,3);

    Bones* bones = new Bones();
    bones->len = size;
    bones->matrices = new dmVMath::Matrix4[bones->len];

    for (int i=0; i<size; ++i) {
        dmVMath::Matrix4* m = &bones->matrices[i];

        m->setCol0(dmVMath::Vector4(ReadHalfFloatInline(content,index),ReadHalfFloatInline(content,index+2),ReadHalfFloatInline(content,index+4),ReadHalfFloatInline(content,index+6)));
        index +=8;
        m->setCol1(dmVMath::Vector4(ReadHalfFloatInline(content,index),ReadHalfFloatInline(content,index+2),ReadHalfFloatInline(content,index+4),ReadHalfFloatInline(content,index+6)));
        index +=8;
        m->setCol2(dmVMath::Vector4(ReadHalfFloatInline(content,index),ReadHalfFloatInline(content,index+2),ReadHalfFloatInline(content,index+4),ReadHalfFloatInline(content,index+6)));
        index +=8;

        m->setCol3(dmVMath::Vector4(0,0,0,1));
    }

    Bones_push(L,bones);
    return 1;
}

static int CalculateBones(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    Bones* out = Bones_get_userdata(L,1);
    Bones* bones = Bones_get_userdata(L,2);
    Bones* invLocalBones = Bones_get_userdata(L,3);
    dmVMath::Matrix4 local = *dmScript::CheckMatrix4(L, 4);
    dmVMath::Matrix4 inv_local_matrix = *dmScript::CheckMatrix4(L, 5);

    if (out->len != bones->len){return DM_LUA_ERROR("bad len"); }
    if (out->len != invLocalBones->len){return DM_LUA_ERROR("bad len");}

    for(int i=0;i<out->len;i++){
        out->matrices[i] = local * invLocalBones->matrices[i] * bones->matrices[i] * inv_local_matrix;
    }
    return 0;
}

static int BonesMulByMatrix4(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    Bones* out = Bones_get_userdata(L,1);
    Bones* bones = Bones_get_userdata(L,2);
    dmVMath::Matrix4 mat4 = *dmScript::CheckMatrix4(L, 3);


    if (out->len != bones->len){return DM_LUA_ERROR("bad len"); }

    for(int i=0;i<out->len;i++){
        out->matrices[i] = bones->matrices[i] * mat4;
    }
    return 0;
}



static void EncodeVector(uint8_t *values,uint32_t stride,dmVMath::Vector4 vector){
        dmVMath::Vector4 encoded = EncodeFloatRGBA(vector.getX());
        values[0] = encoded.getX()*255;
        values[1] = encoded.getY()*255;
        values[2] = encoded.getZ()*255;
        values[3] = encoded.getW()*255;
        values += stride;

        encoded = EncodeFloatRGBA(vector.getY());
        values[0] = encoded.getX()*255;
        values[1] = encoded.getY()*255;
        values[2] = encoded.getZ()*255;
        values[3] = encoded.getW()*255;
        values += stride;

        encoded = EncodeFloatRGBA(vector.getZ());
        values[0] = encoded.getX()*255;
        values[1] = encoded.getY()*255;
        values[2] = encoded.getZ()*255;
        values[3] = encoded.getW()*255;
        values += stride;

        encoded = EncodeFloatRGBA(vector.getW());
        values[0] = encoded.getX()*255;
        values[1] = encoded.getY()*255;
        values[2] = encoded.getZ()*255;
        values[3] = encoded.getW()*255;
        values += stride;
}


static int FillTextureBones(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    dmBuffer::HBuffer buffer = dmScript::CheckBufferUnpack(L, 1);
    Bones *bones = Bones_get_userdata(L,2);
    int index = lua_tonumber(L,3)-1;

    uint8_t* values = 0x0;
    uint32_t sizeBuffer = 0;
    uint32_t components = 0;
    uint32_t stride = 0;
    dmBuffer::Result dataResult = dmBuffer::GetStream(buffer, HASH_RGBA, (void**)&values, &sizeBuffer, &components, &stride);
    if (dataResult != dmBuffer::RESULT_OK) {
       return DM_LUA_ERROR("can't get stream");
    }

    if (components!=4){
         return DM_LUA_ERROR("stream have: %d components. Need 4", components);
    }

    if (bones->len*3*4>sizeBuffer){
        return DM_LUA_ERROR("buffer not enough size");
    }

   values+=stride * index;

    for (int i=0; i<bones->len; ++i) {
        dmVMath::Matrix4 m = bones->matrices[i];

        EncodeVector(values,stride, m.getCol0());
        values += stride*4;

        EncodeVector(values,stride, m.getCol1());
        values += stride*4;

        EncodeVector(values,stride, m.getCol2());
        values += stride*4;
    }
    dmBuffer::UpdateContentVersion(buffer);

  //  dmLogInfo("Min:%f Max:%f", MIN_BORDER, MAX_BORDER);
    return 0;
}

static dmVMath::Quat MatToQuat(dmVMath::Matrix4 m){
    float t = 0;
    dmVMath::Quat q;
    if (m[2][2] < 0){
        if (m[0][0] > m[1][1]){
            t = 1 + m[0][0] - m[1][1] - m[2][2];
            q = dmVMath::Quat(t, m[1][0] + m[0][1], m[0][2] + m[2][0], m[1][2] - m[2][1]);
        }else{
            t = 1 - m[0][0] + m[1][1] - m[2][2];
            q = dmVMath::Quat(m[1][0] + m[0][1], t, m[2][1] + m[1][2], m[2][0] - m[0][2]);
        }
    }else{
        if (m[0][0] < -m[1][1]){
            t = 1 - m[0][0] - m[1][1] + m[2][2];
            q = dmVMath::Quat(m[0][2] + m[2][0], m[2][1] + m[1][2], t, m[0][1] - m[1][0]);
        }else{
            t = 1 + m[0][0] + m[1][1] + m[2][2];
            q = dmVMath::Quat(m[1][2] - m[2][1], m[2][0] - m[0][2], m[0][1] - m[1][0], t);
        }
    }
    float st = sqrt(t);
    q.setX(q.getX() * 0.5 / st);
    q.setY(q.getY() * 0.5 / st);
    q.setZ(q.getZ() * 0.5 / st);
    q.setW(q.getW() * 0.5 / st);

    return q;
}

static int MatrixGetRotation(lua_State* L){
    dmVMath::Matrix4 m1 = *dmScript::CheckMatrix4(L, 1);
    Vectormath::Aos::Quat *out = dmScript::CheckQuat(L, 2);
    dmTransform::Transform t1 =  dmTransform::ToTransform(m1);
    *out = t1.GetRotation();
    return 0;
}

static int InterpolateMatrix(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);

    dmVMath::Matrix4* out = dmScript::CheckMatrix4(L, 1);

    dmVMath::Matrix4 m1 = *dmScript::CheckMatrix4(L, 2);
    dmVMath::Matrix4 m2 = *dmScript::CheckMatrix4(L, 3);

    dmTransform::Transform t1 =  dmTransform::ToTransform(m1);
    dmTransform::Transform t2 =  dmTransform::ToTransform(m2);
    float factor = lua_tonumber(L,4);

    Vector3 m1col1(m1[0][0], m1[1][0], m1[2][0]);
    Vector3 m1col2(m1[0][1], m1[1][1], m1[2][1]);
    Vector3 m1col3(m1[0][2], m1[1][2], m1[2][2]);

    float m1scaleX = dmVMath::Length(m1col1);
    float m1scaleY = dmVMath::Length(m1col2);
    float m1scaleZ = dmVMath::Length(m1col3);
    //dmLogInfo("M1. Scale(%f %f %f)",m1scaleX,m1scaleY,m1scaleZ);


    Vector3 m2col1(m2[0][0], m2[1][0], m2[2][0]);
    Vector3 m2col2(m2[0][1], m2[1][1], m2[2][1]);
    Vector3 m2col3(m2[0][2], m2[1][2], m2[2][2]);

    float m2scaleX = dmVMath::Length(m2col1);
    float m2scaleY = dmVMath::Length(m2col2);
    float m2scaleZ = dmVMath::Length(m2col3);
    //dmLogInfo("M2. scale(%f %f %f)",m2scaleX,m2scaleY,m2scaleZ);

    float outScaleX = m1scaleX + factor * (m2scaleX - m1scaleX);
    float outScaleY = m1scaleY + factor * (m2scaleY - m1scaleY);
    float outScaleZ = m1scaleZ + factor * (m2scaleZ - m1scaleZ);

    dmVMath::Vector3 s(outScaleX,outScaleY,outScaleZ);


    dmVMath::Vector3 tr1 = dmVMath::Vector3(m1[0][3], m1[1][3], m1[2][3]);
    dmVMath::Vector3 tr2 = dmVMath::Vector3(m2[0][3], m2[1][3], m2[2][3]);
    dmVMath::Vector3 t = dmVMath::Lerp(factor, tr1, tr2);

    dmVMath::Quat q = dmVMath::Slerp(factor, t1.GetRotation(), t2.GetRotation());


    Matrix4 m = dmTransform::ToMatrix4(dmTransform::Transform(dmVMath::Vector3(0,0,0),q,s));
    m[0][3] = t.getX();
    m[1][3] = t.getY();
    m[2][3] = t.getZ();
    m[3][3] = 1.;

    *out = m;
    return 0;
}

static int Interpolate(lua_State* L){
    DM_LUA_STACK_CHECK(L, 0);
    Bones* out = Bones_get_userdata(L,1);
    Bones* bones1 = Bones_get_userdata(L,2);
    Bones* bones2 = Bones_get_userdata(L,3);

    if (out->len != bones1->len){return DM_LUA_ERROR("bad len"); }
    if (out->len != bones2->len){return DM_LUA_ERROR("bad len");}

    if (lua_istable(L, 4)) {

        for(int i=0;i<out->len;i++){
            lua_rawgeti(L, 4, i);
            if(lua_isnil(L,-1)){DM_LUA_ERROR("no bone weight:%d",i);}
            float factor = lua_tonumber(L,-1);
            lua_pop(L,1);

            dmVMath::Matrix4 m1 = bones1->matrices[i];
            dmVMath::Matrix4 m2 = bones2->matrices[i];

            dmVMath::Vector3 t1 = dmVMath::Vector3(m1[0][3], m1[1][3], m1[2][3]);
            dmVMath::Vector3 t2 = dmVMath::Vector3(m2[0][3], m2[1][3], m2[2][3]);
            dmVMath::Vector3 t = dmVMath::Lerp(factor, t1, t2);

            dmVMath::Quat q1 = MatToQuat(m1);
            dmVMath::Quat q2 = MatToQuat(m2);
            dmVMath::Quat q = dmVMath::Slerp(factor, q1, q2);
            dmVMath::Matrix4 m = Matrix4::rotation(q);

            m[0][3] = t.getX();
            m[1][3] = t.getY();
            m[2][3] = t.getZ();
            m[3][3] = 1.;

            out->matrices[i] = m;
        }
    }else{
        float factor = lua_tonumber(L,4);
        for(int i=0;i<out->len;i++){
            dmVMath::Matrix4 m1 = bones1->matrices[i];
            dmVMath::Matrix4 m2 = bones2->matrices[i];

            dmVMath::Vector3 t1 = dmVMath::Vector3(m1[0][3], m1[1][3], m1[2][3]);
            dmVMath::Vector3 t2 = dmVMath::Vector3(m2[0][3], m2[1][3], m2[2][3]);
            dmVMath::Vector3 t = dmVMath::Lerp(factor, t1, t2);

            dmVMath::Quat q1 = MatToQuat(m1);
            dmVMath::Quat q2 = MatToQuat(m2);
            dmVMath::Quat q = dmVMath::Slerp(factor, q1, q2);
            dmVMath::Matrix4 m = Matrix4::rotation(q);

            m[0][3] = t.getX();
            m[1][3] = t.getY();
            m[2][3] = t.getZ();
            m[3][3] = 1.;

            out->matrices[i] = m;
        }
    }



    return 0;
}




// Functions exposed to Lua
static const luaL_reg Module_methods[] =
{
    {"go_set_bones",GoSetBones},
    {"fill_stream_v4",FillStreamV4},
    {"fill_stream_v3",FillStreamV3},
    {"fill_stream_floats",FillStreamFloats},
    {"fill_stream_uint8",FillStreamUInt8},
    {"read_float",ReadFloat},
    {"read_half_float",ReadHalfFloat},
    {"read_vertices",ReadVertices},
    {"read_texcoords",ReadTexCoords},
    {"read_faces",ReadFaces},
    {"read_int",ReadInt},
    {"new_bones_object", NewBonesObject},
    {"read_bones_object", ReadBonesObject},
    {"new_bones_object_empty", NewBonesObjectEmpty},
    {"bones_object_copy", BonesObjectCopy},
    {"calculate_bones", CalculateBones},
    {"mul_bones_by_matrix", BonesMulByMatrix4},
    {"fill_texture_bones", FillTextureBones},
    {"interpolate", Interpolate},
    {"interpolate_matrix", InterpolateMatrix},
    {"matrix_get_rotation", MatrixGetRotation},
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

dmExtension::Result InitializeUtils(dmExtension::Params* params)
{
    // Init Lua
    LuaInit(params->m_L);
    printf("Registered %s Extension\n", MODULE_NAME);
    return dmExtension::RESULT_OK;
}

dmExtension::Result FinalizeUtils(dmExtension::Params* params)
{
    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, 0, 0, InitializeUtils, 0, 0, FinalizeUtils)
