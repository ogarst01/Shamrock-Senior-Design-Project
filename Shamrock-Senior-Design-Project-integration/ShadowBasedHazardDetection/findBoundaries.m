function boundaryPixels = findBoundaries(image, plotOutput, connectMat)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/15/21

inputs: 
image - preprocessed binary image, shadows marked as black pixels
plotOutput - bool, if true make a plot where the boundary of the object is
             shown in red
connectMat - matrix that shows how shadow pixels are connected, same size 
             as image. If a pixel is part of a shadow, it has the same 
             value as the mark for that shadow.
             (optional)

outputs: 
boundaryPixels - matrix holding indices of pixels that are shadow
                 boundaries in first 2 cols. If a connectMat is provided,
                 there will be a third col that indicates which shadow the
                 pixels belong to.

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
            [bound_row, ~] = size(bound_idx);
            %check adjacent pixels
            %if one is white, mark this as a boundary (red)
            if(i < row && image(i+1,j) == 256)
                bound_idx(bound_row+1, :) = [j, i];
            elseif (i > 1 && image(i-1,j) == 256)
                bound_idx(bound_row+1, :) = [j,i];
            elseif (j < col && image(i, j+1) == 256)
                bound_idx(bound_row+1, :) = [j,i];
            elseif (j > 1 && image(i, j-1) == 256)
                bound_idx(bound_row+1, :) = [j,i];
            %check if edge of image
            elseif i == 1 || i == row
                bound_idx(bound_row+1, :) = [j, i];
            elseif j == 1 || j == col
                bound_idx(bound_row+1, :) = [j, i];
            end
        end
    end
end

if plotOutput
    figure
    imshow(image)
    hold on
    plot(bound_idx(:,1), bound_idx(:,2), '.r', 'MarkerSize', 3)
    hold off
end

[connectRow, ~] = size(connectMat);
if connectRow > 0
    [bound_row, bound_col] = size(bound_idx);
    boundaryPixels = zeros(bound_row, bound_col + 1);
    boundaryPixels(:, 1:2) = bound_idx;
    for i = 1:bound_row
        thisMark = connectMat(bound_idx(i,1), bound_idx(i,2));
        boundaryPixels(i, 3) = thisMark;
    end
else
    boundaryPixels = bound_idx;
end

end