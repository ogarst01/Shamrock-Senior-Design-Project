function [rockDiameter, rockHeight] = computeRockSize(shadowSize, sunVertAngle)
%assume sun vertical angle input is in degrees

sunAngle = sunVertAngle * pi / 180;

%simple calculation
rockHeight = atan(sunAngle) * shadowSize;

rockDiameter = 2 * rockHeight;
end