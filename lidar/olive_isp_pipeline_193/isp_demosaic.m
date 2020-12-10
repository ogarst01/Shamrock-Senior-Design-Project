function rgb = isp_demosaic(img)

    % grabs dimensions of the inputted image
    w = size(img, 2);
    h = size(img, 1);

    % "Demosaic" by downsampling the image
    %  assumes a Bayer configuration of pixels
    
    % grabs one pixel per four pixel square of red and blue:
    red = double(img(1:2:h, 1:2:w));
    blue = double(img(2:2:h, 2:2:w));
    
    % grabs all green pixels in the image
    green1 = double(img(1:2:h, 2:2:w));
    green2 = double(img(2:2:h, 1:2:w));

    % interpolates using a cubic interpolation method: 
    % To note: This method inputs the average of the two green pixels into
    % the interp2 function. This improved the demosaiced image.  
    rNew = interp2(double(red), 1, 'cubic');
    gNew = interp2(double((green1 + green2).*0.5), 1, 'cubic');
    bNew = interp2(double(blue), 1, 'cubic');

    % concatenates all the color channels and rescales:
    rgb = cat(3, rNew, gNew, bNew);
    rgb = rescale(rgb);

