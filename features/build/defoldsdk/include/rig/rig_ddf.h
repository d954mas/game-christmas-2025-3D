
// Copyright 2020-2024 The Defold Foundation
// Copyright 2014-2020 King
// Copyright 2009-2014 Ragnar Svensson, Christian Murray
// Licensed under the Defold License version 1.0 (the "License"); you may not use
// this file except in compliance with the License.
//
// You may obtain a copy of the License, together with FAQs at
// https://www.defold.com/license
//
// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


// GENERATED FILE! DO NOT EDIT!

#ifndef RIG_DDF_H
#define RIG_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmRigDDF
{
    enum AlphaMode
    {
        ALPHA_MODE_OPAQUE   = 0,
        ALPHA_MODE_MASK     = 1,
        ALPHA_MODE_BLEND    = 2,
        ALPHA_MODE_MAX_ENUM = 3,
    };

    enum IndexBufferFormat
    {
        INDEXBUFFER_FORMAT_16 = 0,
        INDEXBUFFER_FORMAT_32 = 1,
    };

    struct Sampler
    {
        const char* m_Name;
        uint32_t    m_Index;
        uint32_t    m_Magfilter;
        uint32_t    m_Minfilter;
        uint32_t    m_Wraps;
        uint32_t    m_Wrapt;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Texture
    {
        const char*       m_Name;
        int32_t           m_Index;
        const char*       m_Path;
        dmRigDDF::Sampler m_Sampler;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TextureTransform
    {
        float   m_OffsetX;
        float   m_OffsetY;
        float   m_ScaleX;
        float   m_ScaleY;
        float   m_Rotation;
        int32_t m_Texcoord;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TextureView
    {
        dmRigDDF::Texture          m_Texture;
        int32_t                    m_Texcoord;
        float                      m_Scale;
        dmRigDDF::TextureTransform m_Transform;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PbrMetallicRoughness
    {
        dmRigDDF::TextureView m_Basecolortexture;
        dmRigDDF::TextureView m_Metallicroughnesstexture;
        dmVMath::Vector4      m_Basecolorfactor;
        float                 m_Metallicfactor;
        float                 m_Roughnessfactor;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PbrSpecularGlossiness
    {
        dmRigDDF::TextureView m_Diffusetexture;
        dmRigDDF::TextureView m_Specularglossinesstexture;
        dmVMath::Vector4      m_Diffusefactor;
        dmVMath::Vector3      m_Specularfactor;
        float                 m_Glossinessfactor;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Clearcoat
    {
        dmRigDDF::TextureView m_Clearcoattexture;
        dmRigDDF::TextureView m_Clearcoatroughnesstexture;
        dmRigDDF::TextureView m_Clearcoatnormaltexture;
        float                 m_Clearcoatfactor;
        float                 m_Clearcoatroughnessfactor;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Transmission
    {
        dmRigDDF::TextureView m_Transmissiontexture;
        float                 m_Transmissionfactor;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Ior
    {
        float m_Ior;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Specular
    {
        dmRigDDF::TextureView m_Speculartexture;
        dmRigDDF::TextureView m_Specularcolortexture;
        dmVMath::Vector3      m_Specularcolorfactor;
        float                 m_Specularfactor;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Volume
    {
        dmRigDDF::TextureView m_Thicknesstexture;
        float                 m_Thicknessfactor;
        dmVMath::Vector3      m_Attenuationcolor;
        float                 m_Attenuationdistance;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Sheen
    {
        dmRigDDF::TextureView m_Sheencolortexture;
        dmRigDDF::TextureView m_Sheenroughnesstexture;
        dmVMath::Vector3      m_Sheencolorfactor;
        float                 m_Sheenroughnessfactor;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct EmissiveStrength
    {
        float m_Emissivestrength;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Iridescence
    {
        float                 m_Iridescencefactor;
        dmRigDDF::TextureView m_Iridescencetexture;
        float                 m_Iridescenceior;
        float                 m_Iridescencethicknessmin;
        float                 m_Iridescencethicknessmax;
        dmRigDDF::TextureView m_Iridescencethicknesstexture;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Material
    {
        const char*                     m_Name;
        uint32_t                        m_Index;
        bool                            m_Isskinned;
        dmRigDDF::PbrMetallicRoughness  m_Pbrmetallicroughness;
        dmRigDDF::PbrSpecularGlossiness m_Pbrspecularglossiness;
        dmRigDDF::Clearcoat             m_Clearcoat;
        dmRigDDF::Ior                   m_Ior;
        dmRigDDF::Specular              m_Specular;
        dmRigDDF::Sheen                 m_Sheen;
        dmRigDDF::Transmission          m_Transmission;
        dmRigDDF::Volume                m_Volume;
        dmRigDDF::EmissiveStrength      m_Emissivestrength;
        dmRigDDF::Iridescence           m_Iridescence;
        dmRigDDF::TextureView           m_Normaltexture;
        dmRigDDF::TextureView           m_Occlusiontexture;
        dmRigDDF::TextureView           m_Emissivetexture;
        dmVMath::Vector3                m_Emissivefactor;
        float                           m_Alphacutoff;
        dmRigDDF::AlphaMode             m_Alphamode;
        bool                            m_Doublesided;
        bool                            m_Unlit;
        uint64_t                        m_Materialhash;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DM_ALIGNED(16) Bone
    {
        uint32_t                              m_Parent;
        uint64_t                              m_Id;
        const char*                           m_Name;
        DM_ALIGNED(16) dmTransform::Transform m_Local;
        DM_ALIGNED(16) dmTransform::Transform m_World;
        DM_ALIGNED(16) dmTransform::Transform m_InverseBindPose;
        float                                 m_Length;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct IK
    {
        uint64_t m_Id;
        uint32_t m_Parent;
        uint32_t m_Child;
        uint32_t m_Target;
        bool     m_Positive;
        float    m_Mix;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Skeleton
    {
        struct
        {
            dmRigDDF::Bone* m_Data;
            const dmRigDDF::Bone& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::Bone& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Bones;

        struct
        {
            dmRigDDF::IK* m_Data;
            const dmRigDDF::IK& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::IK& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Iks;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AnimationTrack
    {
        uint64_t m_BoneId;
        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Positions;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Rotations;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Scale;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct EventKey
    {
        float    m_T;
        int32_t  m_Integer;
        float    m_Float;
        uint64_t m_String;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct EventTrack
    {
        uint64_t m_EventId;
        struct
        {
            dmRigDDF::EventKey* m_Data;
            const dmRigDDF::EventKey& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::EventKey& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Keys;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct RigAnimation
    {
        uint64_t m_Id;
        float    m_Duration;
        float    m_SampleRate;
        struct
        {
            dmRigDDF::AnimationTrack* m_Data;
            const dmRigDDF::AnimationTrack& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::AnimationTrack& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Tracks;

        struct
        {
            dmRigDDF::EventTrack* m_Data;
            const dmRigDDF::EventTrack& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::EventTrack& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_EventTracks;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AnimationSet
    {
        struct
        {
            dmRigDDF::RigAnimation* m_Data;
            const dmRigDDF::RigAnimation& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::RigAnimation& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Animations;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AnimationInstanceDesc
    {
        const char* m_Animation;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AnimationSetDesc
    {
        struct
        {
            dmRigDDF::AnimationInstanceDesc* m_Data;
            const dmRigDDF::AnimationInstanceDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::AnimationInstanceDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Animations;

        const char* m_Skeleton;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Mesh
    {
        dmVMath::Vector3            m_AabbMin;
        dmVMath::Vector3            m_AabbMax;
        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Positions;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Normals;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Tangents;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Colors;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Texcoord0;

        uint32_t                    m_NumTexcoord0Components;
        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Texcoord1;

        uint32_t                    m_NumTexcoord1Components;
        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Indices;

        dmRigDDF::IndexBufferFormat m_IndicesFormat;
        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Weights;

        struct
        {
            uint32_t* m_Data;
            const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_BoneIndices;

        uint32_t                    m_MaterialIndex;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DM_ALIGNED(16) Model
    {
        DM_ALIGNED(16) dmTransform::Transform m_Local;
        uint64_t                              m_Id;
        struct
        {
            dmRigDDF::Mesh* m_Data;
            const dmRigDDF::Mesh& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::Mesh& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Meshes;

        uint64_t                              m_BoneId;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct MeshSet
    {
        struct
        {
            dmRigDDF::Model* m_Data;
            const dmRigDDF::Model& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::Model& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Models;

        struct
        {
            dmRigDDF::Material* m_Data;
            const dmRigDDF::Material& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRigDDF::Material& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Materials;

        struct
        {
            uint64_t* m_Data;
            const uint64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_BoneList;

        uint32_t m_MaxBoneCount;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct RigScene
    {
        const char* m_Skeleton;
        const char* m_AnimationSet;
        const char* m_MeshSet;
        const char* m_TextureSet;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmRigDDF_AlphaMode_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmRigDDF_IndexBufferFormat_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Sampler_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Texture_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_TextureTransform_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_TextureView_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_PbrMetallicRoughness_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_PbrSpecularGlossiness_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Clearcoat_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Transmission_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Ior_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Specular_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Volume_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Sheen_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_EmissiveStrength_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Iridescence_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Material_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Bone_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_IK_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Skeleton_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_AnimationTrack_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_EventKey_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_EventTrack_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_RigAnimation_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_AnimationSet_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_AnimationInstanceDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_AnimationSetDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Mesh_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_Model_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_MeshSet_DESCRIPTOR;
extern dmDDF::Descriptor dmRigDDF_RigScene_DESCRIPTOR;
#endif
#endif // RIG_DDF_H 
