#ifndef shadow_fp
#define shadow_fp

#include "/features/core/materials/includes/float_rgba_utils.glsl"

uniform lowp vec4 shadow_params;//x is texture size y depth_bias
uniform lowp vec4 shadow_color;
uniform highp vec4 sun_position;//sun light position
uniform highp sampler2D SHADOW_TEXTURE;

varying highp vec4 var_texcoord0_shadow;

//mobile
float shadow_calculation(highp vec4 depth_data){
    highp vec2 uv = depth_data.xy;
    // vec4 rgba = texture2D(SHADOW_TEXTURE, uv + rand(uv));
    highp vec4 rgba = texture(SHADOW_TEXTURE, uv);
    float depth = rgba_to_float(rgba);
    //float depth = rgba.x;
    //float shadow = depth_data.z - shadow_params. > depth ? 1.0 : 0.0;
    //float shadow = step(depth,depth_data.z-shadow_params.);
    float shadow = 1.0 - step(depth_data.z-shadow_params.y, depth);

    if (uv.x<0.0 || uv.x>1.0 || uv.y<0.0 || uv.y>1.0) shadow = 0.0;

    return shadow;
}

float shadow_calculation_with_added_normal_bias(highp vec4 depth_data, vec3 normal, vec3 position){
    return shadow_calculation(depth_data);
}


// SUN! DIRECT LIGHT
vec3 direct_light(vec3 light_color, vec3 light_position, vec3 position, vec3 vnormal, vec3 shadow_color){
    vec3 lightDir = normalize(light_position);
    float n = max(dot(vnormal, lightDir), 0.0);
    vec3 diffuse = (light_color - shadow_color) * n;
    return diffuse;
}

// SUN! DIRECT LIGHT with Phong Shading Model
vec3 direct_light_phong(vec4 light_color, vec3 light_position, vec3 position, vec3 normal, vec3 shadow_color, vec3 viewPos, float shininess, float specularStrength) {
    vec3 lightDir = normalize(light_position);
    vec3 viewDir = normalize(viewPos - position);
    vec3 reflectDir = reflect(-lightDir, normal);

    // Diffuse component
    float diff = max(dot(normal, lightDir), 0.0);
    vec3 diffuse = (light_color.rgb - shadow_color) * diff * light_color.w;

    // Specular component
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    vec3 specular = specularStrength * spec * light_color.rgb;

    return diffuse + specular;
}


#endif