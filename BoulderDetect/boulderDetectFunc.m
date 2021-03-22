function hazardMap = boulderDetectFunc(testImage,acfBoulderDetector,acfSRDetector, thresholdB, thresholdSR)
% function hazardMap = boulderDetect(testImage,acfBoulderDetector,acfSRDetector, thresholdB, thresholdSR)
% Description: This function takes in pre-trained detectors and a test
% image, and outputs a hazard map of the area based on the detected boulder and small rock area
%
% Note: Input- thresholdB: the threshold to use for the boulder detector
%            - thresholdSR: the threshold to use for the small rock detector 
%            - Both are a number, n, between 0 - 100, n means that the
%            detector is n% confident about the detection

img = imread(testImage);

[bboxesBoulder,scoresBoulder] = detect(acfBoulderDetector,img);
[bboxesSR,scoresSR] = detect(acfSRDetector,img);

tempimg = img;
for i = 1:length(scoresBoulder)
    if(scoresBoulder(i) > thresholdB)
        annotation = sprintf('Boulder: Confidence = %.1f',scoresBoulder(i));
        tempimg = insertObjectAnnotation(tempimg,'rectangle',bboxesBoulder(i,:),annotation);
    end
end

for i = 1:length(scoresSR)
    if(scoresSR(i) > thresholdSR)
        
        annotation = sprintf('SmallRock: Confidence = %.1f',scoresSR(i));
        tempimg = insertObjectAnnotation(tempimg,'rectangle',bboxesSR(i,:),annotation);
    end
end

figure
imshow(tempimg)

% Create Hazard Map
[w,l,~] = size(img);
hazardMap = zeros(w,l);

for i = 1:length(scoresBoulder)
    if(scoresBoulder(i) > thresholdB)
        currbbox(1,:) = bboxesBoulder(i,:);
        hazardMap(currbbox(2):currbbox(2)+currbbox(4),currbbox(1):currbbox(1)+currbbox(3)) = 1;
    end
end

for i = 1:length(scoresSR)
    if(scoresSR(i) > thresholdSR)
        currbbox(1,:) = bboxesSR(i,:);
        hazardMap(currbbox(2):currbbox(2)+currbbox(4),currbbox(1):currbbox(1)+currbbox(3)) = 2;
    end
end


%%image(hazardMap);


end