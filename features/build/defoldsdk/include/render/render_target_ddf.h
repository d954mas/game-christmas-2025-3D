
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

#ifndef RENDER_TARGET_DDF_H
#define RENDER_TARGET_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "graphics/graphics_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmRenderDDF
{
    struct RenderTargetDesc
    {
        struct ColorAttachment
        {
            uint32_t                                m_Width;
            uint32_t                                m_Height;
            dmGraphics::TextureImage::TextureFormat m_Format;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct DepthStencilAttachment
        {
            uint32_t                       m_Width;
            uint32_t                       m_Height;
            dmGraphics::DepthStencilFormat m_Format;
            bool                           m_TextureStorage;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct
        {
            dmRenderDDF::RenderTargetDesc::ColorAttachment* m_Data;
            const dmRenderDDF::RenderTargetDesc::ColorAttachment& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::RenderTargetDesc::ColorAttachment& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ColorAttachments;

        dmRenderDDF::RenderTargetDesc::DepthStencilAttachment m_DepthStencilAttachment;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmRenderDDF_RenderTargetDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_RenderTargetDesc_ColorAttachment_DESCRIPTOR;
extern dmDDF::Descriptor dmRenderDDF_RenderTargetDesc_DepthStencilAttachment_DESCRIPTOR;
#endif
#endif // RENDER_TARGET_DDF_H 
