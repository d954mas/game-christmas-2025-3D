#version 140

in mediump vec2 var_texcoord0;
in lowp vec4 var_color;

uniform lowp sampler2D texture_sampler;

out lowp vec4 out_fragColor;

void main()
{
    lowp vec4 tex = texture(texture_sampler, var_texcoord0.xy);
    if (tex.a < 0.01) {
        discard;
    }
    out_fragColor = tex * var_color;
}
