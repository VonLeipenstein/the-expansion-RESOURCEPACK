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
out vec4 normal;

void main() {
    if((FogColor.g > FogColor.r && FogColor.g > FogColor.b) || approxEquals(FogColor.rgb * 255.0, vec3(255.0, 149.0, 31.0), 1.0)){
        gl_Position =vec4(2.0, 2.0, 2.0, 1.0);
    }
    else
    {
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    }
    
    texCoord0 = UV0;
    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    vertexColor = Color;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
