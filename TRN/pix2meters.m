function m = pix2meters(pixel,size)
% Converts pixels on the camera image to meters 
% Inputs:
% pixel: pixel being mapped to meters (1x2 vector - x,y)
% size: size of stage in meters (1x2 vector - x,y)
x_pix = 720;
y_pix = 1280;
x_meters = size(1);
y_meters = size(2);

% Define conversion rate, number of pixels per meter
cx = x_meters/x_pix;
cy = y_meters/y_pix;

m(1) = pixel(1) * cx;
m(2) = pixel(2) * cy;

end