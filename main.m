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

%% Add paths to source code for each feature

addpath('ShadowBasedHazardDetection', 'HazardAvoidance','LidarMapping')

%% Set up params struct

params.sunVerticalAngle = 20;
params.sunDirection = 'top';
params.hazardHeightThreshold = 15; %pixels (TODO convert to m)
params.landerFootprint = 10; %pixels (TODO convert to m?)

%% Image Processing
%TODO: read in series of images and perform the following activities in a
%loop over them

%Read in image
image = imread('blender_images/1sphere_sun_20.png');
%resize & crop image for now
test_image = imresize(test_image, 1/2);
image = image(1:512,224:735, :); %crop image for now
image = imrotate(image, 180); %flip image around for testing


%Perform shadow detection
shadow_hazard_map = shadowBasedDetectionWrapper(test_image, params);

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
[xLand, yLand, distanceMap] = HDA1(hazard_map, params);

%% Format outputs

%Plot DTNH map with marker for chosen site
%TODO make a separate function
figure
image(distanceMap)
hold on
plot(xLand, yLand, 'r+', 'MarkerSize', 10, 'LineWidth', 2)
title('DTNH Map with Chosen Site')



