function length = computeShadowSize(image_boundaries, axis)
%note - currently only works for image with one shadow
%needs input as output of find_boundaries function
%currently only works along one axis

if(axis == 'y')
    length = max(image_boundaries(:,2)) - min(image_boundaries(:,2));
elseif(axis == 'x')
    length = max(image_boundaries(:,1)) - min(image_boundaries(:,1));
else
    length = 0;
end

end