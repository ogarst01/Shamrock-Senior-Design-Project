function result = reduceNoise(img)
% Note: This noise reduction is best for overall noise and less effective
% on salt and pepper noise. This makes sense (and
    
% instead of a gaussian blur:   
    % convolve with a box function of width 5 and width 1/25 (to average
    % to get the average of nearby pixels:
    blurredimg = convn(img, ones(5)/25, 'same');

    % returns result image
    result = blurredimg;
end

