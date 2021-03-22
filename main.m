%{
Senior Design
Team Shamrock
last updated: 2/27/21

main.m

Main script of asteroid landing hazard detection & avoidance simulation.

Questions/Ideas/Future Improvements:
-possibly make separate functions for the sections if they get too long
-do we need to have one loop with both KF and image processing/HDA instead
of separate sections?
%}

clear all
close all

%% Add paths to source code for each feature

addpath('ShadowBasedHazardDetection', 'HazardAvoidance')


%% Set up params struct

params.sunVerticalAngle = 20;
params.sunDirection = 'south';
params.hazardHeightThreshold = 15; %pixels (TODO convert to m)
params.landerFootprint = 10; %pixels (TODO convert to m?)
params.showHDAOutput = true;

%% Image Processing
%TODO: read in series of images and perform the following activities in a
%loop over them

%Read in image
test_image = imread('blender_images/1sphere_sun_20.png');
%resize & crop image for now
test_image = imresize(test_image, 1/2);
test_image = test_image(1:512,224:735, :); 

%Perform shadow detection
shadow_hazard_map = shadowBasedDetectionWrapper(test_image, params);

%Perform computer vision

%Perform TRN

%% Lidar Processing

%% IMU Data Processing

%% Kalman Filter 

%% Hazard Detection and Avoidance

%TODO: Combine hazard maps w/ weighting function
hazard_map = shadow_hazard_map;

%Run HDA algorithm
HDAWrapper(hazard_map, params);

%% Format outputs





