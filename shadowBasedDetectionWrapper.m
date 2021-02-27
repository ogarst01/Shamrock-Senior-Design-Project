function hazardMap = shadowBasedDetectionWrapper(image)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/27/21

inputs: 
image - image of asteroid surface

outputs: 
hazardMap - binary hazard map with hazard locations marked as '1', safe
            locations marked as '0'

purpose:
Process image to find significant shadows and output a hazard map of 
hazardous rocks based on those shadows.

Currently: 
-only works for one shadow
-only works for sunlight coming straight from bottom of image
-estimates rock location as a square

Future improvements:
-compute rock locations for multiple shadows
-compute rock location for sunlight coming from all 4 straight directions
-compute rock location for sunlight coming from angle
-estimate rock location as an ellipse
-improve accuracy of size estimation

%}

%Parameters
smooth_sigma = 2;
shadow_size_threshold = 500;
%In future, pass in the following from param struct in main
sun_vertical_angle = 20; %degrees
sun_dir = 'south';
height_threshold = 15; %pixels - TODO convert to m!!

%Image pre-processing: make grayscale, smooth
im_gray = rgb2gray(image);
im_smooth = smooth(im_gray, smooth_sigma);

%Perform multiscale wavelet transform
im_mw = multiscaleWavelet(im_smooth);

%Remove insignificant shadows
im_shadows = findShadows(im_mw, shadow_size_threshold, false);
%Currently for testing -- 
%Manually remove object that shows up as shadow from blender image
im_shadows2 = removeShadow([258, 230], im_shadows);

%Find boundaries of shadow & compute its length
im_bound = findBoundaries(im_shadows2, false);
shadow_length = computeShadowSize(im_bound, 'y');

%Estimate object size
%Currently outputs in pixels - TODO convert to m
[diameter, height] = computeRockSize(shadow_length, sun_vertical_angle);
diameter = round(diameter);
height = round(height);

%Make hazard map
hazardMap = zeros(size(im_shadows));
%Apply threshold to determine if rock is hazardous
if height > height_threshold
    hazardMap = mapRocks(im_bound, diameter, sun_dir, size(hazardMap));
end

end