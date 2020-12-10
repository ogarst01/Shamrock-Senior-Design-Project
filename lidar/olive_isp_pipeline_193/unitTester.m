% Top-level script which runs the ISP
% clears workspace and all figures:
clear;
close all;

%% APPLES PHOTO:
% assumes data is in same folder: 
datapath = '';
imgname = 'apples';

% Load the image
img = imread([datapath imgname '.tif']);

% Load metadata provided by the camera
metafile = [datapath imgname '.csv'];
metadata = load_metadata('apples.csv');

% outputs result
result = isp(img, metadata);
imshow(result)

%%
% assumes data is in same folder: 
datapath = '';
imgname = 'newyear';

% Load the image
img = imread([datapath imgname '.tif']);

% Load metadata provided by the camera
metafile = [datapath imgname '.csv'];
metadata = load_metadata('keyboard.csv');

% outputs result
result = isp(img, metadata);
imshow(result)

%% keyboard
% assumes data is in same folder: 
datapath = '';
imgname = 'keyboard';

% Load the image
img = imread([datapath imgname '.tif']);

% Load metadata provided by the camera
metafile = [datapath imgname '.csv'];
metadata = load_metadata('keyboard.csv');

% outputs result
result = isp(img, metadata);
imshow(result)

%% desk
% assumes data is in same folder: 
datapath = '';
imgname = 'yosemite';

% Load the image
img = imread([datapath imgname '.tif']);

% Load metadata provided by the camera
metafile = [datapath imgname '.csv'];
metadata = load_metadata('keyboard.csv');

% outputs result
result = isp(img, metadata);
imshow(result)

