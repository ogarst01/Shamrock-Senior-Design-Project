function [rockDiameter, rockHeight] = computeRockSize(shadowSize, sunVertAngle)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/27/21

inputs: 
shadowSize - size of shadow in image (any unit)
sunVertAngle - angle of the sun to the ground (degrees)

outputs: 
rockDiameter - estimated diameter of the rock
rockHeight - estimated height of the rock

purpose:
Estimate the size of the rock based on the size of its shadow and the angle
of the sun.

current model:
-assuming rock is semispherical
-for trig derivation, see trig_derivation.jpg

questions/future improvements:
-is this calculation valid/accurate?

%}

%convert angle to radians
sunAngle = sunVertAngle * pi / 180;

%simple calculation
rockHeight = tan(sunAngle) * shadowSize / (1 - tan(sunAngle) / 2);
rockDiameter = 2 * rockHeight;
end