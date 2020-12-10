function image = gammaMap(image, isoVal)
    % I did some testing on the gamma map function. I found that darker
    % images, which have a higher ISO value than lighter images, 
    % (for example, newyear.csv shows a ISO value of 3200, while apples
    % shows an ISO value of 1600), need a higher value of gamma for the
    % gammaMapping. I took apples to be the baseline assumption
    % case. Using this image, I found a good gamma mapping value
    % Working backwards, I used another image's baseline value (yosemite)
    % to create an equation for gamma in terms of the iso value. I found it
    % interesting that my gamma mapping looked best with almost minimal
    % mapping. This is likely because a lot of the work done is gamma
    % mapping I implemented in blacklevel correction. I found during this
    % homework that often times, gamma mapping reversed the effects of
    % black level correction. Due to such minimal gamma mapping, I decided
    % that camera curve would not be very useful here. 
    
    % produce some gamma value based on the ISO value: 
    gamma1 = 1 + (0.05*isoVal/200);

    % map the image 
    imgGamma1 = image.^(1./gamma1);
    
    % return gamma mapped image
    image = imgGamma1;
end

