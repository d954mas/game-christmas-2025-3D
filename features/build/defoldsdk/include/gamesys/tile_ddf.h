
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

#ifndef TILE_DDF_H
#define TILE_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmGameSystemDDF
{
    enum Playback
    {
        PLAYBACK_NONE          = 0,
        PLAYBACK_ONCE_FORWARD  = 1,
        PLAYBACK_ONCE_BACKWARD = 2,
        PLAYBACK_ONCE_PINGPONG = 6,
        PLAYBACK_LOOP_FORWARD  = 3,
        PLAYBACK_LOOP_BACKWARD = 4,
        PLAYBACK_LOOP_PINGPONG = 5,
    };

    enum SpriteTrimmingMode
    {
        SPRITE_TRIM_MODE_OFF = 0,
        SPRITE_TRIM_MODE_4   = 4,
        SPRITE_TRIM_MODE_5   = 5,
        SPRITE_TRIM_MODE_6   = 6,
        SPRITE_TRIM_MODE_7   = 7,
        SPRITE_TRIM_MODE_8   = 8,
        SPRITE_TRIM_POLYGONS = 9,
    };

    struct ConvexHull
    {
        uint32_t    m_Index;
        uint32_t    m_Count;
        const char* m_CollisionGroup;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Cue
    {
        const char* m_Id;
        uint32_t    m_Frame;
        float       m_Value;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Animation
    {
        const char*               m_Id;
        uint32_t                  m_StartTile;
        uint32_t                  m_EndTile;
        dmGameSystemDDF::Playback m_Playback;
        uint32_t                  m_Fps;
        uint32_t                  m_FlipHorizontal;
        uint32_t                  m_FlipVertical;
        struct
        {
            dmGameSystemDDF::Cue* m_Data;
            const dmGameSystemDDF::Cue& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::Cue& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Cues;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TileSet
    {
        const char*                         m_Image;
        uint32_t                            m_TileWidth;
        uint32_t                            m_TileHeight;
        uint32_t                            m_TileMargin;
        uint32_t                            m_TileSpacing;
        const char*                         m_Collision;
        const char*                         m_MaterialTag;
        struct
        {
            dmGameSystemDDF::ConvexHull* m_Data;
            const dmGameSystemDDF::ConvexHull& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::ConvexHull& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ConvexHulls;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ConvexHullPoints;

        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_CollisionGroups;

        struct
        {
            dmGameSystemDDF::Animation* m_Data;
            const dmGameSystemDDF::Animation& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::Animation& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Animations;

        uint32_t                            m_ExtrudeBorders;
        uint32_t                            m_InnerPadding;
        dmGameSystemDDF::SpriteTrimmingMode m_SpriteTrimMode;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TileCell
    {
        int32_t  m_X;
        int32_t  m_Y;
        uint32_t m_Tile;
        uint32_t m_HFlip;
        uint32_t m_VFlip;
        uint32_t m_Rotate90;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TileLayer
    {
        const char* m_Id;
        float       m_Z;
        uint32_t    m_IsVisible;
        uint64_t    m_IdHash;
        struct
        {
            dmGameSystemDDF::TileCell* m_Data;
            const dmGameSystemDDF::TileCell& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::TileCell& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Cell;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TileGrid
    {
        enum BlendMode
        {
            BLEND_MODE_ALPHA     = 0,
            BLEND_MODE_ADD       = 1,
            BLEND_MODE_ADD_ALPHA = 2,
            BLEND_MODE_MULT      = 3,
            BLEND_MODE_SCREEN    = 4,
        };

        const char*                          m_TileSet;
        struct
        {
            dmGameSystemDDF::TileLayer* m_Data;
            const dmGameSystemDDF::TileLayer& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameSystemDDF::TileLayer& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Layers;

        const char*                          m_Material;
        dmGameSystemDDF::TileGrid::BlendMode m_BlendMode;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetConstantTileMap
    {
        uint64_t                        m_NameHash;
        DM_ALIGNED(16) dmVMath::Vector4 m_Value;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ResetConstantTileMap
    {
        uint64_t m_NameHash;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmGameSystemDDF_Playback_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmGameSystemDDF_SpriteTrimmingMode_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_ConvexHull_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_Cue_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_Animation_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_TileSet_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_TileCell_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_TileLayer_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_TileGrid_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetConstantTileMap_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_ResetConstantTileMap_DESCRIPTOR;
#endif
#endif // TILE_DDF_H 
