%{
Senior Design
Team Shamrock
Melissa Rowland
2/21/21

testRockDetect
Test script for detecting rocks in an image using wavelet transform to get
clear shadows, and then computing rock location based on those shadows.

Currently: 
-only works for one shadow
-only works for sunlight coming straight from bottom of image
-estimates rock location as a square

Future improvements:
-compute rock locations for multiple shadows
-compute rock location for sunlight coming from all 4 straight directions
-compute rock location for sunlight coming from angle
-estimate rock location as an ellipse
-improve accuracy of size estimation
%}

clear all
close all

%Read in image, convert to grayscale
im_orig = imread('../blender_images/1sphere_sun_20.png');
im_gray = rgb2gray(im_orig);
%Optional resizing to 512 x 512
im_gray = imresize(im_gray, 1/2);
im_gray = im_gray(1:512,224:735); 
figure
imshow(im_gray)
title('Original Image')

%Perform smoothing & wavelet transform
im_smooth = smooth(im_gray, 2);
im_mw = multiscaleWavelet(im_smooth);
figure
imshow(im_mw)
title('Multiscale Wavelet Transform of Image')

%Remove shadows below the threshold value
threshold = 500; %pixels
plotBoundaries = false;
im_shadows = findShadows(im_mw, threshold, plotBoundaries);

%Manually remove object that shows up as shadow from blender image
im_shadows2 = removeShadow([258, 230], im_shadows);
figure
imshow(im_shadows2);
title('Significant Shadow in Image')

%Find boundaries of shadow & compute its length
im_bound = findBoundaries(im_shadows2, false);
shadow_length = computeShadowSize(im_bound, 'y');

%Estimate object size
sunVerticalAngle = 20; %degrees
[diameter, height] = computeRockSize(shadow_length, sunVerticalAngle);
diameter = round(diameter);
height = round(height);

%Make hazard map
%TODO need to convert pixels to m!
height_threshold = 15; %pixels
hazard_map = zeros(size(im_shadows));
sun_dir = 'south';
%Apply threshold to determine if rock is hazardous
if height > height_threshold
    hazard_map = mapRocks(im_bound, diameter, sun_dir, size(hazard_map));
end

%Make output image
%Convert hazard map to binary image to reuse findBoundaries function
hazard_image = hazard_map;
hazard_idx = find(hazard_map == 1);
safe_idx = find(hazard_map == 0);
hazard_image(hazard_idx) = 0;
hazard_image(safe_idx) = 256;
bound_idx = findBoundaries(hazard_image, false);
%Plot boundaries of hazard and shadow on top of original image
figure
imshow(im_gray)
hold on
plot(im_bound(:,2), im_bound(:,1), '.r', 'MarkerSize', 3)
plot(bound_idx(:,2), bound_idx(:,1), '.b', 'MarkerSize', 3)
hold off
title('Hazard Location Estimate')


