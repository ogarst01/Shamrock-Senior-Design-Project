% This function takes in data from the arduino + processes it:
% Takes in text file + outputs a matrix - one column is time stamp, 
% The other is the distance being read in by the lidar sensor:

% note that if NAN is displayed - the start message from the arduino is
% being sent // that's the beginning of data being aquired... -> ignore
% that  message

% For testing:
%clear
%close all;
%filename = 'IMU_data.txt'

function imuArray = processIMUData(filename, array)
    testing = false;
    if(testing == true)
        % read in the data
        f = fopen(filename);

        % throw an error if unopenable!
        if f < 0 
            error('Cannot open file'); 
        end
        i = 0;
        C = textscan(f, '%f');

        array = [];

        % while not the end of the file, keep reading: 
        while ~feof(f)
            % get the current line 
            tline = fgetl(f);

            % convert to a number from string:
            currNum = str2double(tline);

            i = i + 1;

            array(i) = currNum;
        end
    %       line_ex = fgetl(f)

        fclose(f);
        % array = array';

        % since this is accel data, we want to reshape the data into a matrix 
        % for x, y, and z coords:

        lenAr = length(array);
        %%
        % ignore the starting values: 
        array = array(2:end)

        % the number of readings: 
        readingNum = round(lenAr/3,0);

        array = reshape(array,3,3);
        % x is in the first row:
        % y is in the second tow:
        % z is in the third row: 
        
    else
        % FAKE THE COORDINATE SYSTEM DATA: 
        % data taken every second 
        startTime = 0;

        % say that you have IMU data taken every second too...

        % model IMU data? 
        movingVel = 0.5; 

        len = length(array);
        numSweeps = 6; 

        % To fake this data: 
        % moves left for 10 seconds, 
        % rests for 1 second
        % moves right for 10 seconds, 
        % rests for 1 second
        moving_left_swath_x  = -movingVel*ones(1,10);
        moving_righ_swath_x  = movingVel*ones(1,10);
        movingHorizontal__y  = zeros(1,10);
        rest         = 0;

        testIMUdata_x = [];
        testIMUdata_y = [];

        for i = 1:numSweeps/2
            testIMUdata_x  = [testIMUdata_x,moving_left_swath_x,rest,moving_righ_swath_x,rest];
            testIMUdata_y  = [testIMUdata_y,movingHorizontal__y,1,movingHorizontal__y,1];
        end
        % now that IMU data is generally approximated, assume 1 data point per
        % second - or figure out with Sophie the right timing / frequency to take
        % data points

        % curr location = velocity * 1 second. 

        % make sure the test Lidar data points length = length of IMU locations
        testIMUdata_x = testIMUdata_x(1:length(array));
        testIMUdata_y = testIMUdata_y(1:length(array));
        testIMUdata_z = zeros(length(array),1)';
        imuArray = [testIMUdata_x;testIMUdata_y;testIMUdata_z]
    end

end
