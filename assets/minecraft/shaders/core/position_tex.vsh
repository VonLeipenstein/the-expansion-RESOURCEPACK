#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform vec4 FogColor;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform sampler2D Sampler0;

out vec2 texCoord0;

float frames = 4;

#moj_import <compare_float.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vec4 corners = texture(Sampler0,vec2(0.0))*255.0;

    //checks corner pixel colours
    if(corners == vec4(1.0,2.0,3.0,255.0))
    {
        //checks custom biome fog colours
        if(approxEquals(FogColor.rgb * 255.0, vec3(0.0, 4.0, 0.0), 1.0))
        {
            texCoord0 = vec2(UV0.x,UV0.y/frames+2/frames); //asteroids uv shift
        }
        else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 2.0, 0.0), 1.0)){
            texCoord0 = vec2(UV0.x,UV0.y/frames+1/frames); //moon uv shift
        }
        else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 0.0, 0.0), 1.0)){
            texCoord0 = vec2(UV0.x,UV0.y/frames+2/frames); //space uv shift
        }
        else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 6.0, 0.0), 1.0)){
            texCoord0 = vec2(UV0.x,UV0.y/frames+3/frames); //europa uv shift
        }
        else{
            texCoord0 = vec2(UV0.x,UV0.y/frames); //europa uv shift
        }
    }
    else
    {
        texCoord0 = UV0;
    }
}