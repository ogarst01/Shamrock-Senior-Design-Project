function displayShadowsAndHazards(origImage, shadowBoundaries, hazardMap)
%{
Senior Design
Team Shamrock
Melissa Rowland
3/6/21

inputs: 
origImage - the original image
shadowBoundaries - boundary pixels of shadows in image
hazardMap - binary map of hazard locations. '1' marks hazard, '0' marks
            safe

outputs:
none

purpose:
Make an output image that displays the detected significant shadows & 
hazard locations overlaid onto the original image.

%}

%Convert hazard map to binary image to reuse findBoundaries function
hazard_image = hazardMap;
hazard_image(hazardMap == 1) = 0;
hazard_image(hazardMap == 0) = 256;
bound_idx = findBoundaries(hazard_image, false, []);

%Plot boundaries of hazard and shadow on top of original image
figure
imshow(origImage)
hold on
plot(shadowBoundaries(:,1), shadowBoundaries(:,2), '.r', 'MarkerSize', 3)
plot(bound_idx(:,1), bound_idx(:,2), '.b', 'MarkerSize', 3)
hold off
title('Hazard Location Estimate')
end