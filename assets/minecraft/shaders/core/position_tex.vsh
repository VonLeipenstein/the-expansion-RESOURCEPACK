#version 330
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:fog.glsl>
// expansion imports
#moj_import <expansion:compare_float.glsl>
#moj_import <expansion:get_dimension.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;

out vec2 texCoord0;
flat out int isCelestial;
flat out float frames;
flat out float textureShift;
flat out float textureHeight;
flat out vec2 atlasSize;

bool isMarker(vec4 color, vec4 compareColor) {
    return all(lessThan(abs(color.rgb - compareColor.rgb), vec3(0.004))); // 1/255 is approx 0.004, so this would be precise to the single rgb digit on a 255 scale
}

int detectMarker(vec2 uv) {
    vec2 cornerUV = uv;
    vec4 c = texture(Sampler0, cornerUV);

    if (isMarker(c, vec4(1.0, 1.0, 1.0, 1.0) / 255.0)) return 1; // Sun
    else if (isMarker(c, vec4(3.0, 3.0, 3.0, 1.0) / 255.0)) return 2; // Moon
    return 0;
}

mat3 rotateX(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat3(
        1.0, 0.0, 0.0,
        0.0,  c,  -s,
        0.0,  s,   c
    );
}

mat3 rotateZ(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat3(
         c, -s, 0.0,
         s,  c, 0.0,
        0.0, 0.0, 1.0
    );
}

mat3 rotateY(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat3(
         c, 0.0,  s,
        0.0, 1.0, 0.0,
        -s, 0.0,  c
    );
}

void main() {
    texCoord0 = UV0;
    atlasSize = vec2(textureSize(Sampler0, 0));
    float size = 1.0;
    float tilt = 0.0;
    float SunOffset = 0.0;

    switch (detectMarker(UV0))
    { // Sun
        case 1: {
            isCelestial = 1;
            frames = 4.0;
            textureHeight = 256.0;
            switch (getDimension(FogColor.rgb, FogCloudsEnd))
            {
                case 1: textureShift = 1.0; size = 1.0; break; // asteroids
                case 2: textureShift = 0.0; size = 1.5; SunOffset = 0.5; break; // moon
                case 3: textureShift = 0.0; size = 1.0; break; // space
                case 4: textureShift = 3.0; size = 0.7; SunOffset = -0.5; break; // europa
                case 5: textureShift = 0.0; size = 0.5; break; // venus
                case 6: textureShift = 2.0; size = 0.5; break; // storage
                default: textureShift = 0.0; size = 1.0;
            } break;
        } // Moon
        case 2: {
            isCelestial = 1;
            frames = 4.0;
            textureHeight = 128.0;
            switch (getDimension(FogColor.rgb, FogCloudsEnd))
            {
                case 1: textureShift = 2.0; size = 2.0; break; // asteroids
                case 2: textureShift = 1.0; size = 2.0; SunOffset = -1.5; tilt = 180; break; // moon
                case 3: textureShift = 3.0; size = 1.0; break; // space
                case 4: textureShift = 2.0; size = 1.5; SunOffset = 3.5; break; // europa
                case 5: textureShift = 3.0; size = 1.0; break; // venus
                case 6: textureShift = 3.0;             break; // storage
                default: textureShift = 0.0; size = 1.0;
            } break;
        }
        default: {
            isCelestial = 0;
        }
    }

    vec3 rotated = rotateY(radians(tilt)) * Position;
    vec4 pos = vec4(rotated, size);
    pos.x += SunOffset;

    gl_Position = ProjMat * ModelViewMat * pos;
}