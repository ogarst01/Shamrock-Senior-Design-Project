function [time, coords] = TRN(global_map, local_map)
%global_map = 'april5_global_from_.93m.png';
 
    global_map = imread(global_map);
    global_map = imrotate(global_map,180);
    global_map = rescale(rgb2gray(global_map));
    cd images
    
    local_map = imread(local_map);
    local_map = rescale(rgb2gray(local_map));
    local_map = imresize(local_map, 0.35);
    
    cd ..
    numRows = size(global_map, 1);
    numCols = size(global_map, 2);
    
    % size of local map
    locRows = size(local_map, 1);
    locCols = size(local_map, 2);
    
    
    for i = 1:numRows-locRows    % TODO: change this for num pixels in real image
        for j = 1:numCols-locCols
            globalSect = global_map(i:i+locRows-1,j:j+locCols-1);
            locationDiff(i,j) = corr2(globalSect,local_map); %normxcorr2(globalSect,local_map);
            clear globalSect
            
        end
    end
    % the best match should be the point when the two completely overlap and
    % their difference is zero
    % show the locationDiff map... 
    figure, imagesc(1 - abs(locationDiff))
    [row, col] = find(ismember(locationDiff, max(locationDiff(:))))
    
    [bestN, bestM] = find(locationDiff == 0);
    
    % Use the SSIM (structural similarity index), calculate for the results of
    % the gray scale calculation to account for the case where we have two
    % completelely white or completely black squares
    for i = 1:numRows
        for j = 1:numCols
            %globalSSIM = global_map(bestN(i):bestN(i)+40,bestM(j):bestM(j)+40);
            [ssimval(i,j),~] = ssim(local_map,global_map);
            if ssimval(i,j) == 1
                break
            end
        end
    end
    % the ideal match is where the index equals 1, complete match
    pixel = find(ssimval == 1);
    s = [46, 14];       %inches
    coords = pix2meters(pixel, s);
    time = 0;   % TODO: incorporate time when we have IMU measurements

end