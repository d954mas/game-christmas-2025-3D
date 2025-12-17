
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

#ifndef SCRIPT_DOC_DDF_H
#define SCRIPT_DOC_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include <dmsdk/dlib/align.h>

namespace dmScriptDoc
{
    enum Type
    {
        FUNCTION  = 0,
        VARIABLE  = 1,
        MESSAGE   = 2,
        NAMESPACE = 3,
        PROPERTY  = 4,
        PACKAGE   = 5,
        STRUCT    = 6,
        MACRO     = 7,
        ENUM      = 8,
        TYPEDEF   = 9,
        CLASS     = 10,
        CONSTANT  = 11,
    };

    struct Parameter
    {
        const char* m_Name;
        const char* m_Doc;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Types;

        bool        m_IsOptional;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Member
    {
        const char* m_Name;
        const char* m_Doc;
        const char* m_Type;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ReturnValue
    {
        const char* m_Name;
        const char* m_Doc;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Types;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Element
    {
        dmScriptDoc::Type m_Type;
        const char*       m_Name;
        const char*       m_Brief;
        const char*       m_Description;
        struct
        {
            dmScriptDoc::ReturnValue* m_Data;
            const dmScriptDoc::ReturnValue& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmScriptDoc::ReturnValue& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Returnvalues;

        struct
        {
            dmScriptDoc::Parameter* m_Data;
            const dmScriptDoc::Parameter& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmScriptDoc::Parameter& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Parameters;

        const char*       m_Examples;
        const char*       m_Replaces;
        const char*       m_Error;
        struct
        {
            dmScriptDoc::Member* m_Data;
            const dmScriptDoc::Member& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmScriptDoc::Member& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Tparams;

        struct
        {
            dmScriptDoc::Member* m_Data;
            const dmScriptDoc::Member& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmScriptDoc::Member& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Members;

        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Notes;

        const char*       m_Language;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Info
    {
        const char* m_Namespace;
        const char* m_Name;
        const char* m_Brief;
        const char* m_Description;
        const char* m_Path;
        const char* m_File;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Notes;

        const char* m_Language;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Document
    {
        struct
        {
            dmScriptDoc::Element* m_Data;
            const dmScriptDoc::Element& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmScriptDoc::Element& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Elements;

        dmScriptDoc::Info m_Info;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmScriptDoc_Type_DESCRIPTOR;
extern dmDDF::Descriptor dmScriptDoc_Parameter_DESCRIPTOR;
extern dmDDF::Descriptor dmScriptDoc_Member_DESCRIPTOR;
extern dmDDF::Descriptor dmScriptDoc_ReturnValue_DESCRIPTOR;
extern dmDDF::Descriptor dmScriptDoc_Element_DESCRIPTOR;
extern dmDDF::Descriptor dmScriptDoc_Info_DESCRIPTOR;
extern dmDDF::Descriptor dmScriptDoc_Document_DESCRIPTOR;
#endif
#endif // SCRIPT_DOC_DDF_H 
