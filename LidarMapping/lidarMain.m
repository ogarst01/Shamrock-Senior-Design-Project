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
function [hazardMapLidar,xq,yq,vq] = lidarMain(M,N, coords)

% dimensions of images coming in:
M = 720;
N = 1280;

cd ..

% first read in the LIDAR data: 
cd Data
cd lidar_data

Lidarfilename = 'april5_run1';
[lidar_data, time_data] = processLidarData(Lidarfilename);

lidar_data = lidar_data'

cd ..

%% make sure there's no outliers - above 80 is no good (default error value 
% for thius sensor is 81.92.. )
lidar_data(lidar_data > 80) = 0;
%%
% USE TRN coords for now: 
Xs = coords(:,1);
Ys = coords(:,2);
Zs = lidar_data;

%%

figure,
cmp=jet(numel(Zs))
scatter3(Xs,Ys,Zs', 15, cmp);
xlabel('x locations')
ylabel('y locations')
zlabel('set height')
title('Lidar point map simulation (real lidar data + simulated position)')
colorbar

%% Interpolater part: 
x = Xs;
y = Ys;
z = Zs;

z(z > 0.5) = mean(z);


[xq,yq] = meshgrid(0:1:(M-1), 0:1:(N-1));
vq = griddata(x,y,z,xq,yq);

figure
mesh(xq,yq,vq)
hold on
plot3(x,y,z,'o')
title('interpolated lidar plot')
hold off
%% Less Aggressive Interpolater part: 
x = Xs;
y = Ys;
z = Zs;

[xq,yq] = meshgrid(linspace(0,M-1,M*0.5), linspace(0,(N - 1),N*0.5));
vq = griddata(x,y,z,xq,yq);

figure,
mesh(xq,yq,vq)
hold on
plot3(x,y,z,'o')
title('interpolated lidar plot')
hold off

%%
graz = gradient(vq);
grazGraz = gradient(graz);


% play around with the gradients: 
figure,
plot3(xq,yq,graz)
title('gradient plot')
%%
figure,
[dfdx,dfdy] = gradient(vq);

% varies the surface of the plot based on gradient instead 
% of the value: 
%https://www.mathworks.com/matlabcentral/answers/414044-surfplot-with-surface-color-as-a-function-of-gradient-slope
h = surf(xq,yq,vq,sqrt(dfdx.^2 + dfdy.^2))
get(h)
set(h, 'linestyle','none');
% light
colorbar
title('gradient of lidar point cloud')
xlabel('x value')
ylabel('y value')
zlabel('gradient of lidar data')


figure, 
surf(xq,yq,sqrt(dfdx.^2 + dfdy.^2))
%%
% initialize: 
hazardMapLidar = zeros(1280,720);
meanVal = mean(array(:));

for i = 1:N
    for j = 1:M
        if(isnumeric(vq(i,j) == 0))
            hazardMapLidar(i,j) = 0;
        elseif(vq(i,j) >= meanVal)
            % hazard detected: 
            hazardMapLidar(i,j) = 1;
        else
            hazardMapLidar(i,j) = 0;
        end
    end
end
%%
figure,
imagesc(hazardMapLidar')
axis([0, N, 0, M])  
title('hazard map from Lidar data')

hazardMapLidar = hazardMapLidar';

end
