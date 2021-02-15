function boundaryPixels = findBoundaries(image)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/15/21

inputs: 
image - preprocessed binary image, shadows marked as black pixels

outputs: 
boundaryPixels - matrix holding indices of pixels that are shadow
                 boundaries

purpose:
Find all the pixels that are part of the boundary of a shadow and display
them on the image.

questions/future improvements:
-N/A
%}

    %find boundaries - black pixels next to white
    [row, col] = size(image);
    bound_idx = [];
    for i = 1:row
        for j = 1:col
            %check black pixels
            if(image(i,j) == 0)
                [bound_row, bound_col] = size(bound_idx);
                %check adjacent pixels
                %if one is white, mark this as a boundary (red)
                if(i < row && image(i+1,j) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                elseif (i > 1 && image(i-1,j) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                elseif (j < col && image(i, j+1) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                elseif (j > 1 && image(i, j-1) == 256)
                    bound_idx(bound_row+1, :) = [i, j];
                end
            end
        end
    end

    figure
    imshow(image)
    hold on
    plot(bound_idx(:,2), bound_idx(:,1), '.r', 'MarkerSize', 3)
    hold off
    
    boundaryPixels = bound_idx;
end