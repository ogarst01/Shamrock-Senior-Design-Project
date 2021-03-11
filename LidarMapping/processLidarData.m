% This function takes in data from the arduino + processes it:
% Takes in text file + outputs a matrix - one column is time stamp, 
% The other is the distance being read in by the lidar sensor:

% note that if NAN is displayed - the start message from the arduino is
% being sent // that's the beginning of data being aquired...

function array = processLidarData(filename)
    % read in the data
    f = fopen(filename);
    
    % throw an error if unopenable!
    if f < 0 
        error('Cannot open file'); 
    end
    i = 0;
    C = textscan(f, '%f');
    % while not the end of the file, keep reading: 
    while ~feof(f)
        tline = fgetl(f);
        currNum = str2double(tline);
        i = i + 1;
        array(i) = currNum;
    end
%       line_ex = fgetl(f)
    
    fclose(f);
    array = array';
    
end

% % 
% THINGS TO NOTE
% - the arduino takes 1 second pulse readings
% - the serial output start time must be manually recorded
% - all measurements are in meters
% - the outputted text file is intentionally sparse so that it
%   takes up less room on the SD card. 
% %
