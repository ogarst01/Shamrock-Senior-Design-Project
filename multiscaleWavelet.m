function imageEdges = multiscaleWavelet(image)
%{
Senior Design
Team Shamrock
Melissa Rowland
12/6/20

inputs:
image - image to be processed
outputs:
imageEdges - processed image with edges shown in white
purpose:
Make shadows in image clear.

Based off of code in "A Wavelet Approach to Edge Detection" by Jun Li at
Sam Houston State University. See attached PDF file.

questions/future improvements:
-understand what is happening under the hood better
-experiment with different scaleMax values
%}

scaleMax = 3; %maximum level of wavelet scale
[row, col] = size(image);

%mallat's wavelet and gaussian smoothing
h1 = [1 0 -1;...
      2 0 -2;...
      1 0 -1];
h2 = [1 2 1;...
      0 0 0;...
      -1 -2 -1];
v = [1 2 1;...
     2 4 2;...
     1 2 1];
 
image1 = filter2(h1, image);
image2 = filter2(h2, image);

%apply transform at multiple scales
ns = h1;
for i = 1:scaleMax
    nsh = conv2(ns, v);
    p = max(max(ns)) / max(max(nsh));
    
    %increase scale of the wavelet
    image1h = filter2(v, image1) * p;
    image2h = filter2(v, image2) * p;
    
    %save value of nsh for recursion
    ns = nsh;
    
    %distinguish noise and real edges
    image1 = image1 .* (abs(image1)<=abs(image1h)) + image1h .* (abs(image1)<=abs(image1h));
    image2 = image2 .* (abs(image2)<=abs(image2h)) + image2h .* (abs(image2)<=abs(image2h));
end

%compute edges
e = image1 .^ 2 + image2 .^ 2;

%make edges white
imageEdges = zeros(row, col);
edgeIdx = find(e > 10^5);
imageEdges(edgeIdx) = 256;
end