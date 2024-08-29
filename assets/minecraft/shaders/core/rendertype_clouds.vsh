#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform vec4 FogColor;

out vec2 texCoord0;
out float vertexDistance;
out vec4 vertexColor;

void main() {
    
    vec4 newPosition;
    vec4 newColor = Color;

    vec4 pos = ModelViewMat * vec4(Position, 1.0);

    // remove clouds from planets without an atmosphere
    if(FogColor.g > FogColor.r && FogColor.g > FogColor.b)
    {
        newPosition = vec4(2.0, 2.0, 2.0, 1.0);
    }
    else if(approxEquals(FogColor.rgb * 255.0, vec3(255.0, 148.0, 28.0), 1.0))
    {
        newColor = Color * (vec4(255.0, 144.0, 20.0, 50.0) / 255.0);
    }  
    else
    {
        newPosition = ProjMat * pos;
    }

    gl_Position = newPosition;
    texCoord0 = UV0;
    vertexDistance = fog_distance(pos.xyz, FogShape);
    vertexColor = newColor;
}
