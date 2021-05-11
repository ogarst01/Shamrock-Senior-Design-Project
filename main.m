%{
Senior Design
Team Shamrock
last updated: 5/11/2021

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

%clear all
%close all

% Add paths to source code for each feature

addpath('ShadowBasedHazardDetection', 'HazardAvoidance','LidarMapping',genpath('Data'), genpath('ComputerVision'))
addpath('Data/lidar_data','Data/global_data','Data/frames','Data/global_data')
addpath('ComputerVision/BoulderDetect')

% Read in photos from Video:
% name of test run video:
IMU_data_file = '';
glob_map_string_1 = 'april16_glob.PNG';
glob_map = imread(glob_map_string_1);

dateOfRun = 16;
if(dateOfRun == 20)
    % april 20 run:
    global_map_string = 'global_april20.PNG';
    local_height = 0.4;
    global_height = 1.08;    
elseif(dateOfRun == 16)
    filename = 'april16_run.MP4';
    % april 16 run:
    global_map_string = 'april5_global_from_.93m.png';
    local_height = 0.3268;
    global_height = .93;
    % Amount to rotate for TRN:
    rotate = 90;
elseif(dateOfRun == 5)
    % april 5 run: 
    global_map_string = 'april5_global_from_.93m.png';
    local_height = 0.33;
    global_height = 0.98;   
else
    sprintf("ERROR - dates must be 5,16 or 20!")
end


%% define whether certain elements in the pipeline have already been 
% completed:
grabFrames = 0;
runTRN = 0;

%% Video Processing: 
% framesPerSec = 5;
framesPerSec = 1;

filenames = ["april16_firstMin.mp4", "april16_secondMin.mp4"];
numVids = length(filenames);

if(grabFrames == 1)
    % get frames video is for videos under 1 min: 
    % chose one to run: 
    % numPics = GetFrames_Video(filename,framesPerSec);
    
    % longer vid case is for very long videos (over 1 min)
    % no way to read how long the video is in matlab without error - human
    % needed here to decide which to run
    
    numPics = LongerVidCase(numVids, filenames,framesPerSec);
else
    % count the number of files in the frames directory: 
    yourfolder = '/Users/Olive/Documents/MATLAB/seniorDesign/Shamrock-Senior-Design-Project/Data/frames';
    numPics = dir([yourfolder '/*.png']);
    numPics = length(numPics);
end


%% Set up params struct

%For shadow detection
params.smoothSigma = 2;
params.shadowSizeThreshold = 100; %pixels
params.sunVerticalAngle = 30;
params.sunAzimuthAngle = 105;
params.hazardHeightThreshold = 1; %pixels (TODO convert to m)
params.landerFootprint = 10; %pixels (TODO convert to m?)

%For computer vision
params.boulderDetectorString = 'boulderDetector.mat';
params.smallRockDetectorString = 'SRDetector.mat';
params.boulderDetectorThreshold = 30;
params.smallRockDetectorThreshold = 65;

%For HDA
params.showHDAOutput = true;

%% Image Processing
imagProc = 0;
if(imagProc == 1)
    cd Data;
    cd frames;

    startName = 'frame_';
    endName   = '.png';
    endMatName = '.mat';

    %Todo - loop over all pics (i = 1:numPics). currently only doing a few for faster runs
    for i = 1:numPics
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

    cd ..
    cd ..
end


%% TRN Coordinate Mapping:
dateOfRun = 16;
runTRN = 0;
framesPerSec = 5; 
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
    TRN_coords = data.coords_vec;
    cd ../../TRN
    TRN_coords = outlierReject(TRN_coords);
    
    
    TRN_coords_scaled(:,1) = TRN_coords(:,1) + ((720/2)*scale_factor);
    TRN_coords_scaled(:,2) = TRN_coords(:,2) + ((1280/2)*scale_factor);
    TRN_coords_scaled(:,3) = TRN_coords(:,3);
    cd ..

    % TODO : assert what to do if file not found! 
end
%%
animateTRN(glob_map, TRN_coords_scaled);
%% Now that have coordinate system => Lidar Processing
startPos = [1180,500];
endPos = [180, 220];
% load the Lidar coords: 
displayImagesLidar = 0;
M = 720;
N = 1280;
[hazardMapLidar,xq,yq,vq] = lidarMain(M,N, TRN_coords_scaled, dateOfRun,glob_map, ...
    displayImagesLidar, startPos, endPos);
% hazardMapLidar = ones(size(hazardMapLidar)) - hazardMapLidar;
%  = lidarMain(m,n, TRN_coords, dateOfRun,glob_map)

% plot Lidar results:
hazz = 1 - flip(hazardMapLidar,1);

figure,
subplot(2,1,1)
imagesc(hazz)
colorbar
title('hazard map from Lidar data')
ylabel('y pixels')
xlabel('x pixels')
subplot(2,1,2)
imagesc(glob_map)
title('global map from drone camera')
ylabel('y pixels')
xlabel('x pixels')
%% IMU Data Processing

%% Kalman Filter 
%cd Kalman_Filter

%KF_main()

%cd ..

%% Hazard Detection and Avoidance
hazardMapLidar = hazz;
[lidarX, lidarY] = size(hazardMapLidar);
lidarX = 720;
lidarY = 1280;
count = 0; 
%finalHazard = zeros(720,1280);
%finalHazard = zeros(820,1380);
finalHazard = zeros(1000, 2000);


for j = 1:77
    %load data
    shadow_hazard = load([startName, num2str(j), '_shadow', endMatName]);
    shadow_hazard_map = shadow_hazard.shadow_hazard_map;
    cv_hazard = load([startName, num2str(j), '_cv', endMatName]);
    cv_hazard_map = cv_hazard.cv_hazard_map;
    
    %take frame of lidar map
    this_coord = TRN_coords(j,1:2);
    width_x = lidarX * scale_factor;
    width_y = lidarY * scale_factor;
    start_x = round(this_coord(1) - width_x / 2);
    if start_x < 1
        start_x = 1;
    end
    finish_x = round(this_coord(1) + width_x / 2);
    if finish_x > lidarX
        finish_x = lidarX;
    end
    start_y = round(this_coord(2) - width_y / 2);
    if start_y < 1
        start_y = 1;
    end
    finish_y = round(this_coord(2) + width_y / 2);
    if finish_y > lidarY
        finish_y = lidarY;
    end
    if start_x > lidarX
    start_x = 720; 
    end
    
    cd Data
    cd frames
    
    name = ['frame_',num2str(j),'.png'];
    toShow = imread(name);
    
    cd ..
    cd ..
   
    this_frame = hazardMapLidar(start_x:finish_x, start_y:finish_y);
    lidar_hazard_map = imresize(this_frame, [180, 320]);
    %{
    figure,
    subplot(2,1,1)
    imagesc(hazardMapLidar')
    colorbar
    title('hazard map from Lidar data')
    ylabel('y pixels')
    xlabel('x pixels')
    hold on
    plot(this_coord(1), this_coord(2), 'r+')
    hold off
    subplot(2,1,2)
    imagesc(lidar_hazard_map')
    colorbar
    title('saved frame')
    ylabel('y pixels')
    xlabel('x pixels')
    %}
    %Combine hazard maps w/ logical OR
    hazard_map = shadow_hazard_map | cv_hazard_map | lidar_hazard_map;
    h = colorbar;
    set(h, 'ylim', [0 1])
    
    %display combination of hazard maps
    if(1)
        figure
        subplot(3,3,1)
        imagesc(shadow_hazard_map)
        title('shadow based')
        colorbar
        subplot(3,3,2)
        imagesc(cv_hazard_map)
        title('CV')
        colorbar
        subplot(3,3,3)
        imagesc(lidar_hazard_map)
        title('lidar')
        colorbar
        subplot(3,3,4)
        title('combined hazard map')
        imagesc(hazard_map)
        colorbar
        subplot(3,3,5);
        imagesc(toShow)
        title('Subplot 5 and 6: Both')
        
        %Run HDA algorithm
        HDAWrapper(hazard_map, params);
    end
    
    [hazardCurr, update] = make_final_hazard_map(shadow_hazard_map,cv_hazard_map,this_coord,lidar_hazard_map);
    
    if(update)
        count = count + 1;
        finalHazard = finalHazard | hazardCurr;
        
        figure, 
        imagesc(finalHazard)
        colorbar
    end
    
end
%%
figure, 
hold on
imagesc(finalHazard)
xlim([0 720])
ylim([0 1280])
hold off
colorbar

%% Format outputs



