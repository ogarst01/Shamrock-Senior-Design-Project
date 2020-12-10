function quantG = compress(img, numBits)

% define the thresholds to use: 
thresholds = multithresh(img,numBits);

% define vector of values:
value = [0 thresholds(2:end) 1];

% quantize the image:
quantR = imquantize(img(:,:,1), thresholds, value);
quantG = imquantize(img(:,:,2), thresholds, value);
quantB = imquantize(img(:,:,3), thresholds, value);

sizeM = size(img);

%quantRGB = cat(sizeM(3), quantR(:,:,1), quantG(:,:,1), quantB(:,:,1));

figure, 
imshow(quantR)

figure, 
imshow(quantG)

figure, 
imshow(quantB)

end

