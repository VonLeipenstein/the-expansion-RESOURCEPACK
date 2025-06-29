#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dimcheck.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ModelOffset;
uniform int FogShape;
uniform vec4 ColorModulator;
uniform vec4 FogColor;

out vec2 texCoord0;
out float vertexDistance;
out vec4 vertexColor;

void main() {
    vec4 newPosition;
    vec3 pos = Position + ModelOffset;
    vec4 newColor = Color * ColorModulator;

    // remove clouds from planets without an atmosphere
    if(FromExpansion(FogColor))
    {
        newPosition =  ModelViewMat * vec4(2.0, 2.0, 2.0, 1.0);
    }
    else if(approxEquals(FogColor.rgb * 255.0, vec3(255.0, 148.0, 28.0), 1.0))
    {
        newColor = Color * (vec4(255.0, 144.0, 20.0, 50.0) / 255.0);
    }  
    else
    {
        newPosition = ProjMat * ModelViewMat * vec4(pos, 1.0);
    }

    gl_Position = newPosition;
    texCoord0 = UV0;
    vertexDistance = fog_distance(pos, FogShape);
    vertexColor = newColor;
}

