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
imshow(Bennu)

%Perform smoothing to reduce noise
Bennu_smooth = smooth(Bennu);
figure
imshow(Bennu_smooth)

%TODO: wavelet transform



