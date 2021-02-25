function hazardMap = mapRocks(shadowBoundaries, rockDiameter, sunDirection, mapSize)
%todo add axis line
%1 means hazard
%assumes shadow edge is midpoint of ellipse/square
hazardMap = zeros(mapSize);
rockRad = round(rockDiameter / 2);

%roughly find center of shadow
if sunDirection == 'south'
    midPointX = mean(shadowBoundaries(:,2));
    midPointX = round(midPointX);
else
    %todo add other directions
end

if sunDirection == 'south'
    startPointY = max(shadowBoundaries(:, 1));
    endPointY = startPointY + 2 * rockRad;
    
else
    %todo add other directions
end

startPointX = midPointX - rockRad;
endPointX = midPointX + rockRad;
hazardMap(startPointX:endPointX, startPointY:endPointY) = 1;

end