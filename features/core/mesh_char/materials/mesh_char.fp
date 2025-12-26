#version 140

// Самплеры (вне uniform-блока)
uniform mediump sampler2D DIFFUSE_TEXTURE;
#include "/features/core/illumination/assets/materials/shadow/shadow_fp_texture.glsl"
#include "/features/core/illumination/assets/materials/light_fp_texture.glsl"

// Входящие varyings
in mediump vec2 var_texcoord0;
in highp vec3 var_world_position;
in mediump vec3 var_world_normal;
in highp vec3 var_camera_position;
in highp vec3 var_view_position;
#include "/features/core/illumination/assets/materials/shadow/shadow_fp_in.glsl"

// Uniform-блок
uniform fs_uniforms {
    lowp vec4 tint;

    // Light uniforms
    #include "/features/core/illumination/assets/materials/light_fp_uniforms.glsl"

    // Shadow-specific constants
    #include "/features/core/illumination/assets/materials/shadow/shadow_fp_uniforms.glsl"
};

// Функции (декод, освещение и тени)
#include "/features/core/illumination/assets/materials/light_fp_functions.glsl"
#include "/features/core/illumination/assets/materials/shadow/shadow_fp_functions.glsl"

// Выходной цвет
out lowp vec4 out_fragColor;

void main() {
    vec4 tint_pm = vec4(tint.rgb * tint.a, tint.a);
    vec4 texture_color = texture(DIFFUSE_TEXTURE, var_texcoord0) * tint_pm;
    vec3 color = texture_color.rgb;

   // vec3 lights_color = vec3(0.0);
    vec3 surface_normal = normalize(var_world_normal);
    vec3 view_direction = normalize(var_camera_position - var_world_position);
    vec3 ambient = ambient_color.rgb * ambient_color.a;

    vec3 lights_color = vec3(0.0) + getData(0).rgb*0.0001;

    float xStride = screen_size.x / clusters_data.x;
    float yStride = screen_size.y / clusters_data.y;
    float zStride = (lights_camera_data.y - lights_camera_data.x) / clusters_data.z;

    int clusterX = int(floor(gl_FragCoord.x / xStride));
    int clusterY = int(floor(gl_FragCoord.y / yStride));
    int clusterZ = int(floor(-var_view_position.z) / zStride);

    int clusterID = clusterX +
                    clusterY * int(clusters_data.x) +
                    clusterZ * int(clusters_data.x) * int(clusters_data.y);

    int cluster_tex_idx = int(lights_data.x) * LIGHT_DATA_PIXELS + clusterID * (1 + int(clusters_data.w));
    int num_lights = int(round(rgba_to_float(getData(cluster_tex_idx)) * (clusters_data.w + 1.0)));

    for (int i = 0; i < 128; ++i) {
        if (i >= num_lights) break;

        int light_tex_idx = cluster_tex_idx + 1 + i;
        int lightIdx = int(round(rgba_to_float(getData(light_tex_idx)) * (lights_data.x + 1.0)));

        int lightIndex = lightIdx * LIGHT_DATA_PIXELS;
        float x = DecodeRGBAToFloatPosition(getData(lightIndex));
        float y = DecodeRGBAToFloatPosition(getData(lightIndex + 1));
        float z = DecodeRGBAToFloatPosition(getData(lightIndex + 2));
        vec4 spotDirectionData = getData(lightIndex + 3);
        vec4 lightColorData = getData(lightIndex + 4);
        vec4 lightData = getData(lightIndex + 5);

        vec3 lightPosition = vec3(x, y, z);
        float lightRadius = round(lightData.x * LIGHT_RADIUS_MAX) + spotDirectionData.w;
        float lightSmoothness = lightData.y;
        float lightSpecular = lightData.z;
        float lightCutoff = lightData.w;

        float lightDistance = length(lightPosition - var_world_position);
        if (lightDistance > lightRadius) continue;

        vec3 lightColor = lightColorData.rgb * lightColorData.a;
        vec3 lightDirection = normalize(lightPosition - var_world_position);

        vec3 lightIlluminanceColor = point_light3(
            lightColor, lightSmoothness, lightDirection,
            lightDistance / lightRadius,
            surface_normal, lightSpecular, view_direction
        );

        lights_color += lightIlluminanceColor;
    }

    // Тень
    float shadow = 0.00001 * shadow_calculation(var_texcoord0_shadow);
    vec3 shadowMod = shadow_color.rgb * shadow_color.a * shadow;

    // Комбинированный результат
    vec3 resultColor = color * ambient;
    resultColor += color * max(
        direct_light(sunlight_color.rgb, sun_position.xyz,
                     var_world_position, surface_normal, shadowMod) * sunlight_color.a,
        0.0
    );
    resultColor += lights_color;

    float view_depth = max(-var_view_position.z, 0.0);
    float fog_start = fog.x;
    float fog_end = fog.y;
    float fog_range = max(fog_end - fog_start, 0.0001);
    float fog_t = clamp((view_depth - fog_start) / fog_range, 0.0, 1.0);
    float fog_factor = smoothstep(0.0, 1.0, fog_t);
    float fog_curve = pow(fog_factor, max(fog.z, 0.0001));
    fog_factor = clamp(fog_curve * fog.w, 0.0, 1.0);

    float fog_dither = fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453);
    fog_factor = clamp(fog_factor + (fog_dither - 0.5) / 32.0, 0.0, 1.0);
    vec3 fog_color_final = fog_color.rgb * fog_color.a;
    resultColor = mix(resultColor, fog_color_final, fog_factor);

    out_fragColor = vec4(resultColor, texture_color.a);
}
