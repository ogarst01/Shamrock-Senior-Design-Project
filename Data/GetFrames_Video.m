% Function to grab frames every few seconds from drone footage and store in
% images in frames folder. 

function GetFrames_Video(filename)
% Load in movie file (TBD): 

cd Data;
cd movie_data

v = VideoReader(filename);

cd .. 
cd frames

filenameBeg = 'frame_';
filenameEnd = '.png';

% grab the actual video
frame = v.read();

% grab length of the video:
duration = v.Duration; % in seconds:

for i = 1:duration
    % DJI mavic mini frame rate is 60 frames/second:
    img = frame(:,:,:,i);
    
    % save the image under the second it was recorded
    FileName=[filenameBeg,num2str(i),filenameEnd];
    
    imwrite(img,FileName);
        
end

% cd back to main:
cd ..
cd ..


end