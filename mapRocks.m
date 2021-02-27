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
-only works for when sun is coming into image along vertical y-axis from
the south
-assumes bottom of shadow in Y is where rock starts
-assumes rock is centered at the average X location of shadow boundary
-estimates rock as a cube

questions/future improvements:
-apply threshold to determine hazard size
-work for other 4 directions
-work for sun coming in along an angle
-estimate rock as an ellipse
-compute shadow/rock boundary, find max of that as where rock starts, and
assume that is where rock is centered

%}

hazardMap = zeros(mapSize);
rockRad = round(rockDiameter / 2);

%roughly find center of shadow in X
if sunDirection == 'south'
    midPointX = mean(shadowBoundaries(:,2));
    midPointX = round(midPointX);
    startPointX = midPointX - rockRad;
    endPointX = midPointX + rockRad;
else
    %todo add other directions
end

%find where the rock starts in Y
if sunDirection == 'south'
    %assume bottom of shadow is start of rock
    startPointY = max(shadowBoundaries(:, 1));
    endPointY = startPointY + 2 * rockRad;
    
else
    %todo add other directions
end

%fill in hazard map
hazardMap(startPointX:endPointX, startPointY:endPointY) = 1;

end