
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

#ifndef FONT_DDF_H
#define FONT_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmRenderDDF
{
    enum FontTextureFormat
    {
        TYPE_BITMAP         = 0,
        TYPE_DISTANCE_FIELD = 1,
    };

    enum FontRenderMode
    {
        MODE_SINGLE_LAYER = 0,
        MODE_MULTI_LAYER  = 1,
    };

    struct FontDesc
    {
        const char*                    m_Font;
        const char*                    m_Material;
        uint32_t                       m_Size;
        uint32_t                       m_Antialias;
        float                          m_Alpha;
        float                          m_OutlineAlpha;
        float                          m_OutlineWidth;
        float                          m_ShadowAlpha;
        uint32_t                       m_ShadowBlur;
        float                          m_ShadowX;
        float                          m_ShadowY;
        const char*                    m_ExtraCharacters;
        dmRenderDDF::FontTextureFormat m_OutputFormat;
        bool                           m_AllChars;
        uint32_t                       m_CacheWidth;
        uint32_t                       m_CacheHeight;
        dmRenderDDF::FontRenderMode    m_RenderMode;
        const char*                    m_Characters;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct GlyphBank
    {
        struct Glyph
        {
            uint32_t m_Character;
            float    m_Width;
            uint32_t m_ImageWidth;
            float    m_Advance;
            float    m_LeftBearing;
            int32_t  m_Ascent;
            int32_t  m_Descent;
            int32_t  m_X;
            int32_t  m_Y;
            uint64_t m_GlyphDataOffset;
            uint64_t m_GlyphDataSize;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct
        {
            dmRenderDDF::GlyphBank::Glyph* m_Data;
            const dmRenderDDF::GlyphBank::Glyph& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::GlyphBank::Glyph& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Glyphs;

        uint64_t                       m_GlyphPadding;
        uint32_t                       m_GlyphChannels;
        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_GlyphData;

        float                          m_MaxAscent;
        float                          m_MaxDescent;
        float                          m_MaxAdvance;
        float                          m_MaxWidth;
        float                          m_MaxHeight;
        dmRenderDDF::FontTextureFormat m_ImageFormat;
        float                          m_SdfSpread;
        float                          m_SdfOutline;
        float                          m_SdfShadow;
        uint32_t                       m_CacheWidth;
        uint32_t                       m_CacheHeight;
        uint32_t                       m_CacheCellWidth;
        uint32_t                       m_CacheCellHeight;
        uint32_t                       m_CacheCellMaxAscent;
        uint32_t                       m_Padding;
        bool                           m_IsMonospaced;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct FontMap
    {
        const char*                    m_Material;
        const char*                    m_GlyphBank;
        const char*                    m_Font;
        uint32_t                       m_Size;
        uint32_t                       m_Antialias;
        float                          m_ShadowX;
        float                          m_ShadowY;
        uint32_t                       m_ShadowBlur;
        float                          m_ShadowAlpha;
        float                          m_Alpha;
        float                          m_OutlineAlpha;
        float                          m_OutlineWidth;
        uint32_t                       m_LayerMask;
        dmRenderDDF::FontTextureFormat m_OutputFormat;
        dmRenderDDF::FontRenderMode    m_RenderMode;
        bool                           m_AllChars;
        const char*                    m_Characters;
        uint32_t                       m_CacheWidth;
        uint32_t                       m_CacheHeight;
        float                          m_SdfSpread;
        float                          m_SdfOutline;
        float                          m_SdfShadow;
        uint32_t                       m_Padding;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmRenderDDF_FontTextureFormat_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmRenderDDF_FontRenderMode_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_FontDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_GlyphBank_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_GlyphBank_Glyph_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_FontMap_DESCRIPTOR;
#endif
#endif // FONT_DDF_H 
