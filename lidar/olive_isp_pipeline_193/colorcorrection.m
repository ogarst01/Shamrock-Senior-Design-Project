function result = colorcorrection(img)
% My color correction function is the most complex function in the image
% processing pipeline. It has three stages:
% 1. Use the gray world assumption, and scale all color channels by the
% green channel in order to have the sum of all the color channels equal to
% the same value. 
% 2. Turn the rgb image into hsv space and scale the saturation values by the
% saturation factor. This increases the intensity of the colors in the
% image. Then, transform the image back into rgb space. 

   % define some scale factor for the hues in the image:
   saturFactor = 1.2;
  
%    % grab the R,G and B channels from the image
%    R = img(:,:,1);
%    G = img(:,:,2);
%    B = img(:,:,3);
%    
   imageFinal = img;
   % average each color channel
%    averageR = mean(R(:));
%    averageG = mean(G(:));
%    averageB = mean(B(:));
%     
%    % scale each channel according to the green channel's average value. 
%    Rnew = (R.*averageG./averageR);
%    Gnew = G;
%    Bnew = B.*averageG./averageB;
%    
%    % concatenate all the scaled channels to create an RGB image:
%    imageFinal = cat(3, Rnew, Gnew, Bnew); 
%     
    % convert the image into HSV (hue, saturation, value) space
    hsvIm = rgb2hsv(imageFinal);
    
    % grab the saturation channel 
    satchannl = hsvIm(:,:,2);
    
    % scale this channel by an appropriate value to make colors pop in the
    % image
    satchannl = satchannl.*saturFactor;
    
    % concatenate the new image in HSV space
    hsvSat = cat(3, hsvIm(:,:,1), satchannl, hsvIm(:,:,3));
    
    % convert the image from hsv to rgb space
    imageFinal = hsv2rgb(hsvSat);
 
% return image 
result = imageFinal;   


  
   