
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

#ifndef LIVEUPDATE_DDF_H
#define LIVEUPDATE_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmLiveUpdateDDF
{
    enum HashAlgorithm
    {
        HASH_UNKNOWN = 0,
        HASH_MD5     = 1,
        HASH_SHA1    = 2,
        HASH_SHA256  = 3,
        HASH_SHA512  = 4,
    };

    enum SignAlgorithm
    {
        SIGN_UNKNOWN = 0,
        SIGN_RSA     = 1,
    };

    enum ResourceEntryFlag
    {
        BUNDLED    = 1,
        EXCLUDED   = 2,
        ENCRYPTED  = 4,
        COMPRESSED = 8,
    };

    struct HashDigest
    {
        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Data;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ManifestHeader
    {
        dmLiveUpdateDDF::HashAlgorithm m_ResourceHashAlgorithm;
        dmLiveUpdateDDF::HashAlgorithm m_SignatureHashAlgorithm;
        dmLiveUpdateDDF::SignAlgorithm m_SignatureSignAlgorithm;
        dmLiveUpdateDDF::HashDigest    m_ProjectIdentifier;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ResourceEntry
    {
        dmLiveUpdateDDF::HashDigest m_Hash;
        const char*                 m_Url;
        uint64_t                    m_UrlHash;
        uint32_t                    m_Size;
        uint32_t                    m_CompressedSize;
        uint32_t                    m_Flags;
        struct
        {
            uint64_t* m_Data;
            const uint64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Dependants;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ManifestData
    {
        dmLiveUpdateDDF::ManifestHeader m_Header;
        struct
        {
            dmLiveUpdateDDF::HashDigest* m_Data;
            const dmLiveUpdateDDF::HashDigest& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmLiveUpdateDDF::HashDigest& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_EngineVersions;

        struct
        {
            dmLiveUpdateDDF::ResourceEntry* m_Data;
            const dmLiveUpdateDDF::ResourceEntry& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmLiveUpdateDDF::ResourceEntry& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Resources;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ManifestFile
    {
        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Data;

        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Signature;

        struct
        {
            uint8_t* m_Data;
            const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_ArchiveIdentifier;

        uint32_t m_Version;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmLiveUpdateDDF_HashAlgorithm_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmLiveUpdateDDF_SignAlgorithm_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmLiveUpdateDDF_ResourceEntryFlag_DESCRIPTOR;
extern dmDDF::Descriptor dmLiveUpdateDDF_HashDigest_DESCRIPTOR;
extern dmDDF::Descriptor dmLiveUpdateDDF_ManifestHeader_DESCRIPTOR;
extern dmDDF::Descriptor dmLiveUpdateDDF_ResourceEntry_DESCRIPTOR;
extern dmDDF::Descriptor dmLiveUpdateDDF_ManifestData_DESCRIPTOR;
extern dmDDF::Descriptor dmLiveUpdateDDF_ManifestFile_DESCRIPTOR;
#endif
#endif // LIVEUPDATE_DDF_H 
