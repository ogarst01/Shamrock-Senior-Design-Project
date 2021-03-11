%main
%{
Senior Design
Team Shamrock
Olive Garst
03/03/21

inputs:
1. raw text files of Lidar + IMU data
2. coordinates of data aquisition based on IMU data (velocity + time)
3. information about time stamps list for when photos were taken ... 

outputs:
1. hazard map showing which data points are hazardous 
2. overlayed hazard 

purpose:
Compute the distance to a hazard at all locations in the image frame. A
distance of '0' indicates that the cell is a hazard. Utilizes the grassfire
transform. See: https://en.wikipedia.org/wiki/Grassfire_transform for basic
algorithm.

questions/future improvements:
-is there a faster/less computationally expensive algorithm that can be
implemented?
%}
clear;
close all;

filename = 'lidar2.txt';
out = processLidarData(filename);
array = out;

% for now use fake IMU data set: 
filename = 'IMU_data.txt';
out2 = processIMUData(filename,array);
imu_accel = out2;

% start at origin.
currPos = [];
currX = 0;
currY = 0;

for i = 3:length(array)
    % update current position using time + velocity data:
    currX = double(testIMUdata_x(i) + currX)
    currY = double(testIMUdata_y(i) + currY)
    currZ = double(array(i))
    
    if(currZ == NaN)
        currZ = 0;
    end
    
    Xs(i) = currX;
    Ys(i) = currY;
    Zs(i) = currZ;
    
end
% for i = 1:length(testIMUdata_x)
%%
close all

figure,
%scatter3(Xs,Ys,Zs)
cmp=jet(numel(Zs))
scatter3(Xs,Ys,Zs, 15, cmp);
colorbar

%% Interpolater part: 
x = Xs;
y = Ys;
z = Zs;

[xq,yq] = meshgrid(-10:.2:10, -10:.2:10);
vq = griddata(x,y,z,xq,yq);

mesh(xq,yq,vq)
hold on
plot3(x,y,z,'o')
title('interpolated lidar plot')

%%

figure,
plot3(x,y,gradient(z))
title('gradient plot')

figure,
plot3(x,y,gradient(gradient(z)))
title('gradient of gradient plot')

% for now, just grab values over a known threshold as groun as a hazard... 
gradZ = gradient(z);
gradThresh = 0.1;

% grab the x highest values of the total dataset: 

% find the avrg. value in the lidar dataset height. 
avrgZ = mean(z);

% also make a histogram of height data to better visualize:
nbins = 20;
titleWord = sprintf('histogram of heights of rocks, with mean values of %g',avrgZ)

figure,
histogram(z,nbins)
title(titleWord)

% first - anything in the top 50% assume that it is a hazard
gradZ((gradZ) >= 0.75*avrgZ)=1;

gradZ((gradZ) < 1)=0;

% these values are safe. 
% 
% gradZ(abs(gradZ)<= gradThresh)=0;
% 
% gradZ(abs(gradZ) > gradThresh)=1;

[xq,yq] = meshgrid(-10:.2:10, -10:.2:10);
vq = griddata(x,y,gradZ,xq,yq);

figure,
mesh(xq,yq,vq)
hold on
plot3(x,y,gradZ,'o')
title('hazard map')

%%
% figure,
% scatter3(x,y,gradZ)
% title('hazard map')
%%
% img = [x,y,gradZ]
% figure,
% imshow(img)
%%
hazardMap = [];

% make the hazard map based on high sloped areas and what's in between
for i = 1:length(testIMUdata_x)
    for j = 1:length(testIMUdata_y)
        if(gradient(z) <= gradThresh)
            % if the slpe is pretty unchanging, then make the color = 
            hazardMap(i,j) = 0;
        else
            hazardMap(i,j) = 1;
        end
    end
end
% %%
% 
% figure,
% imagesc(gradZ)