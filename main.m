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

addpath('ShadowBasedHazardDetection', 'HazardAvoidance','LidarMapping',genpath('Data'), genpath('ComputerVision'))
% Read in photos from Video:
% name of test run video:
filename = 'run_1_March18.MP4';

numPics = GetFrames_Video(filename);

%% Set up params struct

%For shadow detection
params.sunVerticalAngle = 20;
params.sunDirection = 'top';
params.hazardHeightThreshold = 5; %pixels (TODO convert to m)
params.landerFootprint = 10; %pixels (TODO convert to m?)

%For computer vision
params.boulderDetectorString = 'boulderDetector.mat';
params.smallRockDetectorString = 'smallRockDetector.mat';
params.boulderDetectorThreshold = 30;
params.smallRockDetectorThreshold = 65;

%For HDA
params.showHDAOutput = true;

%% Image Processing
cd Data;
cd frames;

startName = 'frame_';
endName   = '.png';
endMatName = '.mat';

%Todo - loop over all pics (i = 1:numPics). currently only doing a few for faster runs
for i = 1:3
    namePic = [startName, num2str(i), endName];
    %Read in image
    % test_image = imread('test_images/BennuLargestBoulder.png');

    test_image = imread(namePic);
    %resize & crop image for now
    test_image = imresize(test_image, 1/4);
    %test_image = test_image(1:512,224:735, :); %for blender images
    %test_image = test_image(1:300, :, :);

    %Perform shadow detection
    shadow_hazard_map = shadowBasedDetectionWrapper(test_image, params, true);
    
    %Perform computer vision
    cv_hazard_map = boulderDetectFunc(test_image, params);

    cd ..
    cd hazard_Maps;
    
    % save the data:
    matName1 = [startName, num2str(i),  '_shadow', endMatName];
    save(matName1,'shadow_hazard_map');
    matName2 = [startName, num2str(i), '_cv', endMatName];
    save(matName2, 'cv_hazard_map');
    
    
    cd ..
    cd frames;
end
%Perform computer vision

%Perform TRN

%% Lidar Processing
cd LidarMapping;
m = 720;
n = 1280;
[lidar_hazard_map,xq,yq,vq] = lidarMain(m,n);
 
cd ..
%% IMU Data Processing

%% Kalman Filter 

%% Hazard Detection and Avoidance

for j = 1:3
    %load data
    shadow_hazard = load([startName, num2str(j), '_shadow', endMatName]);
    shadow_hazard_map = shadow_hazard.shadow_hazard_map;
    cv_hazard = load([startName, num2str(j), '_cv', endMatName]);
    cv_hazard_map = cv_hazard.cv_hazard_map;
    
    %Combine hazard maps w/ logical OR
    hazard_map = shadow_hazard_map | cv_hazard_map;

    %Run HDA algorithm
    HDAWrapper(hazard_map, params);
end

%% Format outputs





