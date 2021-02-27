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
-assuming shadow length is base of right triangle with height of rock as 
the height, sun vertical angle is the angle opposite the height

questions/future improvements:
-is this calculation valid/accurate?
-take into account that the shadow goes from the edge of the object not the
center

%}

%convert angle to radians
sunAngle = sunVertAngle * pi / 180;

%simple calculation
rockHeight = tan(sunAngle) * shadowSize;
rockDiameter = 2 * rockHeight;
end