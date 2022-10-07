#version 320 es

precision highp float;

layout(location = 0) uniform float iTime;
layout(location = 1) uniform vec2 iResolution;
layout(location = 0) out vec4 fragColor;

void main()
{
 vec2 uv = gl_FragCoord.xy/iResolution;
 float t = 4.0 * iTime;
 vec3 col = 0.5 + 0.5*cos(t + uv.xyx + vec3(0,1,4));
 fragColor = vec4(col,1.0);
}
