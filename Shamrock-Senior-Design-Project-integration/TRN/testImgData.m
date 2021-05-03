clear all
close all

% read in video save images 
filename = 'april5run.mp4';
local_height = 0.33;
global_height = 0.93;
scale_factor = local_height/global_height;
%numPics = GetFramesFromVid(filename, scale_factor);

% count the number of files in the frames directory: 
yourfolder = '/Users/Olive/Documents/MATLAB/seniorDesign/Shamrock-Senior-Design-Project/Data/frames';
numPics = dir([yourfolder '/*.png'])
numPics = length(numPics)

% or hard coded options:
%numPics = 103;
%numPics = 515;

%%

%global_map = 'globalMapApril5.png';

global_map = 'april5_global_from_.93m.png';

% resize images based on height of data taken (using LIDAR measurements)
% read in LIDAR height

coords_vec = [];
time = 0;
%%
% we know we start from the top right corner, so feed that value in...
prev_coord_x = 0;
prev_coord_y = 812;

for i = 1:4
    coords_vec(i,3) = time;
    s = sprintf('%d',i);
    local_map = strcat('frame_', s, '.png');
    [time, coords] = TRN(global_map, local_map, time, prev_coord_x, prev_coord_y);
    coords_vec(i,1:2) = coords;
    prev_coord_x = coords(1);
    prev_coord_y = coords(2);
end

%% SAVE THE DATA: 
save('TRN_cord_april5_run.mat','coords_vec');

%%
figure,
hold on
imagesc(imread('april5_global_from_.93m.png'))
line([coords_vec(:,2)'],[coords_vec(:,1)'],'Color','r', 'LineWidth',4)
title('location of coordinates')
hold off