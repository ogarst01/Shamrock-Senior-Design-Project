function shadowImage = removeShadow(index, image)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/15/21

inputs: 
index - location of pixel that is part of shadow group to remove 
image - preprocessed binary image, shadows marked as black pixels

outputs: 
shadowImage - image with this shadow group removed

purpose:
Remove a shadow by recursvely updating the pixel and its neighbors to be
white pixels.

questions/future improvements:
-N/A
%}
    [row, col] = size(image);
    shadowImage = image;
    
    %remove this pixel of shadow
    shadowImage(index(1), index(2)) = 256;

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
        if neighbors(i,1) <= row && neighbors(i,1) >= 1 && neighbors(i,2) <= col && neighbors(i,2) >= 1
            %check if neighbor is black
            if(image(neighbors(i,1), neighbors(i,2)) == 0)
                %recurse over this pixel's neighbors
                shadowImage = removeShadow(neighbors(i,:), shadowImage);
            end
        end
    end
    
    
end