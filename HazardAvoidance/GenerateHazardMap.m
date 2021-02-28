function map = GenerateHazardMap(n, m, numHazard, minHazardSize, maxHazardSize)
% map = GenerateHazardMap(n, m)
%{
Senior Design
Team Shamrock
Melissa Rowland
11/15/20

inputs:
n - image width (pixels)
m - image length (pixels)
numHazard - desired # of hazards in image
minHazardSize - minimum size of a hazard (square pixels)
maxHazardSize - maximum size of a hazard (square pixels)

outputs:
map - n x m binary hazard map. '1' indicates a hazard

purpose:
Generate a simple random hazard map. The size of the hazards is randomized
between the minimum and maximum size. The location of the hazards is
randomized to be anywhere within the image. The hazards are all squares.

questions/future improvements:
-add more shapes
-make clusters of hazards?
%}

%initialize map
map = zeros(n,m);

%Generate numHazard hazards
for i = 1:numHazard
    %randomly select location & size
    x = round(rand() * n);
    y = round(rand() * m);
    hazardSize = round(minHazardSize + (maxHazardSize - minHazardSize) * rand());
    
    %compute bounds of square for hazard
    xLow = x - hazardSize;
    xHigh = x + hazardSize;
    yLow = y - hazardSize;
    yHigh = y + hazardSize;
    
    %fix bounds so that the 1<x<n and 1<y<m
    if xLow < 1
        xLow = 1;
    end
    if xHigh > n
        xHigh = n;
    end
    if yLow < 1
        yLow = 1;
    end
    if yHigh > m
        yHigh = m;
    end
    
    %Mark hazard in that area
    map(xLow:xHigh,yLow:yHigh) = 1;
end

end