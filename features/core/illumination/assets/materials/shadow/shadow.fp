#version 140

#include "/features/core/materials/includes/float_rgba_utils.glsl"

out lowp vec4 out_fragColor;

void main() {
    out_fragColor = float_to_rgba(gl_FragCoord.z);
}
