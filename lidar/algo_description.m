% grab data from lidar sensor (via UART)

% write to a file with time stamp, vel(if possible), and distance

% fly over the entire room to create a 'global' map in tight, defined
% zig zag pattern

% after wards: 

% 1. read in data - on change in velocity, know that the data points are
% now moving the opposite way (could also use IMU with timing data here)

% 2. create a map of lidar points with amplitude of height - distance 
% (so for closer to lidar objects, we get a larger image of rock after 
% interpolation)

% 3. noise reduction - this can only be accessed with actual data, but it
% seems that this lidar sensor is pretty accurate. Gaussian low pass filter
% the data if needed - this could be connected to image processing (roughness factor)

% 4. interpolate points using cubic interpolation 

% 5. process data - find edged 