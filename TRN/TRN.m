function [time, coords, locRows, locCols] = TRN(global_map, local_map, time)
    global_map = imread(global_map);
    global_map = imrotate(global_map,180);
    global_map = rescale(rgb2gray(global_map));
    cd images
    local_map = imread(local_map);
    local_map = rescale(rgb2gray(local_map));
    cd ..
    numRows = size(global_map, 1);
    numCols = size(global_map, 2);
    
    % size of local map
    locRows = size(local_map, 1);
    locCols = size(local_map, 2);
    
    
    for i = 1:4:numRows-locRows  
        for j = 1:4:numCols-locCols
            globalSect = global_map(i:i+locRows-1,j:j+locCols-1);
            locationDiff(i,j) = corr2(globalSect,local_map); %normxcorr2(globalSect,local_map);
            clear globalSect
        end
    end

    [row, col] = find(locationDiff == max(max(locationDiff)))

    pixel = [row, col];
    s = [0.0254*24, 0.0254*47.5];       %inches
    coords = pix2meters(pixel, s);
    time = time + 60;
end

    % the best match should be the point when the two completely overlap and
    % their difference is zero
    % show the locationDiff map... 
    %figure, imagesc(abs(locationDiff))
    % the best match should be the point when the two completely overlap and
    % their difference is zero
    %[bestN, bestM] = find(locationDiff == 0);
    
    % Use the SSIM (structural similarity index), calculate for the results of
    % the gray scale calculation to account for the case where we have two
    % completelely white or completely black squares
%     for i = 1:numRows
%         for j = 1:numCols
%             %globalSSIM = global_map(bestN(i):bestN(i)+40,bestM(j):bestM(j)+40);
%             [ssimval(i,j),~] = ssim(local_map,global_map);
%             if ssimval(i,j) == 1
%                 break
%             end
%         end
%     end
%     % the ideal match is where the index equals 1, complete match
%     pixel = find(ssimval == 1);