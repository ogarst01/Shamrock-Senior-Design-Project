function [b] = projection_3d(a, c, theta, e)
% Using persepctive projection 
% z direction (altitude)
%   y ^ -----------------
%     ||                 |
%      |                 |
%      |    (surface)    |
%      |                 |
%      |                 |
%      x------------------ --> x
%   (origin)
%
% Inputs: 
% a: 3D position of a point A being projected
% c: 3D camera position 
% theta: orientation of the camera *** Note: In Tait-Bryan angles! ***
% e: surface position relative to camera position C
%
% Outputs:
% b: 2D position of a

if (length(a) ~= 3) && (length(c) ~= 3) && (length(theta) ~= 3) && (length(e) ~= 3)
    fprintf('Incorrect input vector length')
    return
end

if size(a, 1) == 1
    a = a';
end

if size(c, 1) == 1
    c = c';
end

mx = [1 0 0; 0 cos(theta(1)) sin(theta(1)); 0 (-1*sin(theta(1))) cos(theta(1))];
my = [cos(theta(2)) 0 (-1*sin(theta(2))); 0 1 0; sin(theta(2)) 0 cos(theta(2))];
mz = [cos(theta(3)) sin(theta(3)) 0; (-1*sin(theta(3))) cos(theta(3)) 0; 0 0 1];

d = mx * my * mz * (a - c);

b(1) = ((e(3)/d(3))*d(1)) + e(1);
b(2) = ((e(3)/d(3))*d(2)) + e(2);
end
