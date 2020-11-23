% take input image, time, velocity, sun angle
clear
close all

% show original sample image:
im = imread('imgBennu.jpg');
figure,
imshow(im(1:100,1:100,:))
title('sample image')
%%
asteroidIm = makeLidarData(im);
%%
figure,
surf(asteroidIm(:,:,1))

% find slope for one axis:

% find slope for the other axis: 
edges = edge(im(:,:,1), 'Canny');
imshow(edges)

% run edge detection algorithm