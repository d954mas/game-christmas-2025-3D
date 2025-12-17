
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

#ifndef CAMERA_DDF_H
#define CAMERA_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmGamesysDDF
{
    enum OrthoZoomMode
    {
        ORTHO_MODE_FIXED      = 0,
        ORTHO_MODE_AUTO_FIT   = 1,
        ORTHO_MODE_AUTO_COVER = 2,
    };

    struct CameraDesc
    {
        float                       m_AspectRatio;
        float                       m_Fov;
        float                       m_NearZ;
        float                       m_FarZ;
        uint32_t                    m_AutoAspectRatio;
        uint32_t                    m_OrthographicProjection;
        float                       m_OrthographicZoom;
        dmGamesysDDF::OrthoZoomMode m_OrthographicMode;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetCamera
    {
        float                       m_AspectRatio;
        float                       m_Fov;
        float                       m_NearZ;
        float                       m_FarZ;
        uint32_t                    m_OrthographicProjection;
        float                       m_OrthographicZoom;
        dmGamesysDDF::OrthoZoomMode m_OrthographicMode;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct AcquireCameraFocus
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ReleaseCameraFocus
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmGamesysDDF_OrthoZoomMode_DESCRIPTOR;
extern dmDDF::Descriptor dmGamesysDDF_CameraDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGamesysDDF_SetCamera_DESCRIPTOR;
extern dmDDF::Descriptor dmGamesysDDF_AcquireCameraFocus_DESCRIPTOR;
extern dmDDF::Descriptor dmGamesysDDF_ReleaseCameraFocus_DESCRIPTOR;
#endif
#endif // CAMERA_DDF_H 
