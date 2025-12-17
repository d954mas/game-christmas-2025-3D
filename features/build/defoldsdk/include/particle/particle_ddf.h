
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

#ifndef PARTICLE_DDF_H
#define PARTICLE_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include "graphics/graphics_ddf.h"
#include <dmsdk/dlib/align.h>

namespace dmParticleDDF
{
    enum EmitterType
    {
        EMITTER_TYPE_CIRCLE = 0,
        EMITTER_TYPE_2DCONE = 1,
        EMITTER_TYPE_BOX    = 2,
        EMITTER_TYPE_SPHERE = 3,
        EMITTER_TYPE_CONE   = 4,
    };

    enum PlayMode
    {
        PLAY_MODE_ONCE = 0,
        PLAY_MODE_LOOP = 1,
    };

    enum EmissionSpace
    {
        EMISSION_SPACE_WORLD   = 0,
        EMISSION_SPACE_EMITTER = 1,
    };

    enum EmitterKey
    {
        EMITTER_KEY_SPAWN_RATE                = 0,
        EMITTER_KEY_SIZE_X                    = 1,
        EMITTER_KEY_SIZE_Y                    = 2,
        EMITTER_KEY_SIZE_Z                    = 3,
        EMITTER_KEY_PARTICLE_LIFE_TIME        = 4,
        EMITTER_KEY_PARTICLE_SPEED            = 5,
        EMITTER_KEY_PARTICLE_SIZE             = 6,
        EMITTER_KEY_PARTICLE_RED              = 7,
        EMITTER_KEY_PARTICLE_GREEN            = 8,
        EMITTER_KEY_PARTICLE_BLUE             = 9,
        EMITTER_KEY_PARTICLE_ALPHA            = 10,
        EMITTER_KEY_PARTICLE_ROTATION         = 11,
        EMITTER_KEY_PARTICLE_STRETCH_FACTOR_X = 12,
        EMITTER_KEY_PARTICLE_STRETCH_FACTOR_Y = 13,
        EMITTER_KEY_PARTICLE_ANGULAR_VELOCITY = 14,
        EMITTER_KEY_COUNT                     = 15,
    };

    enum ParticleKey
    {
        PARTICLE_KEY_SCALE            = 0,
        PARTICLE_KEY_RED              = 1,
        PARTICLE_KEY_GREEN            = 2,
        PARTICLE_KEY_BLUE             = 3,
        PARTICLE_KEY_ALPHA            = 4,
        PARTICLE_KEY_ROTATION         = 5,
        PARTICLE_KEY_STRETCH_FACTOR_X = 6,
        PARTICLE_KEY_STRETCH_FACTOR_Y = 7,
        PARTICLE_KEY_ANGULAR_VELOCITY = 8,
        PARTICLE_KEY_COUNT            = 9,
    };

    enum ModifierType
    {
        MODIFIER_TYPE_ACCELERATION = 0,
        MODIFIER_TYPE_DRAG         = 1,
        MODIFIER_TYPE_RADIAL       = 2,
        MODIFIER_TYPE_VORTEX       = 3,
    };

    enum ModifierKey
    {
        MODIFIER_KEY_MAGNITUDE    = 0,
        MODIFIER_KEY_MAX_DISTANCE = 1,
        MODIFIER_KEY_COUNT        = 2,
    };

    enum BlendMode
    {
        BLEND_MODE_ALPHA     = 0,
        BLEND_MODE_ADD       = 1,
        BLEND_MODE_ADD_ALPHA = 2,
        BLEND_MODE_MULT      = 3,
        BLEND_MODE_SCREEN    = 4,
    };

    enum SizeMode
    {
        SIZE_MODE_MANUAL = 0,
        SIZE_MODE_AUTO   = 1,
    };

    enum ParticleOrientation
    {
        PARTICLE_ORIENTATION_DEFAULT            = 0,
        PARTICLE_ORIENTATION_INITIAL_DIRECTION  = 1,
        PARTICLE_ORIENTATION_MOVEMENT_DIRECTION = 2,
        PARTICLE_ORIENTATION_ANGULAR_VELOCITY   = 3,
    };

