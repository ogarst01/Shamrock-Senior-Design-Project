function [time, coords] = TRN(global_map, local_map, time, prev_coord_x, prev_coord_y)
%global_map = 'april5_global_from_.93m.png';
 
    global_map = imread(global_map);
    global_map = imrotate(global_map,180);
    global_map = rescale(rgb2gray(global_map));
    cd ..
    cd Data
    cd frames
    
    local_map = imread(local_map);
    local_map = rescale(rgb2gray(local_map));
    local_map = imresize(local_map, 0.35);
    
    cd ..
    cd ..
    cd TRN
    
    numRows = size(global_map, 1);
    numCols = size(global_map, 2);
    
    % size of local map
    locRows = size(local_map, 1);
    locCols = size(local_map, 2);
    
    
    for i = 1:4:((numRows-locRows)) 
        for j = 1:4:((numCols-locCols))
            globalSect = global_map(i:i+locRows-1,j:j+locCols-1);
            locationDiff(i,j) = corr2(globalSect,local_map);
            clear globalSect
        end
    end
    
    % uncomment to display the location correlation map (over the global map)
%     figure, imagesc(locationDiff)
%     title('location difference map')
%     colormap
    
    [row,col] = find(locationDiff == max(max(locationDiff)));
% 
%     % find a more granular part:
%     for i = -20:20
%         for j = -20:20
%             globalSect = global_map(prev_coord_x+i:prev_coord_x+i+locRows-1,prev_coord_:prev_coord_y+locCols-1);
%             locationDiff(i,j) = corr2(globalSect,local_map);
%             clear globalSect
%         end
%     end
    
    thresh = 200;
    
    % try again with more granularity:
    if((abs(row - prev_coord_x)>=thresh) || (abs(col - prev_coord_y)>=thresh))
        for i = 1:4:((numRows-locRows)) 
            for j = 1:4:((numCols-locCols))
                globalSect = global_map(i:i+locRows-1,j:j+locCols-1);
                locationDiff(i,j) = corr2(globalSect,local_map);
                clear globalSect

            end
        end  
    end
    
    row = row + (locRows/2);
    col = col + (locCols/2);
    
    % row and col in global map to return
    % [row, col] = find(ismember(locationDiff, max(locationDiff(:))));
    
    coords = [row, col];
    time = time + 60;   % TODO: incorporate time when we have IMU measurements
end