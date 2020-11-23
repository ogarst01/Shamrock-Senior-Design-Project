%% Shadow Detection Source Code
% Shared by Beril Sirmacek
% For Academic & Educational Usage Only
% Please consider citing following reference articles.
% 
% B. Sirmacek and C. Unsalan, "Damaged Building Detection in Aerial Images 
% using Shadow Information", 4th International Conference on Recent Advances 
% in Space Technologies RAST 2009, Istanbul, Turkey, June 2009.
%
% C. Unsalan and K. L. Boyer, "Linearized vegetation indices based on a formal 
% statistical framework," IEEE Transactions on Geoscience and Remote Sensing, 
% vol. 42, pp. 1575-1585, 2004. 

%%
%clear all
%close all
%clc

%% Read Images:
%im = imread('phoneImg.jpg');
im = imread('easyRock.jpg');
%im = imread('shdowPhoto.jpg');
%im = imread('im1.jpg');
figure, imshow(im);
% find the darkest parts of the image:
figure,
h = histogram(im(:,:,1));

sizeI = size(im);

for i = 1:sizeI(1)
    for j = 1:sizeI(2)
        %if (im(i,j,1) <= 40)
        if (im(i,j,1) <= 100)
            shadowMap(i,j,1) = 0;
        else
            shadowMap(i,j,1) = 1;
        end
    end
end
%
figure,
imshow(shadowMap)
title('shadow map')
%%
% blur photo:
sigma = 100;
im = imgaussfilt(im,sigma);

figure,
imshow(im)

% NOTE: You might need different median filter size for your test image.
r = medfilt2(double(im(:,:,1)), [3,3]); 
g = medfilt2(double(im(:,:,2)), [3,3]);
b = medfilt2(double(im(:,:,3)), [3,3]);

%% Calculate Shadow Ratio:

shadow_ratio = ((4/pi).*atan(((b-g))./(b+g)));
figure, imshow(shadow_ratio, []); colormap(jet); colorbar;

%%
% NOTE: You might need a different threshold value for your test image.
% You can also consider using automatic threshold estimation methods.
shadow_mask = shadow_ratio>0.2;
figure, imshow(shadow_mask, []); 

shadow_mask(1:5,:) = 0;
shadow_mask(end-5:end,:) = 0;
shadow_mask(:,1:5) = 0;
shadow_mask(:,end-5:end) = 0;

% NOTE: Depending on the shadow size that you want to consider,
% you can change the area size threshold
%shadow_mask = bwareaopen(shadow_mask, 10)
[x,y] = find(imdilate(shadow_mask,strel('disk',0.1)));

figure, imshow(im); hold on,
plot(y,x,'.b'), title('Shadow Boundaries');

%% ok new approach this isn't working:
% find the darkest parts of the image:
figure,
h = histogram(im(:,:,1));
