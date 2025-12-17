
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

#ifndef PROPERTIES_DDF_H
#define PROPERTIES_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmPropertiesDDF
{
    struct PropertyDeclarationEntry
    {
        const char* m_Key;
        uint64_t    m_Id;
        uint32_t    m_Index;
        struct
        {
            uint64_t* m_Data;
            const uint64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ElementIds;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PropertyDeclarations
    {
        struct
        {
            dmPropertiesDDF::PropertyDeclarationEntry* m_Data;
            const dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_NumberEntries;

        struct
        {
            dmPropertiesDDF::PropertyDeclarationEntry* m_Data;
            const dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_HashEntries;

        struct
        {
            dmPropertiesDDF::PropertyDeclarationEntry* m_Data;
            const dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_UrlEntries;

        struct
        {
            dmPropertiesDDF::PropertyDeclarationEntry* m_Data;
            const dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Vector3Entries;

        struct
        {
            dmPropertiesDDF::PropertyDeclarationEntry* m_Data;
            const dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Vector4Entries;

        struct
        {
            dmPropertiesDDF::PropertyDeclarationEntry* m_Data;
            const dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_QuatEntries;

        struct
        {
            dmPropertiesDDF::PropertyDeclarationEntry* m_Data;
            const dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPropertiesDDF::PropertyDeclarationEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_BoolEntries;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_FloatValues;

        struct
        {
            uint64_t* m_Data;
            const uint64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_HashValues;

        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_StringValues;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmPropertiesDDF_PropertyDeclarationEntry_DESCRIPTOR;
extern dmDDF::Descriptor dmPropertiesDDF_PropertyDeclarations_DESCRIPTOR;
#endif
#endif // PROPERTIES_DDF_H 
