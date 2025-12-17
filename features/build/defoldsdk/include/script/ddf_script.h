
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

#ifndef DDF_SCRIPT_H
#define DDF_SCRIPT_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include <dmsdk/dlib/align.h>

namespace dmScriptDDF
{
    struct LuaRef
    {
        int32_t m_Ref;
        int32_t m_ContextTableRef;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmScriptDDF_LuaRef_DESCRIPTOR;
#endif
#endif // DDF_SCRIPT_H 
