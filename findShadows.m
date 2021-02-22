function shadowImage = findShadows(image, threshold, plotBoundaries)
%{
Senior Design
Team Shamrock
Melissa Rowland
2/15/21

inputs: 
image - preprocessed binary image, shadows marked as black pixels
threshold - threshold value for shadow size to retain (pixels)
plotBoundaries - if true, plot image with boundaries of shadows traced in 
                 red (bool)
outputs: 
shadowImage - image with shadows below the threshold size removed
purpose: Remove small/insignificant shadows in an image by computing shadow
         size with Connected Component Labeling, applying a threshold, and
         removing the shadows below the threshold size.

questions/future improvements:
-what is the best value to use for threshold?
-possibly remove the connectivity matrix and just count the number of
pixels?
%}

%Connected Component Labeling
[row, col] = size(image);
connected = zeros(row, col); %initialize connectivity matrix to size of image
mark = 1; %mark is initialized, increment for every detected object
num_objects = 0;
infoMat = zeros(10,4); %store info about groups, 
                       %first col: mark, second col: num pixels in group
                       %third col: index of first pixel (x)
                       %fourth col: index of first pixel (y)
%Loop over all pixels in image
for i = 1:row
    for j = 1:col
        %detect black objects that are not already part of a group
        if(image(i,j) < 225 && connected(i,j) == 0)
            num_objects = num_objects + 1;
            num_pixels = 1;
            index = [i,j];
            
            %mark this pixel
            connected(index(1), index(2)) = mark;
            
            %find the neighbor pixels, mark them as well
            [connected, num_pixels] = findNeighbors(image, connected, index, num_pixels);
            
            %store informatio about this shadow
            infoMat(num_objects, 1) = mark;
            infoMat(num_objects, 2) = num_pixels;
            infoMat(num_objects, 3:4) = index;
            mark = mark + 1;
        end
    end
end

%Apply threshold, gather info about small shadows to remove
initialSize = round(num_objects / 2); %initialize to 1/2 size
threshInfoMat = zeros(initialSize, 4);
threshIndex = 1;
for k = 1:num_objects
    if(infoMat(k,2) < threshold)
        threshInfoMat(threshIndex, :) = infoMat(k, :);
        threshIndex = threshIndex + 1;
    end
end
threshInfoMat(threshIndex:initialSize, :) = []; %remove extra unused rows
threshSize = threshIndex - 1;

%Remove shadows that are too small
shadowImage = image;
for l = 1:threshSize
    cur_index = threshInfoMat(l, 3:4);
    shadowImage = removeShadow(cur_index, shadowImage); 
end

if(plotBoundaries)
    boundPixelsOrig = findBoundaries(image);
    boundPixelsFinal = findBoundaries(shadowImage);
end

end