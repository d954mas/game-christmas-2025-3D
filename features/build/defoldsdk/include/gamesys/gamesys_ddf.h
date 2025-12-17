
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

#ifndef GAMESYS_DDF_H
#define GAMESYS_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmGameSystemDDF
{
    enum TimeStepMode
    {
        TIME_STEP_MODE_CONTINUOUS = 0,
        TIME_STEP_MODE_DISCRETE   = 1,
    };

    enum LightType
    {
        POINT = 0,
        SPOT  = 1,
    };

    struct FactoryDesc
    {
        const char* m_Prototype;
        bool        m_LoadDynamically;
        bool        m_DynamicPrototype;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollectionFactoryDesc
    {
        const char* m_Prototype;
        bool        m_LoadDynamically;
        bool        m_DynamicPrototype;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Create
    {
        DM_ALIGNED(16) dmVMath::Point3  m_Position;
        DM_ALIGNED(16) dmVMath::Quat    m_Rotation;
        uint64_t                        m_Id;
        float                           m_Scale;
        DM_ALIGNED(16) dmVMath::Vector3 m_Scale3;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct CollectionProxyDesc
    {
        const char* m_Collection;
        bool        m_Exclude;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetTimeStep
    {
        float                         m_Factor;
        dmGameSystemDDF::TimeStepMode m_Mode;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct LightDesc
    {
        const char*                m_Id;
        dmGameSystemDDF::LightType m_Type;
        float                      m_Intensity;
        dmVMath::Vector3           m_Color;
        float                      m_Range;
        float                      m_Decay;
        float                      m_ConeAngle;
        float                      m_PenumbraAngle;
        float                      m_DropOff;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetLight
    {
        dmVMath::Point3            m_Position;
        dmVMath::Quat              m_Rotation;
        dmGameSystemDDF::LightDesc m_Light;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetViewProjection
    {
        uint64_t         m_Id;
        dmVMath::Matrix4 m_View;
        dmVMath::Matrix4 m_Projection;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PlaySound
    {
        float    m_Delay;
        float    m_Gain;
        float    m_Pan;
        float    m_Speed;
        uint32_t m_PlayId;
        float    m_StartTime;
        uint32_t m_StartFrame;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct StopSound
    {
        uint32_t m_PlayId;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PauseSound
    {
        bool m_Pause;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SoundEvent
    {
        int32_t m_PlayId;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetGain
    {
        float m_Gain;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetPan
    {
        float m_Pan;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetSpeed
    {
        float m_Speed;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PlayParticleFX
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct StopParticleFX
    {
        bool m_ClearParticles;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetConstantParticleFX
    {
        uint64_t                        m_EmitterId;
        uint64_t                        m_NameHash;
        DM_ALIGNED(16) dmVMath::Matrix4 m_Value;
        bool                            m_IsMatrix4;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ResetConstantParticleFX
    {
        uint64_t m_EmitterId;
        uint64_t m_NameHash;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetConstant
    {
        uint64_t                        m_NameHash;
        DM_ALIGNED(16) dmVMath::Vector4 m_Value;
        int32_t                         m_Index;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ResetConstant
    {
        uint64_t m_NameHash;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetScale
    {
        DM_ALIGNED(16) dmVMath::Vector3 m_Scale;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmGameSystemDDF_TimeStepMode_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmGameSystemDDF_LightType_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_FactoryDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_CollectionFactoryDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_Create_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_CollectionProxyDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetTimeStep_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_LightDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetLight_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetViewProjection_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_PlaySound_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_StopSound_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_PauseSound_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SoundEvent_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetGain_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetPan_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetSpeed_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_PlayParticleFX_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_StopParticleFX_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetConstantParticleFX_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_ResetConstantParticleFX_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetConstant_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_ResetConstant_DESCRIPTOR;
extern dmDDF::Descriptor dmGameSystemDDF_SetScale_DESCRIPTOR;
#endif
#endif // GAMESYS_DDF_H 
