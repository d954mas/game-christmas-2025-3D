
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

#ifndef SOUND_DDF_H
#define SOUND_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmSoundDDF
{
    struct SoundDesc
    {
        const char* m_Sound;
        int32_t     m_Looping;
        const char* m_Group;
        float       m_Gain;
        float       m_Pan;
        float       m_Speed;
        int32_t     m_Loopcount;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmSoundDDF_SoundDesc_DESCRIPTOR;
#endif
#endif // SOUND_DDF_H 
