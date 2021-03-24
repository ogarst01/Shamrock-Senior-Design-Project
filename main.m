%{
Senior Design
Team Shamrock
last updated: 3/10/2021

main.m

Main script of asteroid landing hazard detection & avoidance simulation.

Questions/Ideas/Future Improvements:
-possibly make separate functions for the sections if they get too long
-do we need to have one loop with both KF and image processing/HDA instead
of separate sections?
%}

clear all
close all

% Add paths to source code for each feature

addpath('ShadowBasedHazardDetection', 'HazardAvoidance','LidarMapping','Data')
% Read in photos from Video:
% name of test run video:
filename = 'run_1_March18.MP4';

numPics = GetFrames_Video(filename);

%% Set up params struct

params.sunVerticalAngle = 20;
params.sunDirection = 'top';
params.hazardHeightThreshold = 5; %pixels (TODO convert to m)
params.landerFootprint = 10; %pixels (TODO convert to m?)
params.showHDAOutput = true;

%% Image Processing
cd Data;
cd frames;

startName = 'frame_';
endName   = '.png';
endMatName = '.mat';

for i = 1:numPics
    namePic = [startName, num2str(i), endName];
    %Read in image
    % test_image = imread('test_images/BennuLargestBoulder.png');

    test_image = imread(namePic);
    %resize & crop image for now
    test_image = imresize(test_image, 1/2);
    %test_image = test_image(1:512,224:735, :); %for blender images
    %test_image = test_image(1:300, :, :);

    %Perform shadow detection
    shadow_hazard_map = shadowBasedDetectionWrapper(test_image, params, true);

    cd ..
    cd hazard_Maps;
    
    % save the data:
    matName = [startName, num2str(i), endMatName];
    save(matName,'shadow_hazard_map');
    
    cd ..
    cd frames;
end
%Perform computer vision

%Perform TRN

%% Lidar Processing
% enter filenames for the two data files: 
%lidarDatafile = 'lidar2.txt';
%IMUDatafile   = 'IMU_data.txt';
%m = 2720;
%n = 1530;
%[lidar_hazard_map,xq,yq,vq] = lidarMain(m,n);

%figure,
%scatter(lidar_hazard_map)

%% IMU Data Processing

%% Kalman Filter 

%% Hazard Detection and Avoidance

%TODO: Combine hazard maps w/ weighting function
hazard_map = shadow_hazard_map;

%Run HDA algorithm
HDAWrapper(hazard_map, params);

%% Format outputs





