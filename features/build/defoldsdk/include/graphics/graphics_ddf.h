
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

#ifndef GRAPHICS_DDF_H
#define GRAPHICS_DDF_H

#include <stdint.h>
#include <assert.h>
#include <ddf/ddf.h>
#include "ddf/ddf_math.h"
#include <dmsdk/dlib/align.h>

namespace dmGraphics
{
    enum CoordinateSpace
    {
        COORDINATE_SPACE_DEFAULT = 0,
        COORDINATE_SPACE_WORLD   = 1,
        COORDINATE_SPACE_LOCAL   = 2,
    };

    enum VertexStepFunction
    {
        VERTEX_STEP_FUNCTION_VERTEX   = 0,
        VERTEX_STEP_FUNCTION_INSTANCE = 1,
    };

    enum DepthStencilFormat
    {
        DEPTH_STENCIL_FORMAT_D32F     = 1,
        DEPTH_STENCIL_FORMAT_D32F_S8U = 2,
        DEPTH_STENCIL_FORMAT_D16U_S8U = 3,
        DEPTH_STENCIL_FORMAT_D24U_S8U = 4,
        DEPTH_STENCIL_FORMAT_S8U      = 5,
    };

    enum TextureUsageFlag
    {
        TEXTURE_USAGE_FLAG_SAMPLE     = 1,
        TEXTURE_USAGE_FLAG_MEMORYLESS = 2,
        TEXTURE_USAGE_FLAG_STORAGE    = 4,
        TEXTURE_USAGE_FLAG_INPUT      = 8,
        TEXTURE_USAGE_FLAG_COLOR      = 16,
    };

