function [time, coords] = TRN(global_map, local_map)
    numRows = size(global_map, 1);
    numCols = size(global_map, 2);
    
    for i = 1:numRows - 40      % TODO: change this for num pixels in real image
        for j = 1:numCols - 40
            globalSect = global_map(i:i+40,j:j+40);
            tempDiff = globalSect - local_map;
            % find the sum at every point of the difference between the two
            % maps
            locationDiff(i,j) = sum(tempDiff, 'all');
            clear globalSect
        end
    end
    % the best match should be the point when the two completely overlap and
    % their difference is zero
    [bestN, bestM] = find(locationDiff == 0);
    
    % Use the SSIM (structural similarity index), calculate for the results of
    % the gray scale calculation to account for the case where we have two
    % completelely white or completely black squares
    for i = 1:length(bestN)
        for j = 1:length(bestM)
            globalSSIM = global_map(bestN(i):bestN(i)+40,bestM(j):bestM(j)+40);
            [ssimval(i,j),~] = ssim(local_map,globalSSIM);
        end
    end
    % the ideal match is where the index equals 1, complete match
    [ssimX, ssimY] = find(ssimval == 1);
    coords = [ssimX, ssimY];
    time = 0;   % TODO: incorporate time when we have IMU measurements

end