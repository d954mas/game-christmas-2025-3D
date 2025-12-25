#ifndef LIGHT_FP_FUNCTIONS
#define LIGHT_FP_FUNCTIONS

#define LIGHT_DATA_PIXELS 6
#define LIGHT_RADIUS_MAX 63.0

#if __VERSION__ < 300
float customRound(float x) {
    return floor(x + 0.5);
}
#define round(x) customRound(x)
#endif

highp vec4 getData(highp int index) {
    int x = index % int(light_texture_data.x);
    int y = index / int(light_texture_data.x);
    vec2 uv = (vec2(x, y) + 0.5) / light_texture_data.xy;
    return texture(DATA_TEXTURE, uv);
}

highp float DecodeRGBAToFloatPosition(highp vec4 encoded) {
    encoded.rgb *= 63.0;
    highp float intPart = round(encoded.r) * 64.0 * 64.0 + round(encoded.g) * 64.0 + round(encoded.b);
    highp float fracPart = encoded.a;
    return intPart - 131072.0 + fracPart;
}

const float phong_shininess = 16.0;

vec3 point_light3(vec3 light_color, float power, vec3 direction, float d, vec3 vnormal, float specular, vec3 view_dir) {
    vec3 reflect_dir = reflect(-direction, vnormal);
    float spec_dot = max(dot(reflect_dir, view_dir), 0.0);
    float irradiance = max(dot(vnormal, direction), 0.05);
   float light_attenuation = pow(clamp(1.0 - d, 0.0, 1.0), 2.0 * power);
    float attenuation = light_attenuation;//1.0 / (1.0 + d * power + 2.0 * d * d * power * power);
    vec3 diffuse = light_color * irradiance * attenuation;
    diffuse += irradiance * attenuation * specular * pow(spec_dot, phong_shininess) * light_color;
    return diffuse;
}

#endif // LIGHT_FP_FUNCTIONS
