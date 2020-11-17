%{
Senior Design
Team Shamrock
Melissa Rowland
11/9/20

testHDA1
Test script for hazard detection & avoidance algorithm (first attempt -
HDA1).

%}

clear all
close all

%Set parameters
n = 1024; %pixels
m = 1024; %pixels
minHazSize = 5; %square pixels
maxHazSize = 100; %square pixels
numHaz = 30;
landerFootprint = 10; %square pixels

%Generate random hazard map and plot it
map = GenerateHazardMap(n,m,numHaz,minHazSize,maxHazSize);
figure
imMap = map * 256;
image(imMap)
title('Hazard Map')

%Run HDA algorithm
[xChosen, yChosen, DTNHmap] = HDA1(map, landerFootprint);

%Plot distance to nearest hazard map
figure
image(DTNHmap)
title('DTNH Map')

%Plot DTNH map with marker for chosen site
figure
image(DTNHmap)
hold on
plot(xChosen, yChosen, 'r+', 'MarkerSize', 10, 'LineWidth', 2)
title('DTNH Map with Chosen Site')