    struct SplinePoint
    {
        float m_X;
        float m_Y;
        float m_TX;
        float m_TY;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Modifier
    {
        struct Property
        {
            dmParticleDDF::ModifierKey m_Key;
            struct
            {
                dmParticleDDF::SplinePoint* m_Data;
                const dmParticleDDF::SplinePoint& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmParticleDDF::SplinePoint& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Points;

            float                      m_Spread;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        dmParticleDDF::ModifierType m_Type;
        uint32_t                    m_UseDirection;
        dmVMath::Point3             m_Position;
        dmVMath::Quat               m_Rotation;
        struct
        {
            dmParticleDDF::Modifier::Property* m_Data;
            const dmParticleDDF::Modifier::Property& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmParticleDDF::Modifier::Property& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Properties;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Emitter
    {
        struct Property
        {
            dmParticleDDF::EmitterKey m_Key;
            struct
            {
                dmParticleDDF::SplinePoint* m_Data;
                const dmParticleDDF::SplinePoint& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmParticleDDF::SplinePoint& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Points;

            float                     m_Spread;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct ParticleProperty
        {
            dmParticleDDF::ParticleKey m_Key;
            struct
            {
                dmParticleDDF::SplinePoint* m_Data;
                const dmParticleDDF::SplinePoint& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmParticleDDF::SplinePoint& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Points;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        const char*                        m_Id;
        dmParticleDDF::PlayMode            m_Mode;
        float                              m_Duration;
        dmParticleDDF::EmissionSpace       m_Space;
        dmVMath::Point3                    m_Position;
        dmVMath::Quat                      m_Rotation;
        const char*                        m_TileSource;
        const char*                        m_Animation;
        const char*                        m_Material;
        dmParticleDDF::BlendMode           m_BlendMode;
        dmParticleDDF::ParticleOrientation m_ParticleOrientation;
        float                              m_InheritVelocity;
        uint32_t                           m_MaxParticleCount;
        dmParticleDDF::EmitterType         m_Type;
        float                              m_StartDelay;
        struct
        {
            dmParticleDDF::Emitter::Property* m_Data;
            const dmParticleDDF::Emitter::Property& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmParticleDDF::Emitter::Property& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Properties;

        struct
        {
            dmParticleDDF::Emitter::ParticleProperty* m_Data;
            const dmParticleDDF::Emitter::ParticleProperty& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmParticleDDF::Emitter::ParticleProperty& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ParticleProperties;

        struct
        {
            dmParticleDDF::Modifier* m_Data;
            const dmParticleDDF::Modifier& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmParticleDDF::Modifier& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Modifiers;

        dmParticleDDF::SizeMode            m_SizeMode;
        float                              m_StartDelaySpread;
        float                              m_DurationSpread;
        bool                               m_StretchWithVelocity;
        float                              m_StartOffset;
        dmVMath::Point3                    m_Pivot;
        struct
        {
            dmGraphics::VertexAttribute* m_Data;
            const dmGraphics::VertexAttribute& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::VertexAttribute& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Attributes;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ParticleFX
    {
        struct
        {
            dmParticleDDF::Emitter* m_Data;
            const dmParticleDDF::Emitter& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmParticleDDF::Emitter& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Emitters;

        struct
        {
            dmParticleDDF::Modifier* m_Data;
            const dmParticleDDF::Modifier& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmParticleDDF::Modifier& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Modifiers;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmParticleDDF_EmitterType_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_PlayMode_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_EmissionSpace_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_EmitterKey_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_ParticleKey_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_ModifierType_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_ModifierKey_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_BlendMode_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_SizeMode_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmParticleDDF_ParticleOrientation_DESCRIPTOR;
extern dmDDF::Descriptor dmParticleDDF_SplinePoint_DESCRIPTOR;
extern dmDDF::Descriptor dmParticleDDF_Modifier_DESCRIPTOR;
extern dmDDF::Descriptor dmParticleDDF_Modifier_Property_DESCRIPTOR;
extern dmDDF::Descriptor dmParticleDDF_Emitter_DESCRIPTOR;
extern dmDDF::Descriptor dmParticleDDF_Emitter_Property_DESCRIPTOR;
extern dmDDF::Descriptor dmParticleDDF_Emitter_ParticleProperty_DESCRIPTOR;
extern dmDDF::Descriptor dmParticleDDF_ParticleFX_DESCRIPTOR;
#endif
#endif // PARTICLE_DDF_H 
