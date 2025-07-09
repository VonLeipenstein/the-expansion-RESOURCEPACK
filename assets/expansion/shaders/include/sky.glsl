// get player space view vector
vec4 screenPos = gl_FragCoord;
screenPos.xy = (screenPos.xy / ScreenSize - vec2(0.5)) * 2.0;
screenPos.zw = vec2(1.0);
vec3 view = normalize((ProjInv * screenPos).xyz);

#define Pi 3.14159265359

// sun angle
float angle = Pi * 0.9;

// custom axes on which I can align planets
float vdn = dot(view, vec3(0.0, cos(angle), sin(angle)));
float vdb = dot(view, vec3(1.0, 0.0, 0.0));
float vdt = dot(view, vec3(0.0, sin(-angle), cos(-angle)));

// custom fog calculation if sky because sky disc is no longer above the head
if (isSky > 0.5) {
    float ndusq = clamp(dot(view, vec3(0.0, 1.0, 0.0)), 0.0, 1.0);
    ndusq = ndusq * ndusq;

    fragColor = linear_fog(ColorModulator, pow(1.0 - ndusq, 8.0), 0.0, 1.0, FogColor);
} 

// stars
vec3 stars_direction = normalize(vec3(vdn, vdt, vdb));
float stars_threshold = 8.0f;
float stars_exposure = 200.0f;

float stars = pow(clamp(noise(stars_direction * 200.0f), 0.0f, 1.0f), stars_threshold) * stars_exposure;
stars *= mix(0.4, 1.4, noise(stars_direction * 100.0f));

// draws the sun
float SunSize = SunRadius(FogColor);
if (vdn > -SunSize && vdn < SunSize && 
    vdb > -SunSize && vdb < SunSize &&
    vdt < 0.0
    ) {
    fragColor = vec4(255.0, 255.0, 172.0, 255.0) / 255.0;

    if (vdn > -SunSize + (SunSize * 0.33) && vdn < SunSize - (SunSize * 0.33) && 
        vdb > -SunSize + (SunSize * 0.33) && vdb < SunSize - (SunSize * 0.33) &&
        vdt < 0.0
    ) {
    fragColor = vec4(255.0, 255.0, 255.0, 255.0) / 255.0;

        if (vdn > -SunSize + (SunSize * 0.66) && vdn < SunSize - (SunSize * 0.66) && 
            vdb > -SunSize + (SunSize * 0.66) && vdb < SunSize - (SunSize * 0.66) &&
            vdt < 0.0
        ) {
        fragColor = vec4(255.0, 255.0, 255.0, 255.0) / 255.0;
        }
    }
}
else {
    float dist = distance(vdt, -1.0) / SunSize / 0.5 + 0.1; // makes the sun glow
    fragColor = mix(vec4(255.0, 255.0, 172.0, 255.0)/255.0, vec4(vec3(stars), 1.0), 1.0 - 0.1 / dist);
}