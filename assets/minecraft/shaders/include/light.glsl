#version 150

#moj_import <compare_float.glsl>

#define MINECRAFT_LIGHT_POWER   (0.6)
#define MINECRAFT_AMBIENT_LIGHT (0.4)

uniform float GameTime;
uniform vec4 FogColor;

#define Pi 3.14159265359

float SunRadius(vec4 fogColor) {
    float SunRad;
    if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 4.0, 0.0), 1.0)){
        SunRad = 0.02; // sun size in asteroids
    }
    else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 2.0, 0.0), 1.0)){
        SunRad = 0.08; //sun size on the moon
    }
    else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 0.0, 0.0), 1.0)){
        SunRad = 0.1; //sun size in space
    }
    else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 6.0, 0.0), 1.0)){
        SunRad = 0.03; //sun size on europa 
    }
    return SunRad;
}

vec4 minecraft_mix_light(vec3 lightDir0, vec3 lightDir1, vec3 normal, vec4 color) {
    lightDir0 = normalize(lightDir0);
    lightDir1 = normalize(lightDir1);
    float light0 = max(0.0, dot(lightDir0, normal));
    float light1 = max(0.0, dot(lightDir1, normal));
    float lightAccum = min(1.0, (light0 + light1) * MINECRAFT_LIGHT_POWER + MINECRAFT_AMBIENT_LIGHT);
    return vec4(color.rgb * lightAccum, color.a);
}

vec4 minecraft_sample_lightmap(sampler2D lightMap, ivec2 uv) {
    return texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}
