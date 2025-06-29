const float density = 1.0;
const float starSize = 0.1;
const float curveStrength = 0.5;

// Fade the sky plane as it gets further away
float intensity = smoothstep(0.0, 1.0, -cartesian.y * 0.9);

// calculate the curve
float curve = pow(abs(cartesian.y), curveStrength);

// Create a curved plane
vec2 uv = sphericalCoord;

vec3 color = vec3(0.0);
float dist = 1.0;
float brightness = .01;

uv = (floor(uv*256.)/256.)-.51019;
uv *= 128.;
uv += floor((GameTime)*64.)/3072.0;

vec2 gv=fract(uv)-.5;
vec2 id;
float displacement;

uv/=2.;
gv=fract(uv)-.5;
for(float y=-dist;y<=dist;y++)
{
    for(float x=-dist;x<=dist;x++)
    {
        id=floor(uv);
        displacement=hash21(id+vec2(x,y));
        color+=vec3(star(gv-vec2(x,y)-vec2(displacement,fract(displacement*16.))+.5,(hash21(id+vec2(x,y))/128.)));
    }
}

uv/=8.;
gv=fract(uv)-.5;
for(float y=-dist;y<=dist;y++)
{
    for(float x=-dist;x<=dist;x++)
    {
        id=floor(uv);
        displacement=hash21(id+vec2(x,y));
        color+=vec3(star(gv-vec2(x,y)-vec2(displacement,fract(displacement*16.))+.5,(hash21(id+vec2(x,y))/256.)));
    }
}

uv/=6.;
gv=fract(uv)-.5;
for(float y=-dist;y<=dist;y++)
{
    for(float x=-dist;x<=dist;x++)
    {
        id=floor(uv);
        displacement=hash21(id+vec2(x,y));
        color+=vec3(star(gv-vec2(x,y)-vec2(displacement,fract(displacement*16.))+.5,(hash21(id+vec2(x,y))/256.)));
    }
}

color *= vec3(.5,.7,1.);
//color = floor(0.01 + color * 16.0) / 16.0;
fragColor = vec4(color, 1.0);