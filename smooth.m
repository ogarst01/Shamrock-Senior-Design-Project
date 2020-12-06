function smoothImage = smooth(image)
%{
Senior Design
Team Shamrock
Melissa Rowland
12/6/20

smooth
inputs:
outputs:
purpose:

questions/future improvements:
-explore edge-preserving filtering options in Image Processing Toolbox
-experiment with various sigma values

%}

sigma = 1; %tune for amount of smoothing

smoothImage = imgaussfilt(image, sigma);

end