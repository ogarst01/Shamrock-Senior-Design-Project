% Function to grab frames every few seconds from drone footage and store in
% images in frames folder. 

function numPics = GetFrames_Video(filename, framesPerSec)
% Load in movie file (TBD): 


v = VideoReader(filename);

filenameBeg = 'frame_';
filenameEnd = '.png';

% grab the actual video
frame = v.read();

% grab length of the video:
duration = v.Duration; % in seconds:

frameRate = round(v.FrameRate);

for i = 1:(duration*5)
    
    % DJI mavic mini frame rate is 60 frames/second:
    img = frame(:,:,:,i*frameRate/framesPerSec);
    
    % save the image under the second it was recorded
    FileName=[filenameBeg,num2str(i),filenameEnd];
    
    imwrite(img,FileName);
        
end
numPics = i;

end