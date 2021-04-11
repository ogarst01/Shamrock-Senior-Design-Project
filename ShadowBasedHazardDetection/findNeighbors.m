function [updatedConnectivity, updatedPixels] = findNeighbors(image, connectivityMat, index, numPixels)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/15/21

inputs: 
image - preprocessed binary image, shadows marked as black pixels
connectivityMat - matrix that holds marks for pixels part of shadow group
index - location of pixel to find neighbors for
numPixels - size of the grouping so far

outputs: 
updatedConnectivity - updated version of the connectivity matrix that is
                      marked with this pixel's neighbors
updatedPixels - size of the grouping after finding this pixel's neighbors

purpose:
Recursively find the pixels that make up the shadow group and count the 
size of the group.

questions/future improvements:

%}

updatedConnectivity = connectivityMat;
updatedPixels = numPixels;
mark = connectivityMat(index(1), index(2));
[row, col] = size(image);

%list indices all possible neighbors
n1 = [index(1), index(2) + 1]; %directly right
n2 = [index(1) + 1, index(2)]; %directly below
n3 = [index(1) + 1, index(2)+1]; %corner right & below
n4 = [index(1), index(2)-1]; %directly left
n5 = [index(1) - 1, index(2)]; %directly above
n6 = [index(1) - 1, index(2)-1]; %corner left & above
n7 = [index(1) + 1, index(2)-1]; %corner right & above 
n8 = [index(1) - 1, index(2)+1]; %corner left & below
neighbors = [n1; n2; n3; n4; n5; n6; n7; n8];

for i = 1:length(neighbors)
    %check that index is within bounds
    if neighbors(i,2) <= row && neighbors(i,1) >= 1 && neighbors(i,1) <= col && neighbors(i,2) >= 1
        %check if neighbor is black
        if(image(neighbors(i,1), neighbors(i,2)) == 0 && updatedConnectivity(neighbors(i,1), neighbors(i,2)) ~= mark)
            %update connectivityMat
            updatedConnectivity(neighbors(i,1), neighbors(i,2)) = mark;
            updatedPixels = updatedPixels + 1;

            %recurse over this pixel's neighbors
            [updatedConnectivity, updatedPixels] = findNeighbors(image, updatedConnectivity, neighbors(i,:), updatedPixels);
        end
    end
end

end