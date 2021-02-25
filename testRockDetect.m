%{
Senior Design
Team Shamrock
Melissa Rowland
2/21/21

testRockDetect
Test script for detecting rocks in an image using wavelet transform to get
clear shadows, and then computing rock location based on those shadows.
%}

clear all
close all

%Read in image, convert to grayscale
im_orig = imread('blender_images/1sphere_sun_20.png');
im_gray = rgb2gray(im_orig);
%Optional resizing
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
threshold = 100; %pixels
plotBoundaries = false;
im_shadows = findShadows(im_mw, threshold, plotBoundaries);
figure
imshow(im_shadows);
title('Significant Shadows in Image')

%Manually remove object that shows up as shadow from blender image
im_shadows2 = removeShadow([258, 230], im_shadows);

%Find boundaries of shadow & compute its length
im_bound = findBoundaries(im_shadows2);
shadow_length = computeShadowSize(im_bound, 'y');

%Estimate object size
[diameter, height] = computeRockSize(shadow_length, 20);
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

%make output
%find boundaries - black pixels next to white
hazard_image = hazard_map;
hazard_idx = find(hazard_map == 1);
safe_idx = find(hazard_map == 0);
hazard_image(hazard_idx) = 0;
hazard_image(safe_idx) = 256;
[row, col] = size(hazard_map);
bound_idx = [];
for i = 1:row
    for j = 1:col
        %check black pixels
        if(hazard_image(i,j) == 0)
            [bound_row, bound_col] = size(bound_idx);
            %check adjacent pixels
            %if one is white, mark this as a boundary (red)
            if(i < row && hazard_image(i+1,j) == 256)
                bound_idx(bound_row+1, :) = [i, j];
            elseif (i > 1 && hazard_image(i-1,j) == 256)
                bound_idx(bound_row+1, :) = [i, j];
            elseif (j < col && hazard_image(i, j+1) == 256)
                bound_idx(bound_row+1, :) = [i, j];
            elseif (j > 1 && hazard_image(i, j-1) == 256)
                bound_idx(bound_row+1, :) = [i, j];
            end
        end
    end
end

figure
imshow(im_gray)
hold on
plot(im_bound(:,2), im_bound(:,1), '.r', 'MarkerSize', 3)
plot(bound_idx(:,2), bound_idx(:,1), '.b', 'MarkerSize', 3)
hold off


