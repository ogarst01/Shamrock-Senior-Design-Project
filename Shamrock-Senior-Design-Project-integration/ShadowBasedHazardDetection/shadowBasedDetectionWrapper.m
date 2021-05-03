function hazardMap = shadowBasedDetectionWrapper(image, params, showResults)
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
-only works for sunlight coming straight from top/bottom/left/right of
image
-estimates rock location as a rectangle
-assumes shadow region is also hazardous

Future improvements:
-compute rock location for sunlight coming from angle
-estimate rock location as an ellipse
-improve accuracy of size estimation

%}

%Parameters
smooth_sigma = 2;
shadow_size_threshold = 250;
sun_vertical_angle = params.sunVerticalAngle;
sun_dir = params.sunDirection;
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
[info_rows, info_cols] = size(shadow_info);
hazardMap = zeros(size(im_shadows));

%Find boundaries of shadows
im_bound = findBoundaries(im_shadows, false, connected);

%Loop over all significant shadows
for i = 1:info_rows
    %Compute shadow lengths
    this_mark = shadow_info(i,1);
    this_idx = find(im_bound(:,3) == this_mark);
    shadow_info(i, info_cols+1) = computeShadowSize(im_bound(im_bound(:,3) == this_mark,:), sun_dir);
    
    %Estimate object size
    %Currently outputs in pixels - TODO convert to m
    [diameter, height] = computeRockSize(shadow_info(i,5), sun_vertical_angle);
    shadow_info(i,6) = round(diameter);
    shadow_info(i,7) = round(height);
    
    %Make hazard map
    hazardMap = mapRocks(im_bound(im_bound(:,3) == this_mark,:), height, diameter, height_threshold, sun_dir, hazardMap);
end

%5th col of shadow info -- shadow size
%6th col of shadow info -- shadow diameter
%7th col of shadow info -- shadow height

%Display results if desired
if showResults
    displayShadowsAndHazards(image, im_bound, hazardMap);
end

end