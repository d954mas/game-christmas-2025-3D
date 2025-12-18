#version 140

in mediump vec2 var_texcoord0;   // UV from vertex shader
in lowp vec4 var_color;          // Circle fill color

uniform lowp sampler2D texture_sampler; // Not used, but kept for compatibility

uniform fs_uniforms {
    lowp vec4 border_color;
};

out lowp vec4 out_fragColor;     // Final output color

// Function to create a smooth circular mask
float circle(vec2 uv, vec2 pos, float radius, float feather) {
    vec2 uvDist = uv - pos;
    return 1.0 - smoothstep(radius - feather, radius + feather, length(uvDist));
}

void main() {
    vec3 circleColor = var_color.rgb;
    float alpha = circle(var_texcoord0, vec2(0.5, 0.5), 0.5, 0.0075);

    // Inner circle for border mask
    float border2 = circle(var_texcoord0, vec2(0.5, 0.5), 0.3, 0.0075);

    // Blend fill and border color
    circleColor = circleColor * border2 + border_color.rgb * (1.0 - border2);

    if (alpha < 0.01) {
        discard;
    }

    out_fragColor = vec4(circleColor * alpha, alpha);
}
