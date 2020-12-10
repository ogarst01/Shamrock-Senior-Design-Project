function img = isp(raw, metadata)

% grabs iso values from the .csv data provided
iso = metadata_value(metadata, 'ISO');

% stores iso value as a number 
isoVal = str2num(iso)

% expect high contrast outdoor scenes to have focus distance = Inf, 
% indoor scenes much closer distance
focus_distanceString = metadataISO(metadata, 'Focus Distance')

% only take the first 3 nums:
numVal = str2num(focus_distanceString(1:3))

% assumption / guess:
% if above 3 meters, most likely is outdoors: 
focus_distance = str2num(focus_distanceString)

% initialize bool for whether I guess it's outdoors or not..
outdoorGuess = false;

if(numVal > 3)
    outdoorGuess = true;
elseif(focus_distance == Inf)
    outdoorGuess = true;
else 
    outdoorGuess = false;
end
% OUTDOOR PHOTO HIGH CONTRAST PHOTO CATCHER: 
% iso won't be high but we need to introduce artificial gain to see 
% foreground...
% but in smoothing for outdoor scenes we need to use the actual 
% original photo iso val since there likely won't be that much
% ISO noise... correct for this here:
isoValforNoise = isoVal;

if(outdoorGuess == true)
    isoVal = 3200;
end

% inputs a .tif file that increases contrast and outputs a .tif file:
%img = blacklevel(raw);
img = blackLevelExp(raw); 
% 
% figure,
% imshow(img)
% title('black level correction')

% demosaics the inputted matrix of intensities, outputs an RGB matrix
img = isp_demosaic(img);
% 
% figure,
% imshow(img)
% title('demosaiced image')

% color corrects, using both RGB gray world assumption and HSV colorspace
img = colorcorrection2(img);

% figure,
% imshow(img)
% title('color correction stage 1')

img = colorcorrection(img);

% figure,
% imshow(img)
% title('color correction stage 2')

% gamma maps image 
img = gammaMap(img, isoVal);

% figure,
% imshow(img)
% title('gamma mapped')

% reduces noise by applying a box function blur using convolution
img = reduceNoise(img, isoValforNoise);

% figure,
% imshow(img)
% title('noise reduction')

% returns final image after processing pipeline
img = img;

% saves image as a png file
% imwrite(img, 'final.png');

