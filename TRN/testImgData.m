clear all
close all

% read in video save images 
filename = 'april5run.mp4';
local_height = 0.33;
global_height = 0.93;
scale_factor = local_height/global_height;
%numPics = GetFramesFromVid(filename, scale_factor);
numPics = 103;
% define global map
%global_map = 'globalMapApril5.png';

global_map = 'april5_global_from_.93m.png';

% resize images based on height of data taken (using LIDAR measurements)
% read in LIDAR height


for i = 1:numPics
    s = sprintf('%d',i);
    local_map = strcat('frame_', s, '.png');
    [time(i), coords(i,:)] = TRN(global_map, local_map)
end