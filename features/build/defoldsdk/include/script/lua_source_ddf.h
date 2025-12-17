
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

#ifndef LUA_SOURCE_DDF_H
#define LUA_SOURCE_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include <dmsdk/dlib/align.h>

namespace dmLuaDDF
{
    struct LuaSource
    {
        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Script;

        const char* m_Filename;
        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Bytecode;

        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Delta;

        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Bytecode32;

        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Bytecode64;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmLuaDDF_LuaSource_DESCRIPTOR;
#endif
#endif // LUA_SOURCE_DDF_H 
