#ifndef shadow_vp_calculation
#define shadow_vp_calculation

var_texcoord0_shadow = mtx_light * vec4(world_position.xyz, 1);

#endif