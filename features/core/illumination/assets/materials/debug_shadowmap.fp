#version 140

in mediump vec2 texture_coord;

uniform lowp sampler2D DIFFUSE_TEXTURE;

#include "/assets/materials/includes/float_rgba_utils.glsl"

out lowp vec4 out_fragColor;

void main() {
    vec4 rgba = texture(DIFFUSE_TEXTURE, texture_coord.xy);
    float depth = rgba_to_float(rgba);
    out_fragColor = vec4(depth, depth, depth, 1.0);
}
