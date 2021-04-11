function out = interpLidar(imgMat)
% interpolation method = cubic spline interpolation 
% (better about edge detection)

figure, stem3(imgMat), title('input lidar data reshaped')

% Clip = there will be no lidar data points that 
% are less than 0 or more than the height specified
maxHeight = 2000;
minHeight = 0;

% interpolate using cubid spline interpolation
interpLidar3 = interp2(double(imgMat), 2, 'cubic');

figure, stem3(interpLidar3), title('input lidar data interpolated')

%%
figure, 
surf(interpLidar3)
shading interp
colorbar

out = interpLidar3;
end