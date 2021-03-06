function hazardMap = mapRocks(shadowBoundaries, rockDiameter, sunDirection, mapSize)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/27/21

inputs: 
shadowBoundaries - boundary pixels of shadow in image
rockDiameter - estimated diameter of the rock hazard
sunDirection - string describing where the sun is coming from (ex: 'south')
mapSize - vector for desired size of the hazard map output 


outputs: 
hazardMap - binary map of hazard locations. '1' marks hazard, '0' marks
            safe

purpose:
Based on shadow boundary, direction of the sun, and the size of the rock
make a hazard map of estimated rock location.

current model:
-only works for when sun is coming into image vertically from top or
bottom, or horizontally from left or right
-along line of sunlight, assumes rock starts at edge of shadow
-along other axis, assumes midpoint of rock position is average

questions/future improvements:
-apply threshold to determine hazard size
-work for sun coming in along an angle
-estimate rock as an ellipse
-compute shadow/rock boundary, find max of that as where rock starts, and
assume that is where rock is centered

%}

hazardMap = zeros(mapSize);
rockRad = round(rockDiameter / 2);

%roughly find center of shadow in X
if strcmp(sunDirection, 'top') || strcmp(sunDirection, 'bottom')
    midPointX = mean(shadowBoundaries(:,2));
    midPointX = round(midPointX);
    startPointX = midPointX - rockRad;
    endPointX = midPointX + rockRad;
elseif strcmp(sunDirection, 'left')
    startPointX = max(shadowBoundaries(:, 2));
    endPointX = startPointX + 2 * rockRad;
elseif strcmp(sunDirection, 'right')
    endPointX = min(shadowBoundaries(:, 2));
    startPointX = endPointX - 2 * rockRad;
else
    %todo print error statement
end

%find where the rock starts in Y
if strcmp(sunDirection, 'bottom')
    %assume bottom of shadow is start of rock
    startPointY = max(shadowBoundaries(:, 1));
    endPointY = startPointY + 2 * rockRad;
elseif strcmp(sunDirection,'top')
    %assume top of shadow is start of rock
    endPointY = min(shadowBoundaries(:, 1));
    startPointY = endPointY - 2 * rockRad;
elseif strcmp(sunDirection, 'left') || strcmp(sunDirection, 'right')
    midPointY = mean(shadowBoundaries(:, 1));
    midPointY = round(midPointY);
    startPointY = midPointY - rockRad;
    endPointY = midPointY + rockRad;
end

%change start/end points to edge if they are outside image
if endPointX > mapSize(1)
    endPointX = mapSize(1);
elseif startPointX < 1
    startPointX = 1;
elseif endPointY > mapSize(2)
    endPointY = mapSize(2);
elseif startPointY < 1
    startPointY = 1;
end

%fill in hazard map
hazardMap(startPointY:endPointY, startPointX:endPointX) = 1;

end