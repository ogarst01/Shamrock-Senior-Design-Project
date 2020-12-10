function img = isp(raw, metadata)

% grabs iso values from the .csv data provided
iso = metadata_value(metadata, 'ISO');

% stores iso value as a number 
isoVal = str2num(iso);

% inputs a .tif file that increases contrast and outputs a .tif file:
img = blacklevel(raw);
    
% demosaics the inputted matrix of intensities, outputs an RGB matrix
img = isp_demosaic(img);

% color corrects, using both RGB gray world assumption and HSV colorspace
img = colorcorrection(img);

% gamma maps image 
img = gammaMap(img, isoVal);

% reduces noise by applying a box function blur using convolution
img = reduceNoise(img);

% returns final image after processing pipeline
img = img;

% saves image as a png file
imwrite(img, 'ee193finalImage.png');

