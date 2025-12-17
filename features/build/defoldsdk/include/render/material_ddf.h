
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

#ifndef MATERIAL_DDF_H
#define MATERIAL_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "graphics/graphics_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmRenderDDF
{
    struct MaterialDesc
    {
        enum ConstantType
        {
            CONSTANT_TYPE_USER          = 0,
            CONSTANT_TYPE_VIEWPROJ      = 1,
            CONSTANT_TYPE_WORLD         = 2,
            CONSTANT_TYPE_TEXTURE       = 3,
            CONSTANT_TYPE_VIEW          = 4,
            CONSTANT_TYPE_PROJECTION    = 5,
            CONSTANT_TYPE_NORMAL        = 6,
            CONSTANT_TYPE_WORLDVIEW     = 7,
            CONSTANT_TYPE_WORLDVIEWPROJ = 8,
            CONSTANT_TYPE_USER_MATRIX4  = 9,
        };

        enum VertexSpace
        {
            VERTEX_SPACE_WORLD = 0,
            VERTEX_SPACE_LOCAL = 1,
        };

        enum WrapMode
        {
            WRAP_MODE_REPEAT          = 0,
            WRAP_MODE_MIRRORED_REPEAT = 1,
            WRAP_MODE_CLAMP_TO_EDGE   = 2,
        };

        enum FilterModeMin
        {
            FILTER_MODE_MIN_NEAREST                = 0,
            FILTER_MODE_MIN_LINEAR                 = 1,
            FILTER_MODE_MIN_NEAREST_MIPMAP_NEAREST = 2,
            FILTER_MODE_MIN_NEAREST_MIPMAP_LINEAR  = 3,
            FILTER_MODE_MIN_LINEAR_MIPMAP_NEAREST  = 4,
            FILTER_MODE_MIN_LINEAR_MIPMAP_LINEAR   = 5,
            FILTER_MODE_MIN_DEFAULT                = 6,
        };

        enum FilterModeMag
        {
            FILTER_MODE_MAG_NEAREST = 0,
            FILTER_MODE_MAG_LINEAR  = 1,
            FILTER_MODE_MAG_DEFAULT = 2,
        };

        struct Constant
        {
            const char*                             m_Name;
            dmRenderDDF::MaterialDesc::ConstantType m_Type;
            struct
            {
                dmMath::Vector4* m_Data;
                const dmMath::Vector4& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmMath::Vector4& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Value;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct PbrParameters
        {
            bool m_HasParameters;
            bool m_HasMetallicRoughness;
            bool m_HasSpecularGlossiness;
            bool m_HasClearcoat;
            bool m_HasTransmission;
            bool m_HasIor;
            bool m_HasSpecular;
            bool m_HasVolume;
            bool m_HasSheen;
            bool m_HasEmissiveStrength;
            bool m_HasIridescence;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct Sampler
        {
            const char*                              m_Name;
            dmRenderDDF::MaterialDesc::WrapMode      m_WrapU;
            dmRenderDDF::MaterialDesc::WrapMode      m_WrapV;
            dmRenderDDF::MaterialDesc::FilterModeMin m_FilterMin;
            dmRenderDDF::MaterialDesc::FilterModeMag m_FilterMag;
            float                                    m_MaxAnisotropy;
            struct
            {
                uint64_t* m_Data;
                const uint64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                uint64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_NameIndirections;

            const char*                              m_Texture;
            uint64_t                                 m_NameHash;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        const char*                              m_Name;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Tags;

        const char*                              m_VertexProgram;
        const char*                              m_FragmentProgram;
        dmRenderDDF::MaterialDesc::VertexSpace   m_VertexSpace;
        struct
        {
            dmRenderDDF::MaterialDesc::Constant* m_Data;
            const dmRenderDDF::MaterialDesc::Constant& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::MaterialDesc::Constant& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_VertexConstants;

        struct
        {
            dmRenderDDF::MaterialDesc::Constant* m_Data;
            const dmRenderDDF::MaterialDesc::Constant& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::MaterialDesc::Constant& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_FragmentConstants;

        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Textures;

        struct
        {
            dmRenderDDF::MaterialDesc::Sampler* m_Data;
            const dmRenderDDF::MaterialDesc::Sampler& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::MaterialDesc::Sampler& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Samplers;

        uint32_t                                 m_MaxPageCount;
        struct
        {
            dmGraphics::VertexAttribute* m_Data;
            const dmGraphics::VertexAttribute& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::VertexAttribute& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Attributes;

        const char*                              m_Program;
        dmRenderDDF::MaterialDesc::PbrParameters m_PbrParameters;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmRenderDDF_MaterialDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_MaterialDesc_Constant_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_MaterialDesc_PbrParameters_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_MaterialDesc_Sampler_DESCRIPTOR;
#endif
#endif // MATERIAL_DDF_H 
