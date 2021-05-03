%{
Senior Design
Team Shamrock
Melissa Rowland
Updated: 4/11/21

testAzimuthAngle
Test script for detecting rocks in an image using wavelet transform to get
clear shadows, and then computing rock location based on those shadows.
Working on expanding rock placement to be based on light coming in from any
angle.
%}

clear all
close all

%Parameters
smooth_sigma = 2;
shadow_size_threshold = 250;
sun_vertical_angle = 45;
sun_azimuth_angle = 135;
sun_dir = 'top';
height_threshold = 0;

%Image processing
im = imread('../test_images/BennuLargestBoulder.png');
im_small = imresize(im, 1/2);
im_gray = rgb2gray(im_small);
im_smooth = smooth(im_gray, smooth_sigma);
im_mw = multiscaleWavelet(im_smooth);
[im_shadows, shadow_info, connected] = findShadows(im_mw, shadow_size_threshold, false);

%Find boundaries of shadows
im_bound = findBoundaries(im_shadows, false, connected);

[info_rows, info_cols] = size(shadow_info);
mapSize = size(im_shadows);
hazardMap = zeros(mapSize);
%Loop over all significant shadows
for i = 1
    %Pull out the info about this shadow
    this_mark = shadow_info(i,1);
    this_shadow_bound = im_bound(im_bound(:,3) == this_mark,:);
    
    %Find line thru average point of shadow at angle
    avg_x = round(mean(this_shadow_bound(:,1)));
    avg_y = round(mean(this_shadow_bound(:,2)));
    [m1, b1] = computeLine(sun_azimuth_angle, [avg_x, avg_y]);
    v1 = [1, m1 + b1];
    v2 = [mapSize(1), mapSize(1) * m1 + b1];
    %{
    figure
    hold on
    plot([v1(1), v2(1)], [v1(2), v2(2)], 'g')
    plot(avg_x, avg_y, 'rx')
    hold off
    %}
    
    %Find perpendicular line thru average point
    [m2, b2] = computeLine(sun_azimuth_angle + 180, [avg_x, avg_y]);
    
    %Compute shadow length along line
    [shadow_size, min_point, max_point] = computeShadowSizeAz(this_shadow_bound, v1, v2);
    
    %verify line goes thru avg point
    %{
    figure
   imshow(im_small)
   axis on
   hold on
   plot([v1(1), v2(1)], [v1(2), v2(2)], 'g')
   plot(avg_x, avg_y, 'rx')
   plot(this_shadow_bound(:,1), this_shadow_bound(:,2), 'y.', 'MarkerSize', 1)
   plot(min_point(1), min_point(2), 'bx');
   plot(max_point(1), max_point(2), 'cx');
    %}
    
    %Estimate object size
    %Currently outputs in pixels - TODO convert to m
    [diameter, height] = computeRockSize(shadow_size, sun_vertical_angle);
    
    %Make hazard map
    hazardMap = mapRocksAz(this_shadow_bound, height, diameter, sun_azimuth_angle, height_threshold, hazardMap, m1, m2, min_point, max_point, im_small);
end

displayShadowsAndHazards(im_small, im_bound, hazardMap);

