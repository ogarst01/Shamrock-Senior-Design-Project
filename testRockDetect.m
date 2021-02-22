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
im_gray = im_gray(1:512,224:736); 
figure
imshow(im_gray)
title('Original Image')

%Perform smoothing & wavelet transform
im_smooth = smooth(im_gray, 1);
im_mw = multiscaleWavelet(im_smooth);
figure
imshow(im_mw)
title('Multiscale Wavelet Transform of Image')

%Remove shadows below the threshold value
threshold = 50; %pixels
plotBoundaries = false;
im_shadows = findShadows(im_mw, threshold, plotBoundaries);
figure
imshow(im_shadows);
title('Significant Shadows in Image')

%Find boundaries of shadow & compute its length
im_bound = findBoundaries(im_shadows);
shadow_length = computeShadowSize(im_bound, 'y');

%Estimate object size
[diameter, height] = computeRockSize(shadow_length, 20);
diameter = round(diameter);
height = round(height);

%Make hazard map
%TODO need to convert pixels to m!
height_threshold = 30; %pixels
hazard_map = zeros(size(im_shadows));
sun_dir = 'south';
%Apply threshold to determine if rock is hazardous
if height > height_threshold
    hazard_map = mapRocks(im_bound, diameter, sun_dir, size(hazard_map));
end

%make output
%find boundaries - black pixels next to white
    [row, col] = size(hazard_map);
    bound_idx = [];
    for i = 1:row
        for j = 1:col
            %check black pixels
            if(hazard_map(i,j) == 0)
                [bound_row, bound_col] = size(bound_idx);
                %check adjacent pixels
                %if one is white, mark this as a boundary (red)
                if(i < row && hazard_map(i+1,j) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                elseif (i > 1 && hazard_map(i-1,j) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                elseif (j < col && hazard_map(i, j+1) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                elseif (j > 1 && hazard_map(i, j-1) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                end
            end
        end
    end

    figure
    imshow(im_gray)
    hold on
    plot(bound_idx(:,2), bound_idx(:,1), '.r', 'MarkerSize', 3)
    hold off


