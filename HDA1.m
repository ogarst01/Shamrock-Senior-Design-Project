function [xCoord, yCoord, distanceMap] = HDA1(hazardMap, landerFoot)
%[xCoord, yCoord, distanceMap] = HDA1(hazardMap, landerFoot)
%{
Senior Design
Team Shamrock
Melissa Rowland
11/15/20

inputs:
hazardMap - binary image of hazards. '1' indicates hazard
landerFoot - footprint of lander (in pixels)

outputs:
xCoord - x coordinate of optimal landing site (in pixels)
yCoord - y coordinate of optimal landing site (in pixels)
distanceMap - map of distances to nearest hazard (in pixels)

purpose:
Perform hazard detection and avoidance on a hazard map. This algorithm
assumes the optimal landing site is the one that is furthest from the
hazard. This algorithm only takes into consideration hazard location, and
not any other data about the landing surface (surface angle, roughness,
etc).

assumptions:
-want entire lander footprint within image since there may be unknown
hazards right outside image

questions/future improvements:
-should the edges right outside the image be treated as a 'hazard' when
computing distances since there may be a hazard there?
-add considerations for choosing the site close to a planned/desired site?
-add consideration for choosing the site due to fuel constraints?
%}

%Compute distance map
distanceMap = DTNH(hazardMap);

%Crop distance map so that entire lander footprint will be within image
%Do this by setting the DTNH values to 0 in a border around edge
distanceMapCropped = distanceMap;
[numRow, numCol] = size(distanceMap);
distanceMapCropped(1:(landerFoot+1),:) = 0;
distanceMapCropped(:,1:(landerFoot+1)) = 0;
distanceMapCropped((numRow-(landerFoot+1)):numRow, :) = 0;
distanceMapCropped(:, (numCol-(landerFoot+1)):numCol) = 0;

%Find optimal site as max distance from a hazard
[maxDistCols, maxColInd] = max(distanceMapCropped, [], 1);
[maxDist, maxRowInd] = max(maxDistCols);

%Sanity check: maxDist > 0
if maxDist <= 0
    fprintf('ERROR: max distance to hazard is 0')
end

%Warning if footprint of lander will hit hazard
if maxDist <= landerFoot
    fprintf('WARNING: max distance to hazard is less than footprint size.')
end

%Return coordinates of chosen landing site
xCoord = maxRowInd;
yCoord = maxColInd(maxRowInd);

end