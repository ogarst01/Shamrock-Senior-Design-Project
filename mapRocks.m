function hazardMap = mapRocks(shadowBoundaries, rockDiameter, sunDirection, mapSize)
%todo add axis line
%todo check if 0 or 1 means hazard
%assumes shadow edge is midpoint of ellipse/square
hazardMap = zeros(mapSize);
hazardMap(1:mapSize(1), 1:mapSize(2)) = 256;


if sunDirection == 'south'
    [midPointY, midIndex] = min(shadowBoundaries(:, 2));
    midPointX = shadowBoundaries(midIndex);
    rockRad = rockDiameter / 2;
    
    startPointX = midPointX - rockRad;
    endPointX = midPointX + rockRad;
    startPointY = midPointY - rockRad;
    endPointY = midPointY + rockRad;
    hazardMap(startPointX:endPointX, startPointY:endPointY) = 0;
else
    %todo add other directions
end

startPointX = midPointX - rockRad;
endPointX = midPointX + rockRad;
startPointY = midPointY - rockRad;
endPointY = midPointY + rockRad;
hazardMap(startPointX:endPointX, startPointY:endPointY) = 0;

end