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

%% Add paths to source code for each feature

addpath('ShadowBasedHazardDetection')


%% Set up params struct

params.sunVerticalAngle = 20;
params.sunDirection = 'top';
params.hazardHeightThreshold = 15; %pixels (TODO convert to m)

%% Image Processing
%TODO: read in series of images and perform the following activities in a
%loop over them

%Read in image
image = imread('blender_images/1sphere_sun_20.png');
image = image(1:512,224:735, :); %crop image for now
image = imrotate(image, 180); %flip image around for testing

%Perform shadow detection
shadow_hazard_map = shadowBasedDetectionWrapper(image, params);

%Perform computer vision

%Perform TRN

%% Lidar Processing

%% IMU Data Processing

%% Kalman Filter 

%% Hazard Detection and Avoidance

%Combine hazard maps

%% Format outputs



