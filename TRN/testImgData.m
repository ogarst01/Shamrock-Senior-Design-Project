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
global_map_name = 'globalMapApril5.png';

% resize images based on height of data taken (using LIDAR measurements)
% read in LIDAR height

global_map = imread(global_map_name);
global_map = imrotate(global_map,180);
global_map = rescale(rgb2gray(global_map));
% figure
% imshow(global_map)
% hold on

time = 0;
for i = 1:numPics
    s = sprintf('%d',i);
    local_map = strcat('frame_', s, '.png');
    [time, coords, locRows, locCols] = TRN(global_map_name, local_map, time)
    coords_vec_x(i,1:2) = coords;
    coords_vec_x(i,3) = time;
    figure
    cd images
    local_map = imread(local_map);
    local_map = rescale(rgb2gray(local_map));
    imshow(local_map)
    cd ..
    figure
    imshow(global_map)
    hold on
    rectangle('position',[coords(2) coords(1) locCols locRows],'edgecolor','r','LineWidth',2)
    plot(coords(2), coords(1), 'bx', 'MarkerSize', 5, 'LineWidth', 2);
    hold on
end

