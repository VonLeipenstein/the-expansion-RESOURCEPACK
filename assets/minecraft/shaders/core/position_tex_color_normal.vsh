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
    // remove clouds from planets without an atmosphere
    if((FogColor.g > FogColor.r && FogColor.g > FogColor.b))
    {
        gl_Position = vec4(2.0, 2.0, 2.0, 1.0);
        vertexColor = Color;
    }
    else
    {
        if(approxEquals(FogColor.rgb * 255.0, vec3(255.0, 148.0, 28.0), 1.0))
        {
            vertexColor = Color * (vec4(255.0, 144.0, 20.0, 50.0) / 255.0);
        }  
        else
        {
            vertexColor = Color;
        }
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        
    }
    
    texCoord0 = UV0;
    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
