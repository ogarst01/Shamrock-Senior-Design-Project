function smoothImage = smooth(image, sigma)
%{
Senior Design
Team Shamrock
Melissa Rowland
12/6/20

smooth
inputs: 
image - image to be smoothed
sigma - sigma value for smoothing
outputs: smoothImage - smoothedVersion of image
purpose: Smooth out noise in an image.

questions/future improvements:
-explore edge-preserving filtering options in Image Processing Toolbox
-experiment with various sigma values
%}

%Use 2D Gaussian smoothing kernel
smoothImage = imgaussfilt(image, sigma);

end