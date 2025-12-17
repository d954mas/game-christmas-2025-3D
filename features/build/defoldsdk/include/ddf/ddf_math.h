
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

#ifndef DDF_MATH_H
#define DDF_MATH_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include <dmsdk/dlib/align.h>
#include "dmsdk/dlib/vmath.h"
#include "dmsdk/dlib/transform.h"

namespace dmMath
{
    struct Point3
    {
        float m_X;
        float m_Y;
        float m_Z;
        float m_D;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Vector3
    {
        float m_X;
        float m_Y;
        float m_Z;
        float m_D;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Vector3One
    {
        float m_X;
        float m_Y;
        float m_Z;
        float m_D;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Vector4
    {
        float m_X;
        float m_Y;
        float m_Z;
        float m_W;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Vector4One
    {
        float m_X;
        float m_Y;
        float m_Z;
        float m_W;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Vector4WOne
    {
        float m_X;
        float m_Y;
        float m_Z;
        float m_W;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Quat
    {
        float m_X;
        float m_Y;
        float m_Z;
        float m_W;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Transform
    {
        dmVMath::Quat    m_Rotation;
        dmVMath::Vector3 m_Translation;
        dmVMath::Vector3 m_Scale;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Matrix4
    {
        float m_M00;
        float m_M01;
        float m_M02;
        float m_M03;
        float m_M10;
        float m_M11;
        float m_M12;
        float m_M13;
        float m_M20;
        float m_M21;
        float m_M22;
        float m_M23;
        float m_M30;
        float m_M31;
        float m_M32;
        float m_M33;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmMath_Point3_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Vector3_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Vector3One_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Vector4_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Vector4One_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Vector4WOne_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Quat_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Transform_DESCRIPTOR;
extern dmDDF::Descriptor dmMath_Matrix4_DESCRIPTOR;
#endif
#endif // DDF_MATH_H 
