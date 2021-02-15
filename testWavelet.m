%{
Senior Design
Team Shamrock
Melissa Rowland
12/6/20

testWavelet
Test script for edge detection using wavelet transforms.
%}

clear all
close all

%Read in image, convert to grayscale
Bennu_orig = imread('BennuLargestBoulder.png');
Bennu = rgb2gray(Bennu_orig);
Bennu = imresize(Bennu, 1/2);
%imshow(Bennu)

%Perform smoothing to reduce noise
Bennu_smooth = smooth(Bennu, 1);
%figure
%imshow(Bennu_smooth)

%Try Canny transform
Bennu_canny = edge(Bennu_smooth, 'canny');
%figure
%imshow(Bennu_canny)

%Try multiscale wavelet transform
Bennu_mw = multiscaleWavelet(Bennu_smooth);
figure
imshow(Bennu_mw)

%try smoothing again
%{
Bennu_mw_smooth = imguidedfilter(Bennu_mw, 'NeighborhoodSize', [10,10]);
figure
imshow(Bennu_mw_smooth)
%}

%Try finding shadows in multiscale transform image
threshold = 30; %pixels
plotBound = true;
Bennu_shadows = findShadows(Bennu_mw, threshold,true);
figure
imshow(Bennu_shadows);



