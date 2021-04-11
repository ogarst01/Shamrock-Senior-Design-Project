function [imout,lidarRock] = makeLidarDataRock(m,n)
% outputs 2 rock types:
% 1 made with convolution (imout)
% 1 made with gauss filtering (smoother) (lidarRock)

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
lidarRock = zeros(xS,yS);
% add a "rock"
for i = 1:xS
    for j = 1:yS
        if (((i > (rockStart - (r/2))) && (i < (rockStart + (r/2)))) && ((j > (rockStart - (r/2))) && (j < (rockStart + (r/2)))))
            lidarRock(i,j) = 100;
        end
    end
end

LPH = ones(30,30);
imout = conv2(LPH, lidarRock);

figure,
surf(imout)
title('rock with convolution')
shading interp

lidarRock = imgaussfilt(lidarRock, 10);

figure,
surf(lidarRock)
shading interp
title('rock gauss filter')

end

