
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

#ifndef ATLAS_DDF_H
#define ATLAS_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "gamesys/tile_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmGameSystemDDF
{
    struct AtlasImage
    {
        const char*                         m_Image;
        dmGameSystemDDF::SpriteTrimmingMode m_SpriteTrimMode;
        float                               m_PivotX;
        float                               m_PivotY;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AtlasAnimation
    {
        const char*               m_Id;
        struct
        {
            dmGameSystemDDF::AtlasImage* m_Data;
            const dmGameSystemDDF::AtlasImage& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::AtlasImage& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Images;

        dmGameSystemDDF::Playback m_Playback;
        uint32_t                  m_Fps;
        uint32_t                  m_FlipHorizontal;
        uint32_t                  m_FlipVertical;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Atlas
    {
        struct
        {
            dmGameSystemDDF::AtlasImage* m_Data;
            const dmGameSystemDDF::AtlasImage& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::AtlasImage& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Images;

        struct
        {
            dmGameSystemDDF::AtlasAnimation* m_Data;
            const dmGameSystemDDF::AtlasAnimation& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::AtlasAnimation& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Animations;

        uint32_t    m_Margin;
        uint32_t    m_ExtrudeBorders;
        uint32_t    m_InnerPadding;
        uint32_t    m_MaxPageWidth;
        uint32_t    m_MaxPageHeight;
        const char* m_RenamePatterns;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmGameSystemDDF_AtlasImage_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_AtlasAnimation_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_Atlas_DESCRIPTOR;
#endif
#endif // ATLAS_DDF_H 
