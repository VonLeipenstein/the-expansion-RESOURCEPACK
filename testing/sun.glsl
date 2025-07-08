// sun angle
angle = Pi * 0.9;

view = normalize((ProjInv * screenPos).xyz);

// Define custom sky basis (rotated up vector)
up = vec3(0.0, cos(angle), sin(angle));
forward = vec3(0.0, sin(-angle), cos(-angle));
right = vec3(1.0, 0.0, 0.0);

// Project view vector onto this basis
vx = dot(view, right);
vy = dot(view, up);
vz = dot(view, forward);

// draws the sun
if (vx > -SunRadius(FogColor) && vx < SunRadius(FogColor) && 
    vy > -SunRadius(FogColor) && vy < SunRadius(FogColor) &&
    vz < 0.0
    ) {
    fragColor = vec4(255.0, 255.0, 172.0, 255.0) / 255.0;

    if (vx > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.33) && vx < SunRadius(FogColor) - (SunRadius(FogColor) * 0.33) && 
        vy > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.33) && vy < SunRadius(FogColor) - (SunRadius(FogColor) * 0.33) &&
        vz < 0.0
    ) {
    fragColor = vec4(255.0, 255.0, 255.0, 255.0) / 255.0;

        if (vx > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.66) && vx < SunRadius(FogColor) - (SunRadius(FogColor) * 0.66) && 
            vy > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.66) && vy < SunRadius(FogColor) - (SunRadius(FogColor) * 0.66) &&
            vz < 0.0
        ) {
        fragColor = vec4(255.0, 255.0, 255.0, 255.0) / 255.0;
        }
    }
}