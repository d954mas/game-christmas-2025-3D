
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

#ifndef RENDER_DDF_H
#define RENDER_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmRenderDDF
{
    struct RenderPrototypeDesc
    {
        struct MaterialDesc
        {
            const char* m_Name;
            const char* m_Material;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct RenderResourceDesc
        {
            const char* m_Name;
            const char* m_Path;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        const char* m_Script;
        struct
        {
            dmRenderDDF::RenderPrototypeDesc::MaterialDesc* m_Data;
            const dmRenderDDF::RenderPrototypeDesc::MaterialDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::RenderPrototypeDesc::MaterialDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Materials;

        struct
        {
            dmRenderDDF::RenderPrototypeDesc::RenderResourceDesc* m_Data;
            const dmRenderDDF::RenderPrototypeDesc::RenderResourceDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::RenderPrototypeDesc::RenderResourceDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_RenderResources;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DrawText
    {
        dmVMath::Point3 m_Position;
        const char*     m_Text;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DrawDebugText
    {
        dmVMath::Point3  m_Position;
        const char*      m_Text;
        dmVMath::Vector4 m_Color;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DrawLine
    {
        dmVMath::Point3  m_StartPoint;
        dmVMath::Point3  m_EndPoint;
        dmVMath::Vector4 m_Color;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct WindowResized
    {
        uint32_t m_Width;
        uint32_t m_Height;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Resize
    {
        uint32_t m_Width;
        uint32_t m_Height;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ClearColor
    {
        dmVMath::Vector4 m_Color;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DisplayProfileQualifier
    {
        uint32_t m_Width;
        uint32_t m_Height;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_DeviceModels;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DisplayProfile
    {
        const char* m_Name;
        struct
        {
            dmRenderDDF::DisplayProfileQualifier* m_Data;
            const dmRenderDDF::DisplayProfileQualifier& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::DisplayProfileQualifier& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Qualifiers;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct DisplayProfiles
    {
        struct
        {
            dmRenderDDF::DisplayProfile* m_Data;
            const dmRenderDDF::DisplayProfile& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::DisplayProfile& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Profiles;

        bool m_AutoLayoutSelection;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmRenderDDF_RenderPrototypeDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_RenderPrototypeDesc_MaterialDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_RenderPrototypeDesc_RenderResourceDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_DrawText_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_DrawDebugText_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_DrawLine_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_WindowResized_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_Resize_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_ClearColor_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_DisplayProfileQualifier_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_DisplayProfile_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_DisplayProfiles_DESCRIPTOR;
#endif
#endif // RENDER_DDF_H 
