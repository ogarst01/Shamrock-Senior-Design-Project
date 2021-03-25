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

[bound_row, ~] = size(bound_idx);

%Plot boundaries of hazard and shadow on top of original image
figure
imshow(origImage)
hold on
plot(shadowBoundaries(:,2), shadowBoundaries(:,1), '.r', 'MarkerSize', 3)
if bound_row > 0
    plot(bound_idx(:,2), bound_idx(:,1), '.b', 'MarkerSize', 3)
end
hold off
title('Hazard Location Estimate')
end