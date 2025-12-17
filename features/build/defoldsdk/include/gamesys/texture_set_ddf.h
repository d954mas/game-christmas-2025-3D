
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

#ifndef TEXTURE_SET_DDF_H
#define TEXTURE_SET_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "gamesys/tile_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmGameSystemDDF
{
    struct TextureSetAnimation
    {
        const char*               m_Id;
        uint32_t                  m_Width;
        uint32_t                  m_Height;
        uint32_t                  m_Start;
        uint32_t                  m_End;
        uint32_t                  m_Fps;
        dmGameSystemDDF::Playback m_Playback;
        uint32_t                  m_FlipHorizontal;
        uint32_t                  m_FlipVertical;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SpriteGeometry
    {
        uint32_t                            m_Width;
        uint32_t                            m_Height;
        float                               m_CenterX;
        float                               m_CenterY;
        bool                                m_Rotated;
        dmGameSystemDDF::SpriteTrimmingMode m_TrimMode;
        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Vertices;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Uvs;

        struct
        {
            uint32_t* m_Data;
            const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Indices;

        float                               m_PivotX;
        float                               m_PivotY;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TextureSet
    {
        const char* m_Texture;
        uint32_t    m_Width;
        uint32_t    m_Height;
        uint64_t    m_TextureHash;
        struct
        {
            dmGameSystemDDF::TextureSetAnimation* m_Data;
            const dmGameSystemDDF::TextureSetAnimation& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::TextureSetAnimation& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Animations;

        uint32_t    m_TileWidth;
        uint32_t    m_TileHeight;
        uint32_t    m_TileCount;
        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_CollisionHullPoints;

        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_CollisionGroups;

        struct
        {
            dmGameSystemDDF::ConvexHull* m_Data;
            const dmGameSystemDDF::ConvexHull& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::ConvexHull& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ConvexHulls;

        struct
        {
            uint64_t* m_Data;
            const uint64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ImageNameHashes;

        struct
        {
            uint32_t* m_Data;
            const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_FrameIndices;

        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_TexCoords;

        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_TexDims;

        struct
        {
            dmGameSystemDDF::SpriteGeometry* m_Data;
            const dmGameSystemDDF::SpriteGeometry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::SpriteGeometry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Geometries;

        uint32_t    m_UseGeometries;
        struct
        {
            uint32_t* m_Data;
            const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_PageIndices;

        uint32_t    m_PageCount;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmGameSystemDDF_TextureSetAnimation_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SpriteGeometry_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_TextureSet_DESCRIPTOR;
#endif
#endif // TEXTURE_SET_DDF_H 
