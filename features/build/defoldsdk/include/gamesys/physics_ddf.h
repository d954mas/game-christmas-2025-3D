
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

#ifndef PHYSICS_DDF_H
#define PHYSICS_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmPhysicsDDF
{
    enum CollisionObjectType
    {
        COLLISION_OBJECT_TYPE_DYNAMIC   = 0,
        COLLISION_OBJECT_TYPE_KINEMATIC = 1,
        COLLISION_OBJECT_TYPE_STATIC    = 2,
        COLLISION_OBJECT_TYPE_TRIGGER   = 3,
    };

    struct ConvexShape
    {
        enum Type
        {
            TYPE_SPHERE  = 0,
            TYPE_BOX     = 1,
            TYPE_CAPSULE = 2,
            TYPE_HULL    = 3,
        };

        dmPhysicsDDF::ConvexShape::Type m_ShapeType;
        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Data;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollisionShape
    {
        enum Type
        {
            TYPE_SPHERE  = 0,
            TYPE_BOX     = 1,
            TYPE_CAPSULE = 2,
            TYPE_HULL    = 3,
        };

        struct Shape
        {
            dmPhysicsDDF::CollisionShape::Type m_ShapeType;
            dmVMath::Point3                    m_Position;
            dmVMath::Quat                      m_Rotation;
            uint32_t                           m_Index;
            uint32_t                           m_Count;
            const char*                        m_Id;
            uint64_t                           m_IdHash;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct
        {
            dmPhysicsDDF::CollisionShape::Shape* m_Data;
            const dmPhysicsDDF::CollisionShape::Shape& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmPhysicsDDF::CollisionShape::Shape& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Shapes;

        struct
        {
            float* m_Data;
            const float& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            float& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Data;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollisionObjectDesc
    {
        const char*                       m_CollisionShape;
        dmPhysicsDDF::CollisionObjectType m_Type;
        float                             m_Mass;
        float                             m_Friction;
        float                             m_Restitution;
        const char*                       m_Group;
        struct
        {
            const char** m_Data;
            const char* operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Mask;

        dmPhysicsDDF::CollisionShape      m_EmbeddedCollisionShape;
        float                             m_LinearDamping;
        float                             m_AngularDamping;
        bool                              m_LockedRotation;
        bool                              m_Bullet;
        bool                              m_EventCollision;
        bool                              m_EventContact;
        bool                              m_EventTrigger;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ApplyForce
    {
        dmVMath::Vector3 m_Force;
        dmVMath::Point3  m_Position;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollisionResponse
    {
        uint64_t        m_OtherId;
        uint64_t        m_Group;
        dmVMath::Point3 m_OtherPosition;
        uint64_t        m_OtherGroup;
        uint64_t        m_OwnGroup;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ContactPointResponse
    {
        dmVMath::Point3  m_Position;
        dmVMath::Vector3 m_Normal;
        dmVMath::Vector3 m_RelativeVelocity;
        float            m_Distance;
        float            m_AppliedImpulse;
        float            m_LifeTime;
        float            m_Mass;
        float            m_OtherMass;
        uint64_t         m_OtherId;
        dmVMath::Point3  m_OtherPosition;
        uint64_t         m_Group;
        uint64_t         m_OtherGroup;
        uint64_t         m_OwnGroup;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TriggerResponse
    {
        uint64_t m_OtherId;
        bool     m_Enter;
        uint64_t m_Group;
        uint64_t m_OtherGroup;
        uint64_t m_OwnGroup;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct RequestRayCast
    {
        dmVMath::Point3 m_From;
        dmVMath::Point3 m_To;
        uint32_t        m_Mask;
        uint32_t        m_RequestId;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct RayCastResponse
    {
        float            m_Fraction;
        dmVMath::Point3  m_Position;
        dmVMath::Vector3 m_Normal;
        uint64_t         m_Id;
        uint64_t         m_Group;
        uint32_t         m_RequestId;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct RayCastMissed
    {
        uint32_t m_RequestId;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct RequestVelocity
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct VelocityResponse
    {
        dmVMath::Vector3 m_LinearVelocity;
        dmVMath::Vector3 m_AngularVelocity;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetGridShapeHull
    {
        uint32_t m_Shape;
        uint32_t m_Row;
        uint32_t m_Column;
        uint32_t m_Hull;
        uint32_t m_FlipHorizontal;
        uint32_t m_FlipVertical;
        uint32_t m_Rotate90;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct EnableGridShapeLayer
    {
        uint32_t m_Shape;
        uint32_t m_Enable;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ContactPoint
    {
        dmVMath::Point3  m_Position;
        dmVMath::Point3  m_InstancePosition;
        dmVMath::Vector3 m_Normal;
        dmVMath::Vector3 m_RelativeVelocity;
        float            m_Mass;
        uint64_t         m_Id;
        uint64_t         m_Group;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ContactPointEvent
    {
        dmPhysicsDDF::ContactPoint m_A;
        dmPhysicsDDF::ContactPoint m_B;
        float                      m_Distance;
        float                      m_AppliedImpulse;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Collision
    {
        dmVMath::Point3 m_Position;
        uint64_t        m_Id;
        uint64_t        m_Group;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollisionEvent
    {
        dmPhysicsDDF::Collision m_A;
        dmPhysicsDDF::Collision m_B;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Trigger
    {
        uint64_t m_Id;
        uint64_t m_Group;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TriggerEvent
    {
        bool                  m_Enter;
        dmPhysicsDDF::Trigger m_A;
        dmPhysicsDDF::Trigger m_B;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmPhysicsDDF_CollisionObjectType_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_ConvexShape_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_CollisionShape_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_CollisionShape_Shape_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_CollisionObjectDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_ApplyForce_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_CollisionResponse_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_ContactPointResponse_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_TriggerResponse_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_RequestRayCast_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_RayCastResponse_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_RayCastMissed_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_RequestVelocity_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_VelocityResponse_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_SetGridShapeHull_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_EnableGridShapeLayer_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_ContactPoint_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_ContactPointEvent_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_Collision_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_CollisionEvent_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_Trigger_DESCRIPTOR;
extern dmDDF::Descriptor dmPhysicsDDF_TriggerEvent_DESCRIPTOR;
#endif
#endif // PHYSICS_DDF_H 
