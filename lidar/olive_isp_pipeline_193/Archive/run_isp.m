% Top-level script which runs the ISP
% clears workspace and all figures:
clear;
close all;

% assumes data is in same folder: 
datapath = '';
imgname = 'yosemite';

% Load the image
img = imread([datapath imgname '.tif']);

% Load metadata provided by the camera
metafile = [datapath imgname '.csv'];
metadata = load_metadata(metafile);

% outputs result
result = isp(img, metadata);

