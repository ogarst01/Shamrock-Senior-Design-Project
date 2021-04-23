%{
Senior Design
Team Shamrock
last updated: 3/10/2021

main.m

Main script of asteroid landing hazard detection & avoidance simulation.

Questions/Ideas/Future Improvements:
-do we need to have one loop with both KF and image processing/HDA instead
of separate sections?

TODO:
- TRN
    - change from local yourfolder variable to more flexible solution for
    counting frames 
%}

clear all
close all

% Add paths to source code for each feature

addpath('ShadowBasedHazardDetection', 'HazardAvoidance','LidarMapping',genpath('Data'), genpath('ComputerVision'))
% Read in photos from Video:
% name of test run video:
filename = 'april5_run1.MP4';

dateOfRun = 16;

% TODO: add global photos:
cd Data
cd global_data
glob_map_string_1 = 'april16_glob.PNG';
glob_map = imread(glob_map_string_1);
cd ..
cd ..

%% define whether certain elements in the pipeline have already been 
% completed:
grabFrames = 0;
runTRN = 0;

%% Video Processing: 
framesPerSec = 5;
if(grabFrames == 1)
    % get frames video is for videos under 1 min: 
    % chose one to run: 
    numPics = GetFrames_Video(filename,framesPerSec);
    % longer vid case is for very long videos (over 1 min)
    % no way to read how long the video is in matlab without error - human
    % needed here to decide which to run
    
    % numPics = LongerVidCase(filename,framesPerSec);
end


%% Set up params struct

%For shadow detection
params.smoothSigma = 2;
params.shadowSizeThreshold = 100; %pixels
params.sunVerticalAngle = 30;
params.sunAzimuthAngle = 190;
params.hazardHeightThreshold = 1; %pixels (TODO convert to m)
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

    test_image = imread(namePic);
    
    %resize image for now for faster runs
    test_image = imresize(test_image, 1/4);

    %Perform shadow detection
    shadow_hazard_map = shadowBasedDetectionWrapperAz(test_image, params, true);
    
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


%% TRN Coordinate Mapping:
dateOfRun = 16;

if(runTRN)
    cd TRN

    [TRN_coords,scale_factor] = wrapper_TRN(dateOfRun, framesPerSec);

    cd ..

    % THIS PLOTS TRN OVER TIME - expected to show sweeps over set:
    figure, hold on, 
    imagesc(glob_map), 
    plot3(TRN_coords(:,2),TRN_coords(:,1), TRN_coords(:,3),'LineWidth',3,'Color','r'),
    plot(TRN_coords(1,2),TRN_coords(1,1),'gx','LineWidth',4),
    hold off

    % size is still the same as the global map:
    % TRN_coords_scaled = TRN_coords(:,end:-1:1,:);
    TRN_coords_scaled(:,1) = TRN_coords(:,1) + ((720/2)*scale_factor);
    TRN_coords_scaled(:,2) = TRN_coords(:,2) + ((1280/2)*scale_factor);
    TRN_coords_scaled(:,3) = TRN_coords(:,3);
else
    % TODO - how to save this after running TRN? 
    scale_factor = .33;
    % load the TRN data for that date and framesPerSec
    cd Data
    cd saved_TRN_outputs
    
    fileTRN = ['april',num2str(dateOfRun),'_trnOutput_',num2str(framesPerSec),'.mat'];
    
    data = load(fileTRN);
    TRN_coords_scaled = data.coords_vec;
    
    
    TRN_coords_scaled(:,1) = TRN_coords_scaled(:,1) + ((720/2)*scale_factor);
    TRN_coords_scaled(:,2) = TRN_coords_scaled(:,2) + ((1280/2)*scale_factor);
    TRN_coords_scaled(:,3) = TRN_coords_scaled(:,3);
    cd ..
    cd ..
    
    % TODO : assert what to do if file not found! 
end

figure(20)
hold on, 
imagesc(glob_map), 
plot3(TRN_coords_scaled(:,1), TRN_coords_scaled(:,2),TRN_coords_scaled(:,3),'LineWidth',3,'Color','r') 
plot3(TRN_coords_scaled(1,1),TRN_coords_scaled(1,2),0,'go','LineWidth',6)
plot3(TRN_coords_scaled(end,1),TRN_coords_scaled(end,2),0,'bx','LineWidth',6)
title('TRN coords over time'), 
zlabel('time(seconds)'),
ylabel('y pixels'),
xlabel('pixels'),
hold off

%% Lidar Processing

% load the Lidar coords: 
cd LidarMapping;

M = 720;
N = 1280;
[hazardMapLidar,xq,yq,vq] = lidarMain(M,N, TRN_coords_scaled, dateOfRun,glob_map);
%  = lidarMain(m,n, TRN_coords, dateOfRun,glob_map)
 
cd ..

% plot Lidar results:
figure,
subplot(2,1,1)
imagesc(hazardMapLidar')
colorbar
title('hazard map from Lidar data')
ylabel('y pixels')
xlabel('x pixels')
subplot(2,1,2)
imagesc(flip(glob_map,2))
title('global map from drone camera')
ylabel('y pixels')
xlabel('x pixels')
%% IMU Data Processing

%% Kalman Filter 
cd Kalman_Filter

KF_main()

cd ..
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





