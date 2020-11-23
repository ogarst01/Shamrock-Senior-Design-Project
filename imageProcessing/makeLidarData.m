function [lidar] = makeLidarData(img)

% makes test points in a zig zag pattern, saving time & velocity
% at each point:

% from spec sheet:
% https://leddartech.com/solutions/leddarone/
% up to 40 Hz aquisition time = 40 samples/second
% assumption: moving 0.25 m/s - 40 samples/meter flown
% ~ (1.64 feet/sec)
% weight = 14 g
% UART communication
% accuracy = 5 cm

% assumptions about the set:
% == 1 meter by 3 meters

samplesPerSec = 40;
widthRoom = 1; % m
lengtRoom = 1; % m
vel = 0.25;    % m/s
samplesPerSec = 40; 

sampPerSweep = samplesPerSec*widthRoom/vel;

numSweeps = 30;
% use image of asteroid for real data (use image brightness for example):

% use sample image to make lidar points 
im = imread('imgBennu.jpg');
figure,
imshow(im)
dim = size(im); % 468 468 3

widthResolution = 10; % pixels

%%
% figure,plot3(firstSweep)
%%
sweepNum = 1;

maxLocation = numSweeps*widthResolution;

rowsLidar = linspace(1,round(maxLocation),numSweeps);

numXsamp = 100;
numYsamp = 100;

for i = 1:numXsamp
    for j = 1:numYsamp
        % grabs brightness from that point:
        lidar2(i,j,:) = im(i,j,:);
    end
end

% brightness data = 1 - 255
% expected noise to be from 5 cm for meters, 

% add noise

% denoise 
figure, surf(lidar2(:,:,1));
title('original image')

%lidar = imgaussfilt(lidar,2);

%figure, surf(lidar(:,:,1));

lidarDownSamp =lidar2(1:5:end,1:5:end,1);          % Odd-Indexed Elements
figure, surf(lidarDownSamp(:,:,1));
title('downsampled image')

%%
dim = size(lidarDownSamp)
%%
figure, stem3(lidarDownSamp(:,:,1));
title('downsampled image')
grid on
% probably downsample by a lot for the actua lidar data:

X = 1:dim(1);
Y = 1:dim(2);
V = double(lidarDownSamp(:,:,1)); 

% interpolate every 0.25 instead of every point:
[Xq,Yq] = meshgrid(0:0.25:numYsamp);

Vq = interp2(X,Y,V,Xq,Yq,'cubic');

figure
surf(Xq,Yq,Vq);
title('Cubic Interpolation Over Finer Grid');

lidar = lidar2;

% interpolate using bilinear interpolation
%%
% show results
% plot3(lidar)
end