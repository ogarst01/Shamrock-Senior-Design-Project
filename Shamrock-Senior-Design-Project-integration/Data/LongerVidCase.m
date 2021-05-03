function numPics = LongerVidCase(numVids, framesPerSec)

currNumPics = 0;

for i = 1:numVids

    cd Data;
    cd movie_data
    
    movieNameBeg = 'april20_min';
    movieNameEnd = '.mp4';
    
    movieFileCurr =[movieNameBeg,num2str(i),movieNameEnd];
    
    v = VideoReader(movieFileCurr);

    cd .. 
    cd frames

    filenameBeg = 'frame_';
    filenameEnd = '.png';

    % grab the actual video
    frame = v.read();

    % grab length of the video:
    duration = v.Duration; % in seconds:

    framesPerSecToGrab = 1/framesPerSec;

    frameRate = round(v.FrameRate);
    
    
    for j =  1:(duration*1/framesPerSecToGrab)
        % DJI mavic mini frame rate is 60 frames/second:
        img = frame(:,:,:,(j)*frameRate*framesPerSecToGrab);

        % save the image under the second it was recorded
        FileName=[filenameBeg,num2str(j + currNumPics),filenameEnd];

        imwrite(img,FileName);
    end
    
    currNumPics = j + currNumPics;
    numPics = j;

    % cd back to main:
    cd ..
    cd ..

end

end