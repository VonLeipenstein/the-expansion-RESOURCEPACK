bool FromExpansion(vec4 FogColor) 
{
  // Expansion dimensions all have a very slight green tint that shouldn't occur in vanilla
  return (FogColor.g > FogColor.r && FogColor.g > FogColor.b);
}