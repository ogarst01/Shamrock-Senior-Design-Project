function [m, b] = computeLine(sunAzimuthAngle, shadowAvgPoint)
%{
Senior Design
Team Shamrock
Melissa Rowland
Updated: 4/11/21

inputs: 
sunAzimuthAngle - azimuth angle of the sunlight [must be b/t 0 and 360
                  degrees]
shadowAvgPoint - average point of shadow boundary

outputs: 
m - slope of line through average point at azimuth angle
b - y intercept of line through average point at azimuth angle

purpose:
Compute the slope and y-intercept of the line through the average point at
that azimuth angle.
%}

%compute slope as tangent of angle
m = tand(sunAzimuthAngle);
m = -m; %since y axis of image is flipped

%find intercept
x_avg = shadowAvgPoint(1);
y_avg = shadowAvgPoint(2);
b = m * (0 - x_avg) + y_avg;

end