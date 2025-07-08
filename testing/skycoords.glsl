vec4 screenPos = gl_FragCoord;
screenPos.xy = (screenPos.xy / ScreenSize - vec2(0.5)) * 2.0;
screenPos.zw = vec2(1.0);
vec3 view = normalize((ProjInv * screenPos).xyz);

// —— custom rotated basis (sun tilt) ——
float angle = 3.1417; // 180°
vec3 up      = vec3(0.0, cos(angle), sin(angle));
vec3 forward = vec3(0.0, sin(-angle), cos(angle));
vec3 right   = vec3(1.0, 0.0, 0.0);

// —— project view onto that basis → a 3D grid coordinate ——
vec3 dirGrid = vec3(
    dot(view, right),
    dot(view, forward),
    dot(view, up)
) * 32.0;

ivec3  baseCell = ivec3(floor(dirGrid));
vec3   fractOff = fract(dirGrid) - 0.5;   // local offset in cell

// —— accumulate stars from the 3×3×3 neighborhood ——
vec3 color = vec3(0.0);
float brightness = 0.01;

for (int z = -1; z <= 1; ++z) {
    for (int y = -1; y <= 1; ++y) {
    for (int x = -1; x <= 1; ++x) {
        ivec3 cell = baseCell + ivec3(x,y,z);

        // pick a pseudo-random offset *inside* this cell
        float seed = hash31(cell);
        
        // use seed to generate a vec3 offset in [0,1)^3
        vec3 cellOff = vec3(
        seed,
        fract(seed * 7.0),
        fract(seed * 13.0)
        ) - 0.5;  

        // this 3D vector is the star’s center relative to view:
        vec3 starUV = vec3(x,y,z) + cellOff - fractOff;

        // draw it!
        float b = seed * 2.0 * brightness;  // vary brightness by cell
        float s = star3(starUV, b);
        color += vec3(s);
    }
    }
}

// tint and gamma
color *= vec3(0.5, 0.7, 1.0);
fragColor = vec4(color, 1.0);

if (fract(dirGrid.x * 0.1 + GRIDOFFSET) < 0.01 
    || fract(dirGrid.y * 0.1 + GRIDOFFSET) < 0.01
    || fract(dirGrid.z * 0.1 + GRIDOFFSET) < 0.01) {
    fragColor = vec4(1.0, 0.0, 0.0, 1.0);
}