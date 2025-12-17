
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

#ifndef GAMEOBJECT_DDF_H
#define GAMEOBJECT_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "gameobject/properties_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmGameObjectDDF
{
    enum PropertyType
    {
        PROPERTY_TYPE_NUMBER  = 0,
        PROPERTY_TYPE_HASH    = 1,
        PROPERTY_TYPE_URL     = 2,
        PROPERTY_TYPE_VECTOR3 = 3,
        PROPERTY_TYPE_VECTOR4 = 4,
        PROPERTY_TYPE_QUAT    = 5,
        PROPERTY_TYPE_BOOLEAN = 6,
        PROPERTY_TYPE_MATRIX4 = 7,
        PROPERTY_TYPE_COUNT   = 8,
    };

    struct PropertyDesc
    {
        const char*                   m_Id;
        const char*                   m_Value;
        dmGameObjectDDF::PropertyType m_Type;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ComponentDesc
    {
        const char*                           m_Id;
        const char*                           m_Component;
        dmVMath::Point3                       m_Position;
        dmVMath::Quat                         m_Rotation;
        struct
        {
            dmGameObjectDDF::PropertyDesc* m_Data;
            const dmGameObjectDDF::PropertyDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::PropertyDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Properties;

        dmPropertiesDDF::PropertyDeclarations m_PropertyDecls;
        dmVMath::Vector3                      m_Scale;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct EmbeddedComponentDesc
    {
        const char*      m_Id;
        const char*      m_Type;
        const char*      m_Data;
        dmVMath::Point3  m_Position;
        dmVMath::Quat    m_Rotation;
        dmVMath::Vector3 m_Scale;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PrototypeDesc
    {
        struct
        {
            dmGameObjectDDF::ComponentDesc* m_Data;
            const dmGameObjectDDF::ComponentDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::ComponentDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Components;

        struct
        {
            dmGameObjectDDF::EmbeddedComponentDesc* m_Data;
            const dmGameObjectDDF::EmbeddedComponentDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::EmbeddedComponentDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_EmbeddedComponents;

        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_PropertyResources;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ComponentPropertyDesc
    {
        const char*                           m_Id;
        struct
        {
            dmGameObjectDDF::PropertyDesc* m_Data;
            const dmGameObjectDDF::PropertyDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::PropertyDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Properties;

        dmPropertiesDDF::PropertyDeclarations m_PropertyDecls;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ComponenTypeDesc
    {
        uint64_t m_NameHash;
        uint32_t m_MaxCount;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct InstanceDesc
    {
        const char*      m_Id;
        const char*      m_Prototype;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Children;

        dmVMath::Point3  m_Position;
        dmVMath::Quat    m_Rotation;
        struct
        {
            dmGameObjectDDF::ComponentPropertyDesc* m_Data;
            const dmGameObjectDDF::ComponentPropertyDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::ComponentPropertyDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ComponentProperties;

        float            m_Scale;
        dmVMath::Vector3 m_Scale3;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct EmbeddedInstanceDesc
    {
        const char*      m_Id;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Children;

        const char*      m_Data;
        dmVMath::Point3  m_Position;
        dmVMath::Quat    m_Rotation;
        struct
        {
            dmGameObjectDDF::ComponentPropertyDesc* m_Data;
            const dmGameObjectDDF::ComponentPropertyDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::ComponentPropertyDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ComponentProperties;

        float            m_Scale;
        dmVMath::Vector3 m_Scale3;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct InstancePropertyDesc
    {
        const char* m_Id;
        struct
        {
            dmGameObjectDDF::ComponentPropertyDesc* m_Data;
            const dmGameObjectDDF::ComponentPropertyDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::ComponentPropertyDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Properties;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollectionInstanceDesc
    {
        const char*      m_Id;
        const char*      m_Collection;
        dmVMath::Point3  m_Position;
        dmVMath::Quat    m_Rotation;
        float            m_Scale;
        dmVMath::Vector3 m_Scale3;
        struct
        {
            dmGameObjectDDF::InstancePropertyDesc* m_Data;
            const dmGameObjectDDF::InstancePropertyDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::InstancePropertyDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_InstanceProperties;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollectionDesc
    {
        const char* m_Name;
        struct
        {
            dmGameObjectDDF::InstanceDesc* m_Data;
            const dmGameObjectDDF::InstanceDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::InstanceDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Instances;

        struct
        {
            dmGameObjectDDF::CollectionInstanceDesc* m_Data;
            const dmGameObjectDDF::CollectionInstanceDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::CollectionInstanceDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_CollectionInstances;

        uint32_t    m_ScaleAlongZ;
        struct
        {
            dmGameObjectDDF::EmbeddedInstanceDesc* m_Data;
            const dmGameObjectDDF::EmbeddedInstanceDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::EmbeddedInstanceDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_EmbeddedInstances;

        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_PropertyResources;

        struct
        {
            dmGameObjectDDF::ComponenTypeDesc* m_Data;
            const dmGameObjectDDF::ComponenTypeDesc& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGameObjectDDF::ComponenTypeDesc& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ComponentTypes;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AcquireInputFocus
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ReleaseInputFocus
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetParent
    {
        uint64_t m_ParentId;
        uint32_t m_KeepWorldTransform;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Enable
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Disable
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ScriptMessage
    {
        uint64_t m_DescriptorHash;
        uint32_t m_PayloadSize;
        uint32_t m_Function;
        bool     m_UnrefFunction;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ScriptUnrefMessage
    {
        uint32_t m_Reference;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmGameObjectDDF_PropertyType_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_PropertyDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_ComponentDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_EmbeddedComponentDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_PrototypeDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_ComponentPropertyDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_ComponenTypeDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_InstanceDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_EmbeddedInstanceDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_InstancePropertyDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_CollectionInstanceDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_CollectionDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_AcquireInputFocus_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_ReleaseInputFocus_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_SetParent_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_Enable_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_Disable_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_ScriptMessage_DESCRIPTOR;
extern dmDDF::Descriptor dmGameObjectDDF_ScriptUnrefMessage_DESCRIPTOR;
#endif
#endif // GAMEOBJECT_DDF_H 
