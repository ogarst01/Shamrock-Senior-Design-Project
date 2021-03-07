%% 
clear all
load('gTruth0217.mat')
currLabelData = gTruth.LabelData;
currDataSource = gTruth.DataSource;

ImageFileName = currDataSource.Source;
small_rock = currLabelData.small_rock;
smoothLand = currLabelData.smoothLand;
boulder = currLabelData.boulder_rect;

boulderAndLand = table(ImageFileName,boulder,small_rock,smoothLand);
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

%%
clear all
load('miniset_gTruth.mat')
currLabelData = gTruth.LabelData;
currDataSource = gTruth.DataSource;

ImageFileName = currDataSource.Source;
boulder = currLabelData.Boulder;

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

%%
NonBoulderImages = imageDatastore('Negative');

%%
% trainCascadeObjectDetector('boulderDetector.xml',boulderLoc, ...
%     NonBoulderImages,'FalseAlarmRate',0.1,'NumCascadeStages',5);

trainCascadeObjectDetector('miniSet.xml',boulderLoc, ...
    NonBoulderImages,'FalseAlarmRate',0.1,'NumCascadeStages',5);

%%
BoulderDetector = vision.CascadeObjectDetector('miniSet.xml');

%%
%img = imread('20190329-Northern-Sample-Site-Candidate.png');

img = imread('Nightingale.png');


%%
bboxes = BoulderDetector(img);

%%
IBoulder = insertObjectAnnotation(img,'rectangle',bboxes,'boulder');   
figure
imshow(IBoulder)
title('Detected boulders');


