
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

#ifndef BUFFER_DDF_H
#define BUFFER_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmBufferDDF
{
    enum ValueType
    {
        VALUE_TYPE_UINT8   = 0,
        VALUE_TYPE_UINT16  = 1,
        VALUE_TYPE_UINT32  = 2,
        VALUE_TYPE_UINT64  = 3,
        VALUE_TYPE_INT8    = 4,
        VALUE_TYPE_INT16   = 5,
        VALUE_TYPE_INT32   = 6,
        VALUE_TYPE_INT64   = 7,
        VALUE_TYPE_FLOAT32 = 8,
    };

    struct StreamDesc
    {
        const char*            m_Name;
        dmBufferDDF::ValueType m_ValueType;
        uint32_t               m_ValueCount;
        struct
        {
            uint32_t* m_Data;
            const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Ui;

        struct
        {
            int32_t* m_Data;
            const int32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            int32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_I;

        struct
        {
            uint64_t* m_Data;
            const uint64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Ui64;

        struct
        {
            int64_t* m_Data;
            const int64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            int64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_I64;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_F;

        uint64_t               m_NameHash;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct BufferDesc
    {
        struct
        {
            dmBufferDDF::StreamDesc* m_Data;
            const dmBufferDDF::StreamDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmBufferDDF::StreamDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Streams;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmBufferDDF_ValueType_DESCRIPTOR;
extern dmDDF::Descriptor dmBufferDDF_StreamDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmBufferDDF_BufferDesc_DESCRIPTOR;
#endif
#endif // BUFFER_DDF_H 
