
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

#ifndef SPRITE_DDF_H
#define SPRITE_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "graphics/graphics_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmGameSystemDDF
{
    struct SpriteTexture
    {
        const char* m_Sampler;
        const char* m_Texture;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SpriteDesc
    {
        enum BlendMode
        {
            BLEND_MODE_ALPHA     = 0,
            BLEND_MODE_ADD       = 1,
            BLEND_MODE_ADD_ALPHA = 2,
            BLEND_MODE_MULT      = 3,
            BLEND_MODE_SCREEN    = 4,
        };

        enum SizeMode
        {
            SIZE_MODE_MANUAL = 0,
            SIZE_MODE_AUTO   = 1,
        };

        const char*                            m_TileSet;
        const char*                            m_DefaultAnimation;
        const char*                            m_Material;
        dmGameSystemDDF::SpriteDesc::BlendMode m_BlendMode;
        dmVMath::Vector4                       m_Slice9;
        dmVMath::Vector4                       m_Size;
        dmGameSystemDDF::SpriteDesc::SizeMode  m_SizeMode;
        float                                  m_Offset;
        float                                  m_PlaybackRate;
        struct
        {
            dmGraphics::VertexAttribute* m_Data;
            const dmGraphics::VertexAttribute& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::VertexAttribute& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Attributes;

        struct
        {
            dmGameSystemDDF::SpriteTexture* m_Data;
            const dmGameSystemDDF::SpriteTexture& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::SpriteTexture& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Textures;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PlayAnimation
    {
        uint64_t m_Id;
        float    m_Offset;
        float    m_PlaybackRate;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AnimationDone
    {
        uint32_t m_CurrentTile;
        uint64_t m_Id;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetFlipHorizontal
    {
        uint32_t m_Flip;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetFlipVertical
    {
        uint32_t m_Flip;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmGameSystemDDF_SpriteTexture_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SpriteDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_PlayAnimation_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_AnimationDone_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetFlipHorizontal_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetFlipVertical_DESCRIPTOR;
#endif
#endif // SPRITE_DDF_H 
