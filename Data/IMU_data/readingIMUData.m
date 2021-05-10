% This function takes in data from the arduino + processes it:
% Takes in text file + outputs a matrix - one column is time stamp, 
% The other is the distance being read in by the lidar sensor:

% note that if NAN is displayed - the start message from the arduino is
% being sent // that's the beginning of data being aquired...

 function [time_array, array] = readingIMUData(filename)
    % read in the data
    %filename = 'run1_march18'
    f = fopen(filename);
    
    % throw an error if unopenable!
    if f < 0 
        error('Cannot open file'); 
    end
    
    % counter for current line number:
    count = 0;
    C = textscan(f, '%f');
    % while not the end of the file, keep reading: 
    
    while ~feof(f)
        tline = fgetl(f);
        
        % check for end of line:
        if(length(tline) < 4)
            break;
        end
        
        if(count == 0)
            % :31:39.070 -> A X: -9.4421  Y: -0.9811  Z: 1.8760  m/s^2
            minutes = str2double(tline(1:2));
            seconds = str2double(tline(4:5));
            mseconds = str2double(tline(7:9));
            char = tline(21:end);
            char = regexprep(char, 'Y:', ' ');
            char = regexprep(char, 'Z:', ' ');
            accel_vec = sscanf(char,'%f');            
        else
            minutes = str2double(tline(4:5));
            seconds = str2double(tline(7:8));
            mseconds = str2double(tline(9:12));

            char = tline(21:end);
            char = regexprep(char, 'Y:', ' ');
            char = regexprep(char, 'Z:', ' ');
            accel_vec = sscanf(char,'%f');
        end
%         accel_x = str2double(tline(22:27));
%         accel_y = str2double(tline(33:38));
%         % grab lidar measurements: 
%         accel_vec = [accel_x, accel_y];
        
        % grab the time in seconds: 
        time = (minutes*60) + (seconds) + (mseconds);
        
        count = count + 1;
        
        % lidar data:
        array(count,:) = accel_vec;
        
        % in seconds:
        time_array(count) = time;
    end
    
    array = array(:,2:3);
    %time_array = time_array(1:2:end,:);
    
    
    fclose(f);
    %array = array;
end