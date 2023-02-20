// get player space view vector
vec4 screenPos = gl_FragCoord;
screenPos.xy = (screenPos.xy / ScreenSize - vec2(0.5)) * 2.0;
screenPos.zw = vec2(1.0);
vec3 view = normalize((ProjInv * screenPos).xyz);

// speed at which the custom skybox rotates
float angle = Pi*DayLength(FogColor);


// custom axes on which I can align planets
float vdn = dot(view, vec3(0.0, cos(angle), sin(angle)));
float vdt = dot(view, vec3(1.0, 0.0, 0.0));
float vdb = dot(view, vec3(0.0, sin(-angle), cos(-angle)));

// custom fog calculation if sky because sky disc is no longer above the head
if (isSky > 0.5) {
    float ndusq = clamp(dot(view, vec3(0.0, 1.0, 0.0)), 0.0, 1.0);
    ndusq = ndusq * ndusq;

    fragColor = linear_fog(ColorModulator, pow(1.0 - ndusq, 8.0), 0.0, 1.0, FogColor);
} 

//stars
vec3 stars_direction = normalize(vec3(vdn, vdt, vdb));
float stars_threshold = 8.0f;
float stars_exposure = 200.0f;
float stars = pow(clamp(noise(stars_direction * 200.0f), 0.0f, 1.0f), stars_threshold) * stars_exposure;
stars *= mix(0.4, 1.4, noise(stars_direction * 100.0f + vec3(GameTime*500)));

// draws the sun
if (vdn > -SunRadius(FogColor) && vdn < SunRadius(FogColor) && 
    vdt > -SunRadius(FogColor) && vdt < SunRadius(FogColor) &&
    vdb > 0.0
    ) {
    fragColor = vec4(255.0, 255.0, 172.0, 255.0)/255;

    if (vdn > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.33) && vdn < SunRadius(FogColor) - (SunRadius(FogColor) * 0.33) && 
    vdt > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.33) && vdt < SunRadius(FogColor) - (SunRadius(FogColor) * 0.33) &&
    vdb > 0.0
    ) {
    fragColor = vec4(255.0, 255.0, 255.0, 255.0)/255;

        if (vdn > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.66) && vdn < SunRadius(FogColor) - (SunRadius(FogColor) * 0.66) && 
        vdt > -SunRadius(FogColor) + (SunRadius(FogColor) * 0.66) && vdt < SunRadius(FogColor) - (SunRadius(FogColor) * 0.66) &&
        vdb > 0.0
        ) {
        fragColor = vec4(255.0, 255.0, 255.0, 255.0)/255;
        }
    }
}
else {
    float dist = distance(vdb, 1.0)/0.1 + 0.1; // makes the sun glow
    if (approxEquals(FogColor.rgb * 255.0, vec3(255.0, 149.0, 31.0), 1.0)) { //sky on mars, which transitions between night and day with different skycolors
        fragColor = mix(vec4(255.0, 255.0, 172.0, 255.0)/255, mix(vec4(vec3(stars), 1.0), vec4(196.0, 143.0, 63.0, 0.0)/255, clamp(2*sin((Pi*DayLength(FogColor) + Pi)) + 0.8, 0.0, 1.0)), 1-0.1/dist);
    }
    else if (approxEquals(FogColor.rgb * 255.0, vec3(0.0, 4.0, 0.0), 1.0) || approxEquals(FogColor.rgb * 255.0, vec3(0.0, 0.0, 0.0), 1.0)) //sky in space/asteroids where there are always maximum stars
    {
        fragColor = mix(vec4(255.0, 255.0, 172.0, 255.0)/255, vec4(vec3(stars), 1.0), 1-0.1/dist);
    }
    else // sky on planets with no atmosphere, stars dim slightly at daytime
    {
        fragColor = mix(vec4(255.0, 255.0, 172.0, 255.0)/255, mix(vec4(vec3(stars), 1.0), vec4(0.0), clamp(2*sin((Pi*DayLength(FogColor) + Pi)) + 0.8, 0.0, 1.0)*0.4), 1-0.1/dist);
    }
}