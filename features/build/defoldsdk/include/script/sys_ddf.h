
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

#ifndef SYS_DDF_H
#define SYS_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmSystemDDF
{
    struct Exit
    {
        int32_t m_Code;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ToggleProfile
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TogglePhysicsDebug
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct StartRecord
    {
        const char* m_FileName;
        int32_t     m_FramePeriod;
        int32_t     m_Fps;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct StopRecord
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct Reboot
    {
        const char* m_Arg1;
        const char* m_Arg2;
        const char* m_Arg3;
        const char* m_Arg4;
        const char* m_Arg5;
        const char* m_Arg6;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetVsync
    {
        int32_t m_SwapInterval;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct SetUpdateFrequency
    {
        int32_t m_Frequency;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ResumeRendering
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmSystemDDF_Exit_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_ToggleProfile_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_TogglePhysicsDebug_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_StartRecord_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_StopRecord_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_Reboot_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_SetVsync_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_SetUpdateFrequency_DESCRIPTOR;
extern dmDDF::Descriptor dmSystemDDF_ResumeRendering_DESCRIPTOR;
#endif
#endif // SYS_DDF_H 