    struct Cubemap
    {
        const char* m_Right;
        const char* m_Left;
        const char* m_Top;
        const char* m_Bottom;
        const char* m_Front;
        const char* m_Back;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct VertexAttribute
    {
        enum DataType
        {
            TYPE_BYTE           = 1,
            TYPE_UNSIGNED_BYTE  = 2,
            TYPE_SHORT          = 3,
            TYPE_UNSIGNED_SHORT = 4,
            TYPE_INT            = 5,
            TYPE_UNSIGNED_INT   = 6,
            TYPE_FLOAT          = 7,
        };

        enum VectorType
        {
            VECTOR_TYPE_SCALAR = 1,
            VECTOR_TYPE_VEC2   = 2,
            VECTOR_TYPE_VEC3   = 3,
            VECTOR_TYPE_VEC4   = 4,
            VECTOR_TYPE_MAT2   = 5,
            VECTOR_TYPE_MAT3   = 6,
            VECTOR_TYPE_MAT4   = 7,
        };

        enum SemanticType
        {
            SEMANTIC_TYPE_NONE          = 1,
            SEMANTIC_TYPE_POSITION      = 2,
            SEMANTIC_TYPE_TEXCOORD      = 3,
            SEMANTIC_TYPE_PAGE_INDEX    = 4,
            SEMANTIC_TYPE_COLOR         = 5,
            SEMANTIC_TYPE_NORMAL        = 6,
            SEMANTIC_TYPE_TANGENT       = 7,
            SEMANTIC_TYPE_WORLD_MATRIX  = 8,
            SEMANTIC_TYPE_NORMAL_MATRIX = 9,
            SEMANTIC_TYPE_BONE_WEIGHTS  = 10,
            SEMANTIC_TYPE_BONE_INDICES  = 11,
        };

        struct LongValues
        {
            struct
            {
                int64_t* m_Data;
                const int64_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                int64_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_V;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct DoubleValues
        {
            struct
            {
                double* m_Data;
                const double& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                double& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_V;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        const char*                               m_Name;
        uint64_t                                  m_NameHash;
        dmGraphics::VertexAttribute::SemanticType m_SemanticType;
        int32_t                                   m_ElementCount;
        bool                                      m_Normalize;
        dmGraphics::VertexAttribute::DataType     m_DataType;
        dmGraphics::CoordinateSpace               m_CoordinateSpace;
        dmGraphics::VertexStepFunction            m_StepFunction;
        dmGraphics::VertexAttribute::VectorType   m_VectorType;
        union
        {
            dmGraphics::VertexAttribute::LongValues   m_LongValues;
            dmGraphics::VertexAttribute::DoubleValues m_DoubleValues;
            struct
            {
                uint8_t* m_Data;
                const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_BinaryValues;

        } m_Values;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TextureImage
    {
        enum Type
        {
            TYPE_2D       = 1,
            TYPE_CUBEMAP  = 2,
            TYPE_2D_ARRAY = 3,
            TYPE_2D_IMAGE = 4,
            TYPE_3D       = 5,
            TYPE_3D_IMAGE = 6,
        };

        enum CompressionType
        {
            COMPRESSION_TYPE_DEFAULT     = 0,
            COMPRESSION_TYPE_WEBP        = 1,
            COMPRESSION_TYPE_WEBP_LOSSY  = 2,
            COMPRESSION_TYPE_BASIS_UASTC = 3,
            COMPRESSION_TYPE_BASIS_ETC1S = 4,
            COMPRESSION_TYPE_ASTC        = 5,
        };

        enum CompressionFlags
        {
            COMPRESSION_FLAG_ALPHA_CLEAN = 1,
        };

        enum TextureFormat
        {
            TEXTURE_FORMAT_LUMINANCE         = 0,
            TEXTURE_FORMAT_RGB               = 1,
            TEXTURE_FORMAT_RGBA              = 2,
            TEXTURE_FORMAT_RGB_PVRTC_2BPPV1  = 3,
            TEXTURE_FORMAT_RGB_PVRTC_4BPPV1  = 4,
            TEXTURE_FORMAT_RGBA_PVRTC_2BPPV1 = 5,
            TEXTURE_FORMAT_RGBA_PVRTC_4BPPV1 = 6,
            TEXTURE_FORMAT_RGB_ETC1          = 7,
            TEXTURE_FORMAT_RGB_16BPP         = 8,
            TEXTURE_FORMAT_RGBA_16BPP        = 9,
            TEXTURE_FORMAT_LUMINANCE_ALPHA   = 10,
            TEXTURE_FORMAT_RGBA_ETC2         = 11,
            TEXTURE_FORMAT_RGBA_ASTC_4X4     = 12,
            TEXTURE_FORMAT_RGBA_ASTC_4x4     = 12,
            TEXTURE_FORMAT_RGB_BC1           = 13,
            TEXTURE_FORMAT_RGBA_BC3          = 14,
            TEXTURE_FORMAT_R_BC4             = 15,
            TEXTURE_FORMAT_RG_BC5            = 16,
            TEXTURE_FORMAT_RGBA_BC7          = 17,
            TEXTURE_FORMAT_RGB16F            = 18,
            TEXTURE_FORMAT_RGB32F            = 19,
            TEXTURE_FORMAT_RGBA16F           = 20,
            TEXTURE_FORMAT_RGBA32F           = 21,
            TEXTURE_FORMAT_R16F              = 22,
            TEXTURE_FORMAT_RG16F             = 23,
            TEXTURE_FORMAT_R32F              = 24,
            TEXTURE_FORMAT_RG32F             = 25,
            TEXTURE_FORMAT_RGBA_ASTC_5X4     = 26,
            TEXTURE_FORMAT_RGBA_ASTC_5X5     = 27,
            TEXTURE_FORMAT_RGBA_ASTC_6X5     = 28,
            TEXTURE_FORMAT_RGBA_ASTC_6X6     = 29,
            TEXTURE_FORMAT_RGBA_ASTC_8X5     = 30,
            TEXTURE_FORMAT_RGBA_ASTC_8X6     = 31,
            TEXTURE_FORMAT_RGBA_ASTC_8X8     = 32,
            TEXTURE_FORMAT_RGBA_ASTC_10X5    = 33,
            TEXTURE_FORMAT_RGBA_ASTC_10X6    = 34,
            TEXTURE_FORMAT_RGBA_ASTC_10X8    = 35,
            TEXTURE_FORMAT_RGBA_ASTC_10X10   = 36,
            TEXTURE_FORMAT_RGBA_ASTC_12X10   = 37,
            TEXTURE_FORMAT_RGBA_ASTC_12X12   = 38,
        };

        struct Image
        {
            uint32_t                                  m_Width;
            uint32_t                                  m_Height;
            uint32_t                                  m_Depth;
            uint32_t                                  m_OriginalWidth;
            uint32_t                                  m_OriginalHeight;
            uint32_t                                  m_OriginalDepth;
            dmGraphics::TextureImage::TextureFormat   m_Format;
            struct
            {
                uint32_t* m_Data;
                const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_MipMapOffset;

            struct
            {
                uint32_t* m_Data;
                const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_MipMapSize;

            dmGraphics::TextureImage::CompressionType m_CompressionType;
            struct
            {
                uint32_t* m_Data;
                const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_MipMapSizeCompressed;

            struct
            {
                uint32_t* m_Data;
                const uint32_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                uint32_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_MipMapDimensions;

            uint32_t                                  m_DataSize;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct
        {
            dmGraphics::TextureImage::Image* m_Data;
            const dmGraphics::TextureImage::Image& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::TextureImage::Image& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Alternatives;

        dmGraphics::TextureImage::Type m_Type;
        uint32_t                       m_Count;
        uint32_t                       m_UsageFlags;
        uint64_t                       m_ImageDataAddress;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TextureFormatAlternative
    {
        enum CompressionLevel
        {
            FAST   = 0,
            NORMAL = 1,
            HIGH   = 2,
            BEST   = 3,
        };

        dmGraphics::TextureImage::TextureFormat                m_Format;
        dmGraphics::TextureFormatAlternative::CompressionLevel m_CompressionLevel;
        dmGraphics::TextureImage::CompressionType              m_CompressionType;
        const char*                                            m_Compressor;
        const char*                                            m_CompressorPreset;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PathSettings
    {
        const char* m_Path;
        const char* m_Profile;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct PlatformProfile
    {
        enum OS
        {
            OS_ID_GENERIC = 0,
            OS_ID_WINDOWS = 1,
            OS_ID_OSX     = 2,
            OS_ID_LINUX   = 3,
            OS_ID_IOS     = 4,
            OS_ID_ANDROID = 5,
            OS_ID_WEB     = 6,
            OS_ID_SWITCH  = 7,
            OS_ID_PS4     = 8,
            OS_ID_PS5     = 9,
            OS_ID_XBOX    = 10,
        };

        dmGraphics::PlatformProfile::OS m_Os;
        struct
        {
            dmGraphics::TextureFormatAlternative* m_Data;
            const dmGraphics::TextureFormatAlternative& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::TextureFormatAlternative& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Formats;

        bool                            m_Mipmaps;
        uint32_t                        m_MaxTextureSize;
        bool                            m_PremultiplyAlpha;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TextureProfile
    {
        const char* m_Name;
        struct
        {
            dmGraphics::PlatformProfile* m_Data;
            const dmGraphics::PlatformProfile& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::PlatformProfile& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Platforms;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct TextureProfiles
    {
        struct
        {
            dmGraphics::PathSettings* m_Data;
            const dmGraphics::PathSettings& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::PathSettings& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_PathSettings;

        struct
        {
            dmGraphics::TextureProfile* m_Data;
            const dmGraphics::TextureProfile& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::TextureProfile& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Profiles;

        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

    struct ShaderDesc
    {
        enum Language
        {
            LANGUAGE_GLSL_SM120 = 1,
            LANGUAGE_GLES_SM100 = 2,
            LANGUAGE_GLES_SM300 = 3,
            LANGUAGE_SPIRV      = 4,
            LANGUAGE_PSSL       = 5,
            LANGUAGE_GLSL_SM430 = 6,
            LANGUAGE_GLSL_SM330 = 7,
            LANGUAGE_WGSL       = 8,
            LANGUAGE_HLSL_50    = 9,
            LANGUAGE_HLSL_51    = 10,
        };

        enum ShaderType
        {
            SHADER_TYPE_VERTEX   = 0,
            SHADER_TYPE_FRAGMENT = 1,
            SHADER_TYPE_COMPUTE  = 2,
        };

        enum ShaderDataType
        {
            SHADER_TYPE_UNKNOWN           = 0,
            SHADER_TYPE_INT               = 1,
            SHADER_TYPE_UINT              = 2,
            SHADER_TYPE_FLOAT             = 3,
            SHADER_TYPE_VEC2              = 4,
            SHADER_TYPE_VEC3              = 5,
            SHADER_TYPE_VEC4              = 6,
            SHADER_TYPE_MAT2              = 7,
            SHADER_TYPE_MAT3              = 8,
            SHADER_TYPE_MAT4              = 9,
            SHADER_TYPE_SAMPLER2D         = 10,
            SHADER_TYPE_SAMPLER3D         = 11,
            SHADER_TYPE_SAMPLER_CUBE      = 12,
            SHADER_TYPE_SAMPLER2D_ARRAY   = 13,
            SHADER_TYPE_UNIFORM_BUFFER    = 14,
            SHADER_TYPE_UVEC2             = 15,
            SHADER_TYPE_UVEC3             = 16,
            SHADER_TYPE_UVEC4             = 17,
            SHADER_TYPE_TEXTURE2D         = 18,
            SHADER_TYPE_UTEXTURE2D        = 19,
            SHADER_TYPE_RENDER_PASS_INPUT = 20,
            SHADER_TYPE_UIMAGE2D          = 21,
            SHADER_TYPE_IMAGE2D           = 22,
            SHADER_TYPE_SAMPLER           = 23,
            SHADER_TYPE_STORAGE_BUFFER    = 24,
            SHADER_TYPE_TEXTURE2D_ARRAY   = 25,
            SHADER_TYPE_TEXTURE_CUBE      = 26,
            SHADER_TYPE_TEXTURE3D         = 27,
            SHADER_TYPE_UTEXTURE3D        = 28,
            SHADER_TYPE_UIMAGE3D          = 29,
            SHADER_TYPE_IMAGE3D           = 30,
            SHADER_TYPE_SAMPLER3D_ARRAY   = 31,
            SHADER_TYPE_TEXTURE3D_ARRAY   = 32,
        };

        struct ResourceType
        {
            union
            {
                dmGraphics::ShaderDesc::ShaderDataType m_ShaderType;
                int32_t                                m_TypeIndex;
            } m_Type;

            bool                                   m_UseTypeIndex;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct ResourceMember
        {
            const char*                          m_Name;
            uint64_t                             m_NameHash;
            dmGraphics::ShaderDesc::ResourceType m_Type;
            uint32_t                             m_ElementCount;
            uint32_t                             m_Offset;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct ResourceTypeInfo
        {
            const char* m_Name;
            uint64_t    m_NameHash;
            struct
            {
                dmGraphics::ShaderDesc::ResourceMember* m_Data;
                const dmGraphics::ShaderDesc::ResourceMember& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::ResourceMember& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Members;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct ResourceBinding
        {
            const char*                          m_Name;
            uint64_t                             m_NameHash;
            dmGraphics::ShaderDesc::ResourceType m_Type;
            uint32_t                             m_Id;
            const char*                          m_InstanceName;
            uint64_t                             m_InstanceNameHash;
            uint32_t                             m_Set;
            uint32_t                             m_Binding;
            uint32_t                             m_ElementCount;
            uint32_t                             m_StageFlags;
            union
            {
                uint32_t                             m_BlockSize;
                uint32_t                             m_SamplerTextureIndex;
            } m_Bindinginfo;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct ShaderReflection
        {
            struct
            {
                dmGraphics::ShaderDesc::ResourceBinding* m_Data;
                const dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_UniformBuffers;

            struct
            {
                dmGraphics::ShaderDesc::ResourceBinding* m_Data;
                const dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_StorageBuffers;

            struct
            {
                dmGraphics::ShaderDesc::ResourceBinding* m_Data;
                const dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Textures;

            struct
            {
                dmGraphics::ShaderDesc::ResourceBinding* m_Data;
                const dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Inputs;

            struct
            {
                dmGraphics::ShaderDesc::ResourceBinding* m_Data;
                const dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::ResourceBinding& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Outputs;

            struct
            {
                dmGraphics::ShaderDesc::ResourceTypeInfo* m_Data;
                const dmGraphics::ShaderDesc::ResourceTypeInfo& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::ResourceTypeInfo& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Types;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct HLSLResourceMapping
        {
            uint64_t m_NameHash;
            uint32_t m_Binding;
            uint32_t m_Set;
            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct Shader
        {
            struct
            {
                uint8_t* m_Data;
                const uint8_t& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                uint8_t& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_Source;

            dmGraphics::ShaderDesc::ShaderType m_ShaderType;
            dmGraphics::ShaderDesc::Language   m_Language;
            bool                               m_VariantTextureArray;
            struct
            {
                dmGraphics::ShaderDesc::HLSLResourceMapping* m_Data;
                const dmGraphics::ShaderDesc::HLSLResourceMapping& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
                dmGraphics::ShaderDesc::HLSLResourceMapping& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
                uint32_t m_Count;
            } m_HlslResourceMapping;

            
            static dmDDF::Descriptor* m_DDFDescriptor;
            static const uint64_t m_DDFHash;
        };

        struct
        {
            dmGraphics::ShaderDesc::Shader* m_Data;
            const dmGraphics::ShaderDesc::Shader& operator[](uint32_t i) const { assert(i < m_Count); return m_Data[i]; }
            dmGraphics::ShaderDesc::Shader& operator[](uint32_t i) { assert(i < m_Count); return m_Data[i]; }
            uint32_t m_Count;
        } m_Shaders;

        dmGraphics::ShaderDesc::ShaderReflection m_Reflection;
        
        static dmDDF::Descriptor* m_DDFDescriptor;
        static const uint64_t m_DDFHash;
    };

};

#ifdef DDF_EXPOSE_DESCRIPTORS
extern dmDDF::EnumDescriptor dmGraphics_CoordinateSpace_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmGraphics_VertexStepFunction_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmGraphics_DepthStencilFormat_DESCRIPTOR;
extern dmDDF::EnumDescriptor dmGraphics_TextureUsageFlag_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_Cubemap_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_VertexAttribute_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_VertexAttribute_LongValues_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_VertexAttribute_DoubleValues_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_TextureImage_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_TextureImage_Image_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_TextureFormatAlternative_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_PathSettings_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_PlatformProfile_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_TextureProfile_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_TextureProfiles_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_ResourceType_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_ResourceMember_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_ResourceTypeInfo_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_ResourceBinding_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_ShaderReflection_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_HLSLResourceMapping_DESCRIPTOR;
extern dmDDF::Descriptor dmGraphics_ShaderDesc_Shader_DESCRIPTOR;
#endif
#endif // GRAPHICS_DDF_H 
