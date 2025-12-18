#version 140

in mediump vec2 var_texcoord0;
in vec4 var_color;
uniform lowp sampler2D texture_sampler;

out lowp vec4 out_fragColor;

float circle(vec2 uv, vec2 pos, float radius, float feather) {
    vec2 uvDist = uv - pos;
    return 1.0 - smoothstep(radius - feather, radius + feather, length(uvDist));
}

void main() {
    vec3 circleColor = var_color.rgb;
    float alpha = circle(var_texcoord0, vec2(0.5, 0.5), 0.5, 0.0075) * var_color.a;

    out_fragColor = vec4(circleColor * alpha, alpha);
}
