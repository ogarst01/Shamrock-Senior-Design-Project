function smoothImage2 = smooth(image)
%{
Senior Design
Team Shamrock
Melissa Rowland
12/6/20
smooth
inputs: image - image to be smoothed
outputs: smoothImage - smoothedVersion of image
purpose: Smooth out noise in an image.
questions/future improvements:
-explore edge-preserving filtering options in Image Processing Toolbox
-experiment with various sigma values
%}
sigma = 1;

%Use 2D Gaussian smoothing kernel
smoothImage2 = imgaussfilt(image, sigma);

end