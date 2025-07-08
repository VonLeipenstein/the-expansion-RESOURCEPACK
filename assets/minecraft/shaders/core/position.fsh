#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:compare_float.glsl>
#moj_import <minecraft:sun_radius.glsl>
#moj_import <minecraft:dimcheck.glsl>
#moj_import <minecraft:hash.glsl>
#moj_import <minecraft:noise.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;

in mat4 ProjInv;
in float isSky;
in float vertexDistance;

out vec4 fragColor;

#define GRIDOFFSET 0.05
#define GRIDDENSITY 5.0

void main() {
    if (FromExpansion(FogColor)) {
        #moj_import <sky.glsl>
    }
    else {
        fragColor = linear_fog(ColorModulator, vertexDistance, FogStart, FogEnd, FogColor);
    }
}
