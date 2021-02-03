function shadowsInImage = findShadows(image)
%{
Senior Design
Team Shamrock
Melissa Rowland
12/6/20

inputs: 
image - image to be processed
outputs: 
shadowsInImage - image with sufficiently large shadows detected, marked as
                 red pixels
purpose: Detect significant shadows in a pre-processed image.
%}

%find boundaries - black pixels next to white
[row, col] = size(image);
bound_idx = [];
bound_image = image;
for i = 1:row
    for j = 1:col
        %check black pixels
        if(image(i,j) == 0)
            [bound_row, bound_col] = size(bound_idx);
            %check adjacent pixels
            %if one is white, mark this as a boundary (red)
            if(i < row && image(i+1,j) == 256)
                bound_idx(bound_row+1, :) = [i, j];
                bound_image(i,j) = 128;
            elseif (i > 1 && image(i-1,j) == 256)
                bound_idx(bound_row+1, :) = [i, j];
                bound_image(i,j) = 128;
            elseif (j < col && image(i, j+1) == 256)
                bound_idx(bound_row+1, :) = [i, j];
                bound_image(i,j) = 128;
            elseif (j > 1 && image(i, j-1) == 256)
                bound_idx(bound_row+1, :) = [i, j];
                bound_image(i,j) = 128;
            end
        end
    end
end

figure
imshow(image)
hold on
plot(bound_idx(:,2), bound_idx(:,1), '.r')
hold off

%count pixels within boundaries

%threshold, remove shadows that are too small

shadowsInImage = [];

end