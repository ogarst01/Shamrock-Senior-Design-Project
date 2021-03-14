%function [img, time] = makeEmoji(inputArg1,inputArg2)
% Load in movie file (TBD): 

cd ..
cd Data

filename = 'IMG_5472.MOV';

v = VideoReader(filename);

%%

cd .. 
cd VideoCleanup

filenameBeg = 'frame_';
filenameEnd = '.png';

frame = v.read();

% number of frames grabbed 
Fs = 1000;

for i = 1:10
    img = frame(:,:,:,13*i);

    % make single channeled 
    img = rgb2gray(img);

    sz = size(img);
    emojiPic = sz;

    % iphone video yields 1-256 points: 
    finalMax1 = max(img(:,:,:))

    % split into 8 quantization levels: 
    thresh = multithresh(img,7);

    valuesMax = [thresh max(img(:))];

    [quant8_I_max, index] = imquantize(img,thresh,valuesMax);

    figure,
    imshow(quant8_I_max)

    FileName=[filenameBeg,num2str(i),filenameEnd];
    
    cd frames; 
    
    imwrite(quant8_I_max,FileName)
    
    cd ..
    
    BW = imbinarize(img); 
    CC = bwconncomp(BW);
    L = labelmatrix(CC);
end
%end