function imageEdges = multiscaleWavelet(image)
%{
Senior Design
Team Shamrock
Melissa Rowland
12/6/20
TODO: better documentation
%}

scaleMax = 5; %maximum level of wavelet scale
[row, col] = size(image);

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

imageEdges = zeros(row, col);
edgeIdx = find(e > 10^5);
imageEdges(edgeIdx) = 256;
end