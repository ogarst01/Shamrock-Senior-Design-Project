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
function [hazardMapLidar,xq,yq,vq] = lidarMain(M,N)

% dimensions of images coming in:
M = 720;
N = 1280;

Lidarfilename = 'lidar2.txt';
IMUfilename = 'IMU_data.txt';

% filename = 'lidar2.txt';
% out = processLidarData(Lidarfilename);
% array = out;
% make up random lidar number of points:
% generates 1000 between .1 and 1 (m)
array = randi(10,1000,1);
array = array./10;

% now fake the IMU data:
Xs = randi(M,1000,1);
Ys = randi(N,1000,1);
Zs = array;

%%
% add some points to the Lidar data - assume the ground is at the outter
% areas of the photo:
%array = [0; array; 0];
%array = array.*100;

% for now use fake IMU data set: 
% filename = 'IMU_data.txt';
%[Xs, Ys, Zs] = processIMUData(IMUfilename,array);

% add origin and M,N point into data: 
%Xs = [0, Xs, M];
%Ys = [0, Ys, N];
%Zs = [0, Zs', 0];

%%

figure,
cmp=jet(numel(Zs))
scatter3(Xs,Ys,Zs', 15, cmp);
colorbar

%% Interpolater part: 
x = Xs;
y = Ys;
z = Zs;

[xq,yq] = meshgrid(0:1:(M-1), 0:1:(N-1));
vq = griddata(x,y,z,xq,yq);

mesh(xq,yq,vq)
hold on
plot3(x,y,z,'o')
title('interpolated lidar plot')
hold off
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
%%
% 
% figure,
% plot3(x,y,gradient(z))
% title('gradient plot')
% 
% figure,
% plot3(x,y,gradient(gradient(z)))
% title('gradient of gradient plot')
% 
% % for now, just grab values over a known threshold as groun as a hazard... 
% gradZ = gradient(z);
% avrgGradZ = mean(gradZ);
% 
% % grab the x highest values of the total dataset: 
% 
% % find the avrg. value in the lidar dataset height. 
% avrgZ = mean(z);
% 
% % also make a histogram of height data to better visualize:
% nbins = 20;
% titleWord = sprintf('histogram of heights of rocks, with mean values of %g',avrgZ);
% 
% figure,
% histogram(z,nbins)
% title(titleWord)
% 
% hazMap = z;
% 
% % first - anything in the top 50% assume that it is a hazard
% hazMap((gradZ) >= avrgGradZ)=1;
% 
% hazMap((hazMap) < 1)=0;
% 
% hazMap((hazMap) > 0.999)=1;
% 
% figure,
% plot3(x,y,hazMap)
% title('hazard map')
% 
% %%
% % make the mesh grid the same size as the photos: 
% [xq,yq] = meshgrid(linspace(0,0.1,M), linspace(0,0.1,N));
% vq = griddata(x,y,hazMap,xq,yq);
% 
% figure,
% mesh(xq,yq,vq)
% hold on
% plot3(x,y,hazMap,'o')
% title('hazard map')
% 
% %%
% % figure,
% % scatter3(x,y,gradZ)
% % title('hazard map')
% %%
% % img = [x,y,gradZ]
% % figure,
% % imshow(img)
% %%
% % hazardMap = [];
% % 
% %     % make the hazard map based on high sloped areas and what's in between
% %     for i = 1:length(Xs)
% %         for j = 1:length(Ys)
% %             if(gradient(z) <= gradThresh)
% %                 % if the slpe is pretty unchanging, then make the color = 
% %                 hazardMap(i,j) = 0;
% %             else
% %                 hazardMap(i,j) = 1;
% %             end
% %         end
% %     end
% 
% % before returning, need to make sure these two hazard maps have the right 
% % matching dimensions... 
% 
% % overlay an mxn pizel grid over the whole hazard map for the right photo 
% % resolution
% 
% % some estimations:
% 
% 
% %end