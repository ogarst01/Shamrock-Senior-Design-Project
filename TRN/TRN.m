function [time, coords] = TRN(global_map, local_map, time, prev_coord_x, prev_coord_y, framesPerSec, set_size)

    local_map = imread(local_map);
    local_map = rescale(rgb2gray(local_map));
    local_map = imresize(local_map, 0.35);
    
    numRows = size(global_map, 1);
    numCols = size(global_map, 2);
    
    % size of local map
    locRows = size(local_map, 1);
    locCols = size(local_map, 2);
    
    % TODO make this an input to function
    stride = 10;
    
    % if close enough to the middle (ie not gonna run off
    % the edge, then run only on a select area around the current 
    % TRN location)
    if(old_row >= (1280 - stride - locRows) || (old_row <= stride) || (old_col >= (720 - stride - locCols)) || old_col <= stride)
        for i = 1:4:((numRows-locRows))
            for j = 1:4:((numCols-locCols))
                globalSect = global_map(i:i+locRows-1,j:j+locCols-1);
                locationDiff(i,j) = corr2(globalSect,local_map);
                clear globalSect
            end
        end    
    else
        % run the whole algorithm
        for i = 1:4:((numRows-locRows)) 
            for j = 1:4:((numCols-locCols))
                globalSect = global_map(i:i+locRows-1,j:j+locCols-1);
                locationDiff(i,j) = corr2(globalSect,local_map);
                clear globalSect
            end
        end
    end
    
    % uncomment to display the location correlation map (over the global map)
%     figure, imagesc(locationDiff)
%     title('location difference map')
%     colormap
    
    % find the max correlation == probably the location of drone at that
    % point:
    [row,col] = find(locationDiff == max(max(locationDiff)));
    % find the center pixel of the local map on the global map
    pixel = [row, col];
    % initialize the size of the set in meters
    s = [0.0254*set_size(1), 0.0254*set_size(2)]; 
    % convert to coordinates in meters
    coords = pix2meters(pixel, s);
    time = time + 60*(1/framesPerSec);   % TODO: incorporate time when we have IMU measurements
end