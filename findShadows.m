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

%CCL
[row, col] = size(image);
connected = zeros(row, col); %initialize connectivity matrix to size of image
mark = 1; %mark is initialized, incremented for every detected object
num_objects = 0;
infoMat = zeros(10,2); %store info about groups, first col: mark, second col: num pixels in group

for i = 1:row
    for j = 1:col
        %detect black objects not part of other group
        if(image(i,j) == 0 && connected(i,j) == 0)
            num_objects = num_objects + 1;
            num_pixels = 1;
            index = [i,j];
            connected(index(1), index(2)) = mark;
            
            [connected, num_pixels] = findNeighbors(image, connected, index, num_pixels);
            
            infoMat(num_objects, 1) = mark;
            infoMat(num_objects, 2) = num_pixels;
            mark = mark + 1;
        end
    end
end

%threshold, remove shadows that are too small
initialSize = round(num_objects / 4); %initialize to 1/4 size
threshInfoMat = zeros(initialSize, 2);
threshIndex = 1;
for k = 1:num_objects
    if(infoMat(k,2) >= 5)
        threshInfoMat(threshIndex, :) = infoMat(k, :);
        threshIndex = threshIndex + 1;
    end
end
threshInfoMat(threshIndex:initialSize, :) = []; %remove extra unused rows

%remove shadows that are too small


shadowsInImage = [];

end