#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform vec4 FogColor;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform sampler2D Sampler0;

out vec2 texCoord0;

// import functions
#moj_import <compare_float.glsl>
#moj_import <shift_texture.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vec4 corners = texture(Sampler0, vec2(0.0)) * 255.0;

    //checks corner pixel colours
    if (corners == vec4(1.0, 2.0, 3.0, 255.0)) {
        //checks custom biome fog colours
        if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 4.0, 0.0), 1.0)) {
            texCoord0 = shiftUV(UV0, 4.0, 2.0); //asteroids uv shift
        }
        else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 2.0, 0.0), 1.0)) {
            texCoord0 = shiftUV(UV0, 4.0, 1.0); //moon uv shift
        }
        else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 0.0, 0.0), 1.0)) {
            texCoord0 = shiftUV(UV0, 4.0, 2.0); //space uv shift
        }
        else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 6.0, 0.0), 1.0)) {
            texCoord0 = shiftUV(UV0, 4.0, 3.0); //europa uv shift
        }
        else {
            texCoord0 = vec2(UV0.x, UV0.y / 4.0);
        }
    }
    else {
        texCoord0 = UV0;
    }
}