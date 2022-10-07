#version 320 es

//based on https://www.shadertoy.com/view/fsGcWz

precision highp float;

layout(location = 0) uniform float iTime;
layout(location = 1) uniform vec2 iResolution;
layout(location = 0) out vec4 fragColor;

void main() {
    vec2 uv = gl_FragCoord.xy/iResolution.xy;

    float l=iTime;
    vec2 uv2,p=uv;
    uv2=p;
    p-=.5;
    l=length(p);
    uv2+=abs(sin(l*10.-iTime));
    float point=.01/length(mod(uv2,1.)-.5);

    vec3 c=vec3(point);

    fragColor = vec4(c/l,iTime);
}