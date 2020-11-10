function downsampled = makingLidarData(filename,var_gauss)
% load actual image of asteroid:
%img = imread('new-f-comet-67P-1.jpg');

img = imread(filename);
sigma = 2;
blurred = imgaussfilt3(img,2);
imshow(blurred); 

% take this to be lidar data: 
lidar = blurred(:,:,1);
 
figure,
mesh(lidar);

% more realistic: take samples 
downsampled = imresize(lidar, 0.1, 'bilinear') %bilinear interpolation

% add noise to make more realistic:
m = 0;
noise = imnoise(downsampled,'gaussian',m,var_gauss);

figure,
mesh(noise);

end