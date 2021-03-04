clear;
close all;

% filename = 'dataOutputLidar.rtf';
filename = 'lidar2.txt';
out = processLidarData(filename);
array = out;

% data taken every second 
startTime = 0;

% say that you have IMU data taken every second too...

% model IMU data? 
movingVel = 0.5; 

% vel in x,y coords


len = length(array)
% num sweeps
% ~6 here... code this in later. 
numSweeps = 6; 
%%
% moves left for 10 seconds, 
% rests for 1 second
% moves right for 10 seconds, 
% rests for 1 second
moving_left_swath_x  = -movingVel*ones(1,10);
moving_righ_swath_x  = movingVel*ones(1,10);
movingHorizontal__y  = zeros(1,10);
rest         = 0;

testIMUdata_x = [];
testIMUdata_y = [];

for i = 1:numSweeps/2
    testIMUdata_x  = [testIMUdata_x,moving_left_swath_x,rest,moving_righ_swath_x,rest];
    testIMUdata_y  = [testIMUdata_y,movingHorizontal__y,1,movingHorizontal__y,1];
end
% now that IMU data is generally approximated, assume 1 data point per
% second - or figure out with Sophie the right timing / frequency to take
% data points

% curr location = velocity * 1 second. 

testIMUdata_x = testIMUdata_x(1:length(array));
testIMUdata_y = testIMUdata_y(1:length(array));

currPos = [];
% start at origin.
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