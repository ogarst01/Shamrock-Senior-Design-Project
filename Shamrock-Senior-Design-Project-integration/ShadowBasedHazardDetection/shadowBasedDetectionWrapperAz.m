function hazardMap = shadowBasedDetectionWrapperAz(image, params, showResults)
%{
Senior Design
Team Shamrock
Melissa Rowland
Updated: 3/11/21

inputs: 
image - image of asteroid surface
params - struct containing parameters about simulation
showResults - bool, indicates whether to make an output image with detected
              shadows & hazards

outputs: 
hazardMap - binary hazard map with hazard locations marked as '1', safe
            locations marked as '0'

purpose:
Process image to find significant shadows and output a hazard map of 
hazardous rocks based on those shadows.

Currently: 
-works for any sunlight azimuth angle
-estimates rock location as a rectangle
-assumes shadow region is not hazardous

Future improvements:
-estimate rock location as an ellipse
-improve accuracy of size estimation

%}

%Parameters
smooth_sigma = params.smoothSigma;
shadow_size_threshold = params.shadowSizeThreshold;
sun_vertical_angle = params.sunVerticalAngle;
sun_azimuth_angle = params.sunAzimuthAngle;
height_threshold = params.hazardHeightThreshold; %pixels - TODO convert to m!!

%Image pre-processing: make grayscale, smooth
im_gray = rgb2gray(image);
im_smooth = smooth(im_gray, smooth_sigma);

%Perform multiscale wavelet transform
im_mw = multiscaleWavelet(im_smooth);

%Remove insignificant shadows
[im_shadows, shadow_info, connected] = findShadows(im_mw, shadow_size_threshold, false);

%Initialize matrices
%todo initialize shadow info mat
[info_rows, ~] = size(shadow_info);
hazardMap = zeros(size(im_shadows));
mapSize = size(hazardMap);

%Find boundaries of shadows
im_bound = findBoundaries(im_shadows, false, connected);

%Loop over all significant shadows
for i = 1:info_rows
    %Pull out the info about this shadow
    this_mark = shadow_info(i,1);
    this_shadow_bound = im_bound(im_bound(:,3) == this_mark,:);
    
    %Find line thru average point of shadow at angle
    avg_x = round(mean(this_shadow_bound(:,1)));
    avg_y = round(mean(this_shadow_bound(:,2)));
    [m1, b1] = computeLine(sun_azimuth_angle, [avg_x, avg_y]);
    v1 = [1, m1 + b1];
    v2 = [mapSize(1), mapSize(1) * m1 + b1];
    
    %Find perpendicular line thru average point
    [m2, ~] = computeLine(sun_azimuth_angle + 180, [avg_x, avg_y]);
    
    %Compute shadow length along line
    [shadow_size, min_point, max_point] = computeShadowSizeAz(this_shadow_bound, v1, v2);
    
    %Estimate object size
    %Currently outputs in pixels - TODO convert to m
    [diameter, height] = computeRockSize(shadow_size, sun_vertical_angle);
    
    %Make hazard map
    hazardMap = mapRocksAz(this_shadow_bound, height, diameter, sun_azimuth_angle, height_threshold, hazardMap, m1, m2, min_point, max_point, im_gray);
end

%Display results if desired
if showResults
    displayShadowsAndHazards(image, im_bound, hazardMap);
end

end