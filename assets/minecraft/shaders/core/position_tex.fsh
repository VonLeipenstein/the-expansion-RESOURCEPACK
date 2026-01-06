#version 330
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

#moj_import <expansion:shift_texture.glsl>

in vec2 texCoord0;
flat in int isCelestial;
flat in float textureShift;
flat in float frames;
flat in float textureHeight;
flat in vec2 atlasSize;

uniform sampler2D Sampler0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    if (isCelestial == 1)
    {
        // scale the uv to pixel coordinates
        vec2 uv = texCoord0 * atlasSize;

        // calculate the warped and shifted UV
        uv = shiftTextureUV(uv, textureHeight, frames, textureShift);

        // normalize the uv
        color = texture(Sampler0, uv / atlasSize);
    } 

    fragColor = color * ColorModulator;
}