#version 140

in mediump vec2 texture_coord;

uniform lowp sampler2D DIFFUSE_TEXTURE;

out lowp vec4 out_fragColor;

void main() {
    vec4 color = texture(DIFFUSE_TEXTURE, texture_coord.xy);
    out_fragColor = vec4(color.rgb, 1.0);
}
