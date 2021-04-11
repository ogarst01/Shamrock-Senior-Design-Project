function [length, minPoint, maxPoint] = computeShadowSizeAz(shadowBoundaries, v1, v2)
%{
Senior Design
Team Shamrock
Melissa Rowland
3/6/21

inputs: shadowBoundaries - boundary pixels of shadow
        v1 - one point on line through average point along shadow
        v2 - another point on line through average point along shadow


outputs: length - length of shadow (pixels)
         minPoint - minimum point of shadow boundary along line thru shadow
         maxPoint - minimum point of shadow boundary along line thru shadow


purpose:
Based on shadow boundary and line of the the sunlight through average
point at azimuth angle, compute the size of the shadow.
%}

[row, ~] = size(shadowBoundaries);
shadowMat = [shadowBoundaries];

%compute distance of all boundary points to line
a = v1 - v2;
a = [a, 0];
b = shadowMat(:, 1:2) - v2;
b = [b, zeros(row, 1)];
for i = 1:row
    this_pt = shadowMat(i, 1:2);
    %store distance in third col of shadowMat
    shadowMat(i, 3) = abs((v2(1) - v1(1)) * (v1(2) - this_pt(2)) - (v1(1) - this_pt(1)) * (v2(2) - v1(2))) / sqrt( (v2(1) - v1(1))^2 + (v2(2) - v1(2))^2);
end

%find closest points to line
closestPoints = [];
[numPts, ~] = size(closestPoints);
while numPts < 2
   minDist = min(shadowMat(:,3));
   closestPoints = [closestPoints; shadowMat(shadowMat(:,3) == minDist, :)];
   shadowMat(shadowMat(:,3) == minDist, :) = [];
  [numPts, ~] = size(closestPoints);
end

%find max & min from those points
[~, maxIdx] = min(closestPoints(:,2));
[~, minIdx] = max(closestPoints(:,2));
maxPoint = closestPoints(maxIdx, 1:2);
minPoint = closestPoints(minIdx, 1:2);

%compute length as distance between largest & smallest value along line
%of sunlight
length = norm(maxPoint - minPoint);

end