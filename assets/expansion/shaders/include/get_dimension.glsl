int getDimension(vec3 biomeFog, float cloudFogDistance) {
    float moonCFD       = 0.0011;
    float asteroidsCFD  = 0.0012;
    float spaceCFD      = 0.0013;
    float europaCFD     = 0.0014;
    float storageCFD     = 0.0015;
    vec3 venusFog       = vec3(154.0,119.0,23.0);

    if      (approxEquals(cloudFogDistance, asteroidsCFD, 0.00001)) return 1; // asteroids
    else if (approxEquals(cloudFogDistance, moonCFD, 0.00001))      return 2; // moon
    else if (approxEquals(cloudFogDistance, spaceCFD, 0.00001))     return 3; // space
    else if (approxEquals(cloudFogDistance, europaCFD, 0.00001))    return 4; // europa
    else if (approxEquals(cloudFogDistance, storageCFD, 0.00001))   return 6; // storage
    else if (approxEqualsVec3(biomeFog * 255.0, venusFog, 1.0))     return 5; // venus
    return 0;
}