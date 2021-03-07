%%
%Load ground truth data 
load('miniSet_gTruth.mat')

currLabelData = gTruth.LabelData;
currDataSource = gTruth.DataSource;

ImageFileName = currDataSource.Source;
smallRock = currLabelData.smallRock;
boulder = currLabelData.boulder;

Index = 1;
for i = 1:length(ImageFileName)
    [num,~] = size(boulder{i});
    for j = 1:num
        boulderLocFileName(Index) = ImageFileName(i);
        boulderLocData{Index} = boulder{i}(j,:);
        Index = Index +1;
    end
    
end

boulderLoc = table(boulderLocFileName',boulderLocData');

acfBoulderDetector = trainACFObjectDetector(boulderLoc,'NegativeSamplesFactor',2);
%%
Index = 1;
for i = 1:length(ImageFileName)
    [num,~] = size(smallRock{i});
    for j = 1:num
        srLocFileName(Index) = ImageFileName(i);
        srLocData{Index} = smallRock{i}(j,:);
        Index = Index +1;
    end
    
end

srLoc = table(srLocFileName',srLocData');

acfSRDetector = trainACFObjectDetector(srLoc,'NegativeSamplesFactor',2);

%%
img = imread('miniset_test_image2.jpeg');

[bboxesBoulder,scoresBoulder] = detect(acfBoulderDetector,img);
[bboxesSR,scoresSR] = detect(acfSRDetector,img);

%%
tempimg = img;
thresholdB = 30;
thresholdSR = 60;
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

