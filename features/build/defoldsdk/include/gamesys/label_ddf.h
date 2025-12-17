
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

#ifndef LABEL_DDF_H
#define LABEL_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmGameSystemDDF
{
    struct LabelDesc
    {
        enum BlendMode
        {
            BLEND_MODE_ALPHA  = 0,
            BLEND_MODE_ADD    = 1,
            BLEND_MODE_MULT   = 3,
            BLEND_MODE_SCREEN = 4,
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

        dmVMath::Vector4                      m_Size;
        dmVMath::Vector4                      m_Scale;
        dmVMath::Vector4                      m_Color;
        dmVMath::Vector4                      m_Outline;
        dmVMath::Vector4                      m_Shadow;
        float                                 m_Leading;
        float                                 m_Tracking;
        dmGameSystemDDF::LabelDesc::Pivot     m_Pivot;
        dmGameSystemDDF::LabelDesc::BlendMode m_BlendMode;
        bool                                  m_LineBreak;
        const char*                           m_Text;
        const char*                           m_Font;
        const char*                           m_Material;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetText
    {
        const char* m_Text;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmGameSystemDDF_LabelDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetText_DESCRIPTOR;
#endif
#endif // LABEL_DDF_H 
