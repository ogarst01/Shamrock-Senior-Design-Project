function lidarCliff = makeLidarDataCliff(m,n) 
% ok - instead of relying on image data, try geometric data:

% best data would be some step functions:

% define size: 
xS = m;
yS = n;

% make base matrix:
mat = zeros(xS,yS);

% location rock = 50% through image:
% radius rock = 10;

r = 10;
rockStart = 100*0.5;

lidarCliff = zeros(m,n);

% add a "rock"
for i = 1:xS
    for j = 1:yS
        if ((i > (rockStart - (r/2))) && (i < (rockStart + (r/2))))
            lidarCliff(i,j) = 10;
        end
    end
end

figure,
surf(lidarCliff)
shading interp


% change size to meet specifications:
lidarCliff = lidarCliff((1:m),(1:n));
end
