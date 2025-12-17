
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

#ifndef COMPUTE_DDF_H
#define COMPUTE_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "render/material_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmRenderDDF
{
    struct ComputeDesc
    {
        const char* m_ComputeProgram;
        struct
        {
            dmRenderDDF::MaterialDesc::Constant* m_Data;
            const dmRenderDDF::MaterialDesc::Constant& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::MaterialDesc::Constant& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Constants;

        struct
        {
            dmRenderDDF::MaterialDesc::Sampler* m_Data;
            const dmRenderDDF::MaterialDesc::Sampler& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmRenderDDF::MaterialDesc::Sampler& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Samplers;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmRenderDDF_ComputeDesc_DESCRIPTOR;
#endif
#endif // COMPUTE_DDF_H 
