function distanceMap = DTNH(hazardMap)
%distanceMap = DTNH(hazardMap)
%{
Senior Design
Team Shamrock
Melissa Rowland
11/15/20

inputs:
hazardMap - binary image of hazards. '0' indicates hazard

outputs:
distanceMap - map of distances to nearest hazard (in pixels)

purpose:
Compute the distance to a hazard at all locations in the image frame. A
distance of '0' indicates that the cell is a hazard. Utilizes the grassfire
transform. See: https://en.wikipedia.org/wiki/Grassfire_transform for basic
algorithm.

questions/future improvements:
-is there a faster/less computationally expensive algorithm that can be
implemented?
%}

%Extract size of map
[numRow, numCol] = size(hazardMap);

%Preallocate map, initialize top right border to 1
distanceMap = zeros(numRow, numCol);
distanceMap(1,:) = 1;
distanceMap(:,1) = 1;

%Loop over each row of image from left to right
%Loop over each column from left to right
%For each pixel, set the distance to 0 if it is a hazard
%Otherwise set it to 1 + min of its neighbors
for row = 1:numRow
    for col = 1:numCol
        if row > 1
            northRow = row - 1;
        else
            northRow = 1;
        end
        
        if col > 1
            westCol = col - 1;
        else
            westCol = 1;
        end
        
        if hazardMap(row,col) == 0
            distanceMap(row,col) = 1 + min([distanceMap(northRow, col), distanceMap(row, westCol)]);
        else
            distanceMap(row,col) = 0;
        end
    end
end

%initialize bottom right border to be 1
distanceMap(numRow, :) = 1;
distanceMap(:, numCol) = 1;

%Loop over each row of image from right to left
%Loop over each column from right to left
%For each pixel, set the distance to 0 if it is a hazard
%Otherwise set it to the min of (its value or 1 + min of its neighbors)
for row = numRow:-1:1
    for col = numCol:-1:1
        if row < numRow
            southRow = row + 1;
        else
            southRow = numRow;
        end
        
        if col < numCol
            eastCol = col + 1;
        else
            eastCol = numCol;
        end
        
        if hazardMap(row,col) == 0
            distanceMap(row,col) = min([distanceMap(row,col), 1 + min([distanceMap(southRow, col), distanceMap(row, eastCol)])]);
        else
            distanceMap(row,col) = 0;
        end
    end
end

end