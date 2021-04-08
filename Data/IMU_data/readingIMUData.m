% This function takes in data from the arduino + processes it:
% Takes in text file + outputs a matrix - one column is time stamp, 
% The other is the distance being read in by the lidar sensor:

% note that if NAN is displayed - the start message from the arduino is
% being sent // that's the beginning of data being aquired...

% function array = readingIMUData(filename)
    % read in the data
    filename= 'run1_march18'
    f = fopen(filename);
    
    % throw an error if unopenable!
    if f < 0 
        error('Cannot open file'); 
    end
    
    % counter for current line number:
    i = 0;
    C = textscan(f, '%f');
    % while not the end of the file, keep reading: 
    while ~feof(f)
        tline = fgetl(f);
        % example: 16:18:10.365 ->
        if(i == 0)
            time_stamp = tline(1:12)
            minutes = (tline(2:3))
            minutes = str2double(minutes);
            seconds = str2double(tline(5:6))
            seconds = str2double(seconds);
            mseconds = (tline(7:10))
            mseconds = str2double(mseconds);

            arrow_trash = tline(13:15);
            actual_lidar = tline(15:end)
        else
            % '16:16:19.104'
            time_stamp = tline(1:12)
            minutes = (tline(4:5))
            minutes = str2double(minutes);
            seconds = (tline(7:8))
            seconds = str2double(seconds);
            mseconds = (tline(9:12))
            mseconds = str2double(mseconds);

            actual_lidar = tline(17:end)            
        end
        % grab lidar measurements: 
        currNum = str2double(actual_lidar);
        
        % grab the time in seconds: 
        time = (minutes*60) + (seconds) + (mseconds);
        
        i = i + 1;
        
        % lidar data:
        array(i) = currNum;
        
        % in seconds:
        time_array(i) = time;
    end
    
    fclose(f);
    array = array;
% end