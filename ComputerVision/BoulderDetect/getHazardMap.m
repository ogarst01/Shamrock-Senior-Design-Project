function hazardMap = getHazardMap(img,params,bThres,SRThres,hMap)
% function hazardMap = getHazardMap(img,params,bThres,SRThres,hMap)
% Description: The function takes in the pretrained detector and 
% the test image, indentifies the hazard in the image and 
% outputs the cumulative hazard map 

load(params.boulderDetectorString)
load(params.smallRockDetectorString)

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


end

