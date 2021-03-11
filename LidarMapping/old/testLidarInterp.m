% TODO :
%  - add clipping to cubic interpolation result
%  - 
clear;
close all;

% chose how you want to test: 
usingImage = false;
% usingImage = true;

% use actual image -> brightness ~= lidar data (think about this when looking at results!!)
imageName = 'BennuLargestBoulder';

% use manmade rock + cliff data
if(usingImage == false)
    % define test data size: 
    m = 100;
    n = 100;
    
    % make rock (square and circular) and cliff data:
    [lidarRock, lidarGRock] = makeLidarDataRock(m,n);
    lidarCliff = makeLidarDataCliff(m,n);
    
    dimCliff = size(lidarCliff);
    dimCliffR1 = size(lidarRock);
    dimCliffR2 = size(lidarGRock);
    
    % add noise (also tunable)
    power = 1;
    cNoise = wgn(dimCliff(1),dimCliff(2),power);
    sRNoise = wgn(dimCliffR1(1),dimCliffR1(2),power);
    gRNoise = wgn(dimCliffR2(1),dimCliffR2(2),power);
    
    %lidarCliff = lidarCliff + cNoise;
    lidarRock = lidarRock + sRNoise;
    lidarGRock = lidarGRock + gRNoise;
    
    % change below to change which surface you're looking at...
    %lidarTestData = lidarCliff;
    % lidarTestData = lidarGRock;
    lidarTestData = lidarGRock;
else
    % uses the image data as a realistic lidar base... 
    % square percentage of image:
    percent = 50;

    % make the lidar test data: 
    lidarTestData = makeLidarData(percent, imageName);    
end

figure, imshow(lidarTestData), title('lidar test data')

% interpolate the original data using cubic interpolation:
lidarInterp = interpLidar(lidarTestData);

% smooth out data with gaussian filter
lidarSmooth = smooth(double(lidarInterp));
%% USE TWO METHODS TO MAKE HAZARD MAP:
% 1. find edges - 
% use similar approach to image processing: 
imageEdges = multiscaleWavelet(lidarTestData);
figure,
imshow(blackLevelExp(imageEdges))
%%
% 2. use gradients + abrupt slope changes to find hazards...
Kmedian = medfilt2(lidarSmooth);
Kmedian = imgaussfilt(Kmedian, 10);
figure, 
surf(smooth(Kmedian))
shading interp

%%
A = diff(smooth(Kmedian));
A = lidarSmooth;
%end
figure, 
surf(abs(A));
shading interp
title('difference plot')

sizeImg = length(A);
%%
% make a hazard map:
% idea - convolve with a window 5x5 to allow some wiggle room:
if(~usingImage)
    hazardMap = conv2(ones(round(sizeImg*0.3),round(sizeImg*0.3)),abs(A));
else
    hazardMap = imgaussfilt(A, 100);
end

figure, 
surf(hazardMap)
shading interp
title('lidar hazard map from difference calculations')


