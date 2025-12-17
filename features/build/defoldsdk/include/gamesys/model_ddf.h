
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

#ifndef MODEL_DDF_H
#define MODEL_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "graphics/graphics_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmModelDDF
{
    struct Texture
    {
        const char* m_Sampler;
        const char* m_Texture;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Material
    {
        const char* m_Name;
        const char* m_Material;
        struct
        {
            dmModelDDF::Texture* m_Data;
            const dmModelDDF::Texture& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmModelDDF::Texture& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Textures;

        struct
        {
            dmGraphics::VertexAttribute* m_Data;
            const dmGraphics::VertexAttribute& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::VertexAttribute& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Attributes;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ModelDesc
    {
        const char* m_Mesh;
        const char* m_Material;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Textures;

        const char* m_Skeleton;
        const char* m_Animations;
        const char* m_DefaultAnimation;
        const char* m_Name;
        struct
        {
            dmModelDDF::Material* m_Data;
            const dmModelDDF::Material& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmModelDDF::Material& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Materials;

        bool        m_CreateGoBones;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Model
    {
        const char* m_RigScene;
        const char* m_DefaultAnimation;
        struct
        {
            dmModelDDF::Material* m_Data;
            const dmModelDDF::Material& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmModelDDF::Material& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Materials;

        bool        m_CreateGoBones;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ResetConstant
    {
        uint64_t m_NameHash;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetTexture
    {
        uint64_t m_TextureHash;
        uint32_t m_TextureUnit;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ModelPlayAnimation
    {
        uint64_t m_AnimationId;
        uint32_t m_Playback;
        float    m_BlendDuration;
        float    m_Offset;
        float    m_PlaybackRate;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ModelCancelAnimation
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ModelAnimationDone
    {
        uint64_t m_AnimationId;
        uint32_t m_Playback;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmModelDDF_Texture_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_Material_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_ModelDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_Model_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_ResetConstant_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_SetTexture_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_ModelPlayAnimation_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_ModelCancelAnimation_DESCRIPTOR;
extern dmDDF::Descriptor dmModelDDF_ModelAnimationDone_DESCRIPTOR;
#endif
#endif // MODEL_DDF_H 
