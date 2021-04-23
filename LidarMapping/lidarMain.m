%main
%{
Senior Design
Team Shamrock
Olive Garst
03/03/21

inputs:
0. M, N - size of the photo to be compared to...
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

%{ TODO: 
% put together something to parse ALL the photos and all the IMU data to 
% add to the number of Lidar points we can use... 
%}
function [hazardMapLidar,xq,yq,vq] = lidarMain(M,N, coords_vec, dateOfRun,glob_map)
%coords_vec = TRN_coords;
% dimensions of images coming in:
[xImg, yImg] = size(glob_map);

cd ..

% first read in the LIDAR data: 
cd Data
cd lidar_data

Lidarfilename = ['april',num2str(dateOfRun),'_run'];
%Lidarfilename = 'april16_run';%DataRunFileName;
[lidar_data, time_data] = processLidarData(Lidarfilename);

lidar_data = lidar_data';

cd ..
cd ..
%% doing some post processing:

% TRN: last points should be at coords: 
% x = 1280
% y = 700 

% add one more point on the end of the lidar data to make it more
% consistent: 
lenL = length(lidar_data);
lidar_data(lenL + 1) = .33; 
% make sure there's no outliers - above 80 is no good (default error value 
% for thius sensor is 81.92.. )
lidar_data(lidar_data > 80) = .33;

% since it's distance measurements, subtract the max to account
% for distance to global height: 
lidar_data = rescale(lidar_data);
lidar_data = 1 - lidar_data;
%%
% USE TRN coords for now: 
Xs = coords_vec(:,1);
Ys = coords_vec(:,2);
Zs = lidar_data;

% add data to the four corners to make sure that the entire area is
% covered: 
xCornersTop    = linspace(0, 1280, 100)';
xCornersBottom = linspace(0, 1280, 100)';
xCornersRights = zeros(100,1);
xCornersLeft   = 1280*ones(100,1);
yCornersTop    = zeros(100,1);
yCornersBottom = 720*ones(100,1);
yCornersRights = linspace(0,720,100)';
yCornersLeft   = linspace(0,720,100)';

xCorners = [xCornersTop; xCornersBottom; xCornersRights; xCornersLeft];
yCorners = [yCornersTop; yCornersBottom; yCornersRights; yCornersLeft];

% add a layer closer to the actual mapping:
CxCornersTop    = linspace(0, 1280, 100)';
CxCornersBottom = linspace(0, 1280, 100)';
CxCornersRights = max(Xs)*ones(100,1);
CxCornersLeft   = min(Ys)*ones(100,1);
CyCornersTop    = max(Ys)*ones(100,1);
CyCornersBottom = min(Ys)*ones(100,1);
CyCornersRights = linspace(0,720,100)';
CyCornersLeft   = linspace(0,720,100)';

xCorners = [xCorners; CxCornersTop; CxCornersBottom; CxCornersRights; CxCornersLeft];
yCorners = [yCorners; CyCornersTop; CyCornersBottom; CyCornersRights; CyCornersLeft];
zCorners = ones(800,1);

Xs = [Xs;xCorners];
Ys = [Ys;yCorners];
Zs = [Zs;zCorners];

% decide which one is longer: 
if(length(Zs) > length(Xs))
    Zs = Zs(1:(length(Xs)));
elseif(length(Zs) < length(Xs))
    Xs = Xs(1:length(Zs));
    Ys = Ys(1:length(Zs));
end
    
figure,
cmp=jet(numel(Zs));
scatter3(Xs,Ys,Zs', 15, cmp);
axis([0, 1280, 0, 720])  
xlabel('x locations')
ylabel('y locations')
zlabel('set height')
title('Lidar point map simulation (real lidar data + simulated position)')
colorbar

%%
% Interpolater part: 
x = Xs;
y = Ys;
z = Zs;

[xq,yq] = meshgrid(0:1:(1280-1), 0:1:(720-1));
vq = griddata(x,y,z,xq,yq);

figure
mesh(xq,yq,vq)
hold on
plot3(x,y,z,'o')
title('interpolated lidar plot')
xlabel('x pixels')
ylabel('y pixels')
zlabel('lidar interpolated height data')
hold off

%%
% initialize: 
hazardMapLidar = zeros(720,1280);
meanVal = mean(lidar_data(:));

for i = 1:(720-1)
    for j = 1:(1280-1)
        if(isnan(vq(i,j)))
            hazardMapLidar(i,j) = 1;
        elseif(vq(i,j) >= meanVal)
            hazardMapLidar(i,j) = 1;
        else
            hazardMapLidar(i,j) = 0;
        end
    end
end

figure,
imagesc(hazardMapLidar)
%axis([0, 1280, 0, 720])  
colorbar
title('hazard map from Lidar data')
ylabel('y pixels')
xlabel('x pixels')

% hazardMapLidar = zeros(720,1280);
xax = linspace(1,720-1,720)';
yas = linspace(1,1280-1,1280)';

figure,
subplot(2,1,1)
imagesc(hazardMapLidar)
colorbar
title('hazard map from Lidar data')
ylabel('y pixels')
xlabel('x pixels')
subplot(2,1,2)
imagesc(glob_map)
title('global map from drone camera')
ylabel('y pixels')
xlabel('x pixels')

hold off

hazardMapLidar = hazardMapLidar';

end
