
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

#ifndef GUI_DDF_H
#define GUI_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmGuiDDF
{
    struct NodeDesc
    {
        enum Type
        {
            TYPE_BOX        = 0,
            TYPE_TEXT       = 1,
            TYPE_PIE        = 2,
            TYPE_TEMPLATE   = 3,
            TYPE_SPINE      = 4,
            TYPE_PARTICLEFX = 5,
            TYPE_CUSTOM     = 6,
        };

        enum BlendMode
        {
            BLEND_MODE_ALPHA     = 0,
            BLEND_MODE_ADD       = 1,
            BLEND_MODE_ADD_ALPHA = 2,
            BLEND_MODE_MULT      = 3,
            BLEND_MODE_SCREEN    = 4,
        };

        enum ClippingMode
        {
            CLIPPING_MODE_NONE    = 0,
            CLIPPING_MODE_STENCIL = 2,
        };

        enum XAnchor
        {
            XANCHOR_NONE  = 0,
            XANCHOR_LEFT  = 1,
            XANCHOR_RIGHT = 2,
        };

        enum YAnchor
        {
            YANCHOR_NONE   = 0,
            YANCHOR_TOP    = 1,
            YANCHOR_BOTTOM = 2,
        };

        enum Pivot
        {
            PIVOT_CENTER = 0,
            PIVOT_N      = 1,
            PIVOT_NE     = 2,
            PIVOT_E      = 3,
            PIVOT_SE     = 4,
            PIVOT_S      = 5,
            PIVOT_SW     = 6,
            PIVOT_W      = 7,
            PIVOT_NW     = 8,
        };

        enum AdjustMode
        {
            ADJUST_MODE_FIT     = 0,
            ADJUST_MODE_ZOOM    = 1,
            ADJUST_MODE_STRETCH = 2,
        };

        enum SizeMode
        {
            SIZE_MODE_MANUAL = 0,
            SIZE_MODE_AUTO   = 1,
        };

        enum PieBounds
        {
            PIEBOUNDS_RECTANGLE = 0,
            PIEBOUNDS_ELLIPSE   = 1,
        };

        dmVMath::Vector4                 m_Position;
        dmVMath::Vector4                 m_Rotation;
        dmVMath::Vector4                 m_Scale;
        dmVMath::Vector4                 m_Size;
        dmVMath::Vector4                 m_Color;
        dmGuiDDF::NodeDesc::Type         m_Type;
        dmGuiDDF::NodeDesc::BlendMode    m_BlendMode;
        const char*                      m_Text;
        const char*                      m_Texture;
        const char*                      m_Font;
        const char*                      m_Id;
        dmGuiDDF::NodeDesc::XAnchor      m_Xanchor;
        dmGuiDDF::NodeDesc::YAnchor      m_Yanchor;
        dmGuiDDF::NodeDesc::Pivot        m_Pivot;
        dmVMath::Vector4                 m_Outline;
        dmVMath::Vector4                 m_Shadow;
        dmGuiDDF::NodeDesc::AdjustMode   m_AdjustMode;
        bool                             m_LineBreak;
        const char*                      m_Parent;
        const char*                      m_Layer;
        bool                             m_InheritAlpha;
        dmVMath::Vector4                 m_Slice9;
        dmGuiDDF::NodeDesc::PieBounds    m_Outerbounds;
        float                            m_Innerradius;
        int32_t                          m_Perimetervertices;
        float                            m_Piefillangle;
        dmGuiDDF::NodeDesc::ClippingMode m_ClippingMode;
        bool                             m_ClippingVisible;
        bool                             m_ClippingInverted;
        float                            m_Alpha;
        float                            m_OutlineAlpha;
        float                            m_ShadowAlpha;
        struct
        {
            uint32_t* m_Data;
            const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_OverriddenFields;

        const char*                      m_Template;
        bool                             m_TemplateNodeChild;
        float                            m_TextLeading;
        float                            m_TextTracking;
        dmGuiDDF::NodeDesc::SizeMode     m_SizeMode;
        const char*                      m_SpineScene;
        const char*                      m_SpineDefaultAnimation;
        const char*                      m_SpineSkin;
        bool                             m_SpineNodeChild;
        const char*                      m_Particlefx;
        uint32_t                         m_CustomType;
        bool                             m_Enabled;
        bool                             m_Visible;
        const char*                      m_Material;
        bool                             m_SpineCreateBones;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SceneDesc
    {
        enum AdjustReference
        {
            ADJUST_REFERENCE_LEGACY   = 0,
            ADJUST_REFERENCE_PARENT   = 1,
            ADJUST_REFERENCE_DISABLED = 2,
        };

        struct FontDesc
        {
            const char* m_Name;
            const char* m_Font;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct TextureDesc
        {
            const char* m_Name;
            const char* m_Texture;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct LayerDesc
        {
            const char* m_Name;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct LayoutDesc
        {
            const char* m_Name;
            struct
            {
                dmGuiDDF::NodeDesc* m_Data;
                const dmGuiDDF::NodeDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGuiDDF::NodeDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Nodes;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct MaterialDesc
        {
            const char* m_Name;
            const char* m_Material;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct SpineSceneDesc
        {
            const char* m_Name;
            const char* m_SpineScene;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct ResourceDesc
        {
            const char* m_Name;
            const char* m_Path;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct ParticleFXDesc
        {
            const char* m_Name;
            const char* m_Particlefx;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        const char*                          m_Script;
        struct
        {
            dmGuiDDF::SceneDesc::FontDesc* m_Data;
            const dmGuiDDF::SceneDesc::FontDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::FontDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Fonts;

        struct
        {
            dmGuiDDF::SceneDesc::TextureDesc* m_Data;
            const dmGuiDDF::SceneDesc::TextureDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::TextureDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Textures;

        dmVMath::Vector4                     m_BackgroundColor;
        struct
        {
            dmGuiDDF::NodeDesc* m_Data;
            const dmGuiDDF::NodeDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::NodeDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Nodes;

        struct
        {
            dmGuiDDF::SceneDesc::LayerDesc* m_Data;
            const dmGuiDDF::SceneDesc::LayerDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::LayerDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Layers;

        const char*                          m_Material;
        struct
        {
            dmGuiDDF::SceneDesc::LayoutDesc* m_Data;
            const dmGuiDDF::SceneDesc::LayoutDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::LayoutDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Layouts;

        dmGuiDDF::SceneDesc::AdjustReference m_AdjustReference;
        uint32_t                             m_MaxNodes;
        struct
        {
            dmGuiDDF::SceneDesc::SpineSceneDesc* m_Data;
            const dmGuiDDF::SceneDesc::SpineSceneDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::SpineSceneDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_SpineScenes;

        struct
        {
            dmGuiDDF::SceneDesc::ParticleFXDesc* m_Data;
            const dmGuiDDF::SceneDesc::ParticleFXDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::ParticleFXDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Particlefxs;

        struct
        {
            dmGuiDDF::SceneDesc::ResourceDesc* m_Data;
            const dmGuiDDF::SceneDesc::ResourceDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::ResourceDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Resources;

        struct
        {
            dmGuiDDF::SceneDesc::MaterialDesc* m_Data;
            const dmGuiDDF::SceneDesc::MaterialDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGuiDDF::SceneDesc::MaterialDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Materials;

        uint32_t                             m_MaxDynamicTextures;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct LayoutChanged
    {
        uint64_t m_Id;
        uint64_t m_PreviousId;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmGuiDDF_NodeDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_FontDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_TextureDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_LayerDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_LayoutDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_MaterialDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_SpineSceneDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_ResourceDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_SceneDesc_ParticleFXDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGuiDDF_LayoutChanged_DESCRIPTOR;
#endif
#endif // GUI_DDF_H 
