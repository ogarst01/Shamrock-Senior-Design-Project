function hazardMap = boulderDetectFunc(testImage, params)
% function hazardMap = boulderDetect(testImage,acfBoulderDetector,acfSRDetector, thresholdB, thresholdSR)
% Description: This function takes in pre-trained detectors and a test
% image, and outputs a hazard map of the area based on the detected boulder and small rock area
%
% Note: Input from params
%            - boulderDetectorThreshold: the threshold to use for the boulder detector
%            - smallRockDetectorThreshold: the threshold to use for the small rock detector 
%            - Both are a number, n, between 0 - 100, n means that the
%            detector is n% confident about the detection
%            - boulderDetectorString: path/title of boulder detector to use
%            - smallRockDetectorString: path/title of small rock detector to use

cd ..
cd ..
cd ComputerVision
cd BoulderDetect
%load(params.boulderDetectorString)
load('boulderDetector.mat')
%load(params.smallRockDetectorString)
load('SRDetector.mat')

cd ..
cd ..
cd Data
cd frames 

img_lab = rgb2lab(testImage);


max_luminosity = 100;
L = img_lab(:,:,1)/max_luminosity;


img_imadjust = img_lab;
img_imadjust(:,:,1) = imadjust(L)*max_luminosity;
img_imadjust = lab2rgb(img_imadjust);

img_histeq = img_lab;
img_histeq(:,:,1) = histeq(L)*max_luminosity;
img_histeq = lab2rgb(img_histeq);
img_adapthisteq = img_lab;
img_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity;
img_adapthisteq = lab2rgb(img_adapthisteq);

%montage({X,img_imadjust,img_histeq,img_adapthisteq},'Size',[1,4]);

[w,l,~] = size(testImage);
hmap = zeros(w,l);

h1 = getHazardMap(testImage,params,.7,.7,hmap);
% figure();
% imshow(tmp1);

h2 = getHazardMap(img_imadjust,params,.7,.7,h1);
% figure();
% imshow(tmp2);

h3 = getHazardMap(img_histeq,params,.87,.87,h2);
% figure();
% imshow(tmp3);

h4 = getHazardMap(img_adapthisteq,params,.87,.9,h3);
% figure();
% imshow(tmp4);

hazardMap = (h4>2);
end