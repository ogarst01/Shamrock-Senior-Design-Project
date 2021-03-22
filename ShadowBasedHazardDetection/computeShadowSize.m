function length = computeShadowSize(shadowBoundaries, sunDirection)
%{
Senior Design
Team Shamrock
Melissa Rowland
3/6/21

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
-only works for one shadow
-only works for vertical/horizontal orientations

%}

%compute length as difference between largest & smallest value along line
%of sunlight
if strcmp(sunDirection, 'bottom') || strcmp(sunDirection, 'top')
    length = max(shadowBoundaries(:,2)) - min(shadowBoundaries(:,2));
elseif strcmp(sunDirection, 'left') || strcmp(sunDirection, 'right')
    length = max(shadowBoundaries(:,1)) - min(shadowBoundaries(:,1));
else
    length = 0;
end

end