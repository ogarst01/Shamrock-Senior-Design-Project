% Top-level script which runs the ISP
% clears workspace and all figures:
clear;
close all;

% assumes data is in same folder: 
datapath = '';
imgname = 'keyboard';

% get to directory to grab info:
cd test_images

% Load the image
img = imread([datapath imgname '.tif']);

% grab reference groundtruth for PSNR calculation:
ref = imread([datapath imgname '.jpg']);

% Load metadata provided by the camera
metafile = [datapath imgname '.csv'];
metadata = load_metadata('keyboard.csv')

cd ..
%%
% outputs result
tic
result = isp(img, metadata);
toc
%%
[A, B, C] = size(result);
ref2 = imresize(ref,[A B]);
%%
[peakPSNR, SNR] = psnr(double(result), double(ref2));

PSNR = abs(peakPSNR)
figure, imshow(rescale(real(result)))