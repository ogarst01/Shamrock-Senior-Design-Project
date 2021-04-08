% Function to grab frames every few seconds from drone footage and store in
% images in frames folder. 

function numPics = GetFramesFromVid(filename, scale_factor)
% Load in movie file (TBD): 

v = VideoReader(filename);

cd images

filenameBeg = 'frame_';
filenameEnd = '.png';

% grab the actual video
frame = v.read();

% grab length of the video:
duration = v.Duration; % in seconds:

frameRate = round(v.FrameRate);

for i = 1:duration
    % DJI mavic mini frame rate is 60 frames/second:
    img = frame(:,:,:,i*frameRate);
    
    % save the image under the second it was recorded
    FileName=[filenameBeg,num2str(i),filenameEnd];
    img = imresize(img,scale_factor);
    imwrite(img,FileName);
        
end
numPics = i;

% cd back to main:
cd ..

end