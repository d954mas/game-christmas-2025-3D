#ifndef LIGHT_FP_UNIFORMS
#define LIGHT_FP_UNIFORMS

lowp vec4 ambient_color;
lowp vec4 sunlight_color;
lowp vec4 fog_color;
highp vec4 fog;

highp vec4 light_texture_data;
highp vec4 lights_data;
highp vec4 lights_camera_data;
highp vec4 clusters_data;
highp vec4 screen_size;

#endif // LIGHT_FP_UNIFORMS