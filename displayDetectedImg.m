function [tempimg,hazardMap] = displayDetectedImg(filename,bThres,SRThres,hMap)
load('frameBoulderDetector.mat')
load('frameSRDetector.mat')

cd frames 
img = imread(filename);

[bboxesBoulder,scoresBoulder] = detect(acfBoulderDetector,img);
[bboxesSR,scoresSR] = detect(acfSRDetector,img);

[w,l,~] = size(img);
hazardMap = zeros(w,l);
tempimg = img;


thresholdB = max(scoresBoulder)*bThres;
thresholdSR = max(scoresSR)*SRThres;
for i = 1:length(scoresBoulder)
   if(scoresBoulder(i) > thresholdB)
    currbbox(1,:) = bboxesBoulder(i,:);
    hazardMap(currbbox(2):currbbox(2)+currbbox(4),currbbox(1):currbbox(1)+currbbox(3)) = 1;
    annotation = sprintf('Boulder: Confidence = %.1f',scoresBoulder(i));
    tempimg = insertObjectAnnotation(tempimg,'rectangle',bboxesBoulder(i,:),annotation);
   end
end

for i = 1:length(scoresSR)
   if(scoresSR(i) > thresholdSR)
    currbbox(1,:) = bboxesSR(i,:);
    hazardMap(currbbox(2):currbbox(2)+currbbox(4),currbbox(1):currbbox(1)+currbbox(3)) = 1;   
    annotation = sprintf('SmallRock: Confidence = %.1f',scoresSR(i));
    tempimg = insertObjectAnnotation(tempimg,'rectangle',bboxesSR(i,:),annotation);
   end
end
% 
% figure
% imshow(tempimg)
hazardMap = hazardMap(1:w,1:l) + hMap;
cd .. 
end

