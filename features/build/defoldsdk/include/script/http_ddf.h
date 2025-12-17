
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

#ifndef HTTP_DDF_H
#define HTTP_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include <dmsdk/dlib/align.h>

namespace dmHttpDDF
{
    struct StopHttp
    {
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct HttpRequest
    {
        const char* m_Method;
        const char* m_Url;
        uint64_t    m_Headers;
        uint64_t    m_HeadersLength;
        uint64_t    m_Request;
        uint32_t    m_RequestLength;
        uint64_t    m_Timeout;
        const char* m_Path;
        bool        m_IgnoreCache;
        bool        m_ChunkedTransfer;
        bool        m_ReportProgress;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct HttpRequestProgress
    {
        uint32_t    m_BytesSent;
        uint32_t    m_BytesReceived;
        uint32_t    m_BytesTotal;
        const char* m_Url;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct HttpResponse
    {
        int32_t     m_Status;
        uint64_t    m_Headers;
        uint32_t    m_HeadersLength;
        uint64_t    m_Response;
        uint32_t    m_ResponseLength;
        const char* m_Path;
        const char* m_Url;
        uint32_t    m_RangeStart;
        uint32_t    m_RangeEnd;
        uint32_t    m_DocumentSize;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::Descriptor dmHttpDDF_StopHttp_DESCRIPTOR;
extern dmDDF::Descriptor dmHttpDDF_HttpRequest_DESCRIPTOR;
extern dmDDF::Descriptor dmHttpDDF_HttpRequestProgress_DESCRIPTOR;
extern dmDDF::Descriptor dmHttpDDF_HttpResponse_DESCRIPTOR;
#endif
#endif // HTTP_DDF_H 
