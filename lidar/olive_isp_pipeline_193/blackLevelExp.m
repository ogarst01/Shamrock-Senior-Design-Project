function [result] = blackLevelExp(img)
%BLACKLEVELEXP Summary of this function goes here
%   Detailed explanation goes here
result = imadjust(img);

% figure(1)
% subplot(2,2,1)
% histogram(rescale(img));
% title('black level before correction')
% xlabel('brightness')
% ylabel('number of pixels')
% subplot(2,2,2)
% histogram(result);
% title('black level after correction')
% xlabel('brightness')
% ylabel('number of pixels')
% subplot(2,2,3)
% imshow(rescale(img))
% subplot(2,2,4)
% imshow(result)
end

