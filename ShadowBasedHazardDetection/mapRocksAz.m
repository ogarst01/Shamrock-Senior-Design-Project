function hazardMapOut = mapRocksAz(shadowBoundaries, rockHeight, rockDiameter, sunAzimuthAngle, heightThreshold, hazardMapIn, m1, m2, minPoint, maxPoint, origImage)
%{
Senior Design
Team Shamrock
Melissa Rowland
Updated: 4/11/21

inputs: 
shadowBoundaries - boundary pixels of shadow in image
rockHeight - estimated height of the rock
rockDiameter - estimated diameter of the rock
sunAzimuthAngle - azimuth angle of the sunlight [must be b/t 0 and 360
                  degrees]
heightThreshold - threshold value for determining if rock is hazardous
hazardMapIn - binary map of existing hazard locations. If this rock is
              hazardous, it will be added.
m1 - slope of line at azimuth angle
m2 - slope of line perpendicular to m1
origImage - original image, used for debugging plotting if needed

outputs: 
hazardMapOut - binary map of hazard locations. '1' marks hazard, '0' marks
            safe

purpose:
Based on shadow boundary, direction of the sun, and the size of the rock
make a hazard map of estimated rock location.

current model:
-along line of sunlight, assumes rock starts at edge of shadow
-along other axis, assumes midpoint of rock position is average
-does not consider the shadow region itself as hazardous

questions/future improvements:
-consider the shadow as a hazard
%}

hazardMapOut = hazardMapIn;
mapSize = size(hazardMapIn);
rockRad = round(rockDiameter / 2);

%if above threshold, map that rock on hazard map
if rockHeight >= heightThreshold
   %compute average point
   avg_x = round(mean(shadowBoundaries(:,2)));
   avg_y = round(mean(shadowBoundaries(:,1)));
   
   %compute sides of triangles that will lead to corner points
   run1 = sqrt(rockRad^2 / (1 + 1/m1^2));
   rise1 = sqrt(rockRad^2 / (1 + (m1^2)));
   run2 = sqrt(rockRad^2 / (1 + m2^2));
   rise2 = sqrt(rockRad^2 / (1 + 1/(m2^2)));
   
   %find two corner points of perpendicular line thru point
   %find two corner points of lines perpendicular to those points
   if sunAzimuthAngle >= 0 && sunAzimuthAngle < 90
       %QI
       %find two corner points of perpendicular line thru point
       corner1 = maxPoint + [-rise2, -run2];
       corner2 = maxPoint + [rise2, run2];
       corner3 = corner1 + [2 * rise1, -2 * run1];
       corner4 = corner2 + [2 * rise1, -2 * run1];

       %{
       figure
       imshow(origImage)
       hold on
       plot(maxPoint(1), maxPoint(2), 'rx')
       plot([corner1(1), corner2(1)], [corner1(2), corner2(2)], 'g')
       plot(corner3(1), corner3(2), 'cx')
       plot(corner4(1), corner4(2), 'bx')
       plot([corner1(1), corner3(1)], [corner1(2), corner3(2)], 'g')
       plot([corner2(1), corner4(1)], [corner2(2), corner4(2)], 'g')
       plot([corner3(1), corner4(1)], [corner3(2), corner4(2)], 'g')
       hold off
       %}
   elseif sunAzimuthAngle >= 90 && sunAzimuthAngle < 180
       corner1 = maxPoint + [-rise2, run2];
       corner2 = maxPoint + [rise2, -run2];
       corner3 = corner1 + [-2 * rise1, -2 * run1];
       corner4 = corner2 + [-2 * rise1, -2 * run1];

       %{
       figure
       imshow(origImage)
       hold on
       plot(maxPoint(1), maxPoint(2), 'rx')
       plot([corner1(1), corner2(1)], [corner1(2), corner2(2)], 'g')
       plot(corner3(1), corner3(2), 'cx')
       plot(corner4(1), corner4(2), 'bx')
       plot([corner1(1), corner3(1)], [corner1(2), corner3(2)], 'g')
       plot([corner2(1), corner4(1)], [corner2(2), corner4(2)], 'g')
       plot([corner3(1), corner4(1)], [corner3(2), corner4(2)], 'g')
       hold off
       %}
   elseif sunAzimuthAngle >=180 && sunAzimuthAngle < 270
       corner1 = minPoint + [rise2, run2];
       corner2 = minPoint + [-rise2, -run2];
       corner3 = corner1 + [-2 * rise1, 2 * run1];
       corner4 = corner2 + [-2 * rise1, 2 * run1];

       %{
       figure
       imshow(origImage)
       hold on
       plot(minPoint(1), minPoint(2), 'rx')
       plot([corner1(1), corner2(1)], [corner1(2), corner2(2)], 'g')
       plot(corner3(1), corner3(2), 'cx')
       plot(corner4(1), corner4(2), 'bx')
       plot([corner1(1), corner3(1)], [corner1(2), corner3(2)], 'g')
       plot([corner2(1), corner4(1)], [corner2(2), corner4(2)], 'g')
       plot([corner3(1), corner4(1)], [corner3(2), corner4(2)], 'g')
       hold off
       %}
   elseif sunAzimuthAngle >=270 && sunAzimuthAngle <= 360
       corner1 = minPoint + [-rise2, run2];
       corner2 = minPoint + [rise2, -run2];
       corner3 = corner1 + [2 * rise1, 2 * run1];
       corner4 = corner2 + [2 * rise1, 2 * run1];

       %{
       figure
       imshow(origImage)
       hold on
       plot(minPoint(1), minPoint(2), 'rx')
       plot([corner1(1), corner2(1)], [corner1(2), corner2(2)], 'g')
       plot(corner3(1), corner3(2), 'cx')
       plot(corner4(1), corner4(2), 'bx')
       plot([corner1(1), corner3(1)], [corner1(2), corner3(2)], 'g')
       plot([corner2(1), corner4(1)], [corner2(2), corner4(2)], 'g')
       plot([corner3(1), corner4(1)], [corner3(2), corner4(2)], 'g')
       hold off
       %}
   end
   
    %fill in hazard map
    xv = [corner1(1) corner3(1) corner4(1) corner2(1) corner1(1)];
    yv = [corner1(2) corner3(2) corner4(2) corner2(2) corner1(2)];
    xq = repmat(1:mapSize(2), mapSize(1),1);
    yq = repmat([1:mapSize(1)]', 1, mapSize(2));
    in = zeros(mapSize(1), mapSize(2));
    for i = 1:mapSize(1)
        in(i, :) = inpolygon(xq(i,:), yq(i,:), xv, yv);
    end
    logical_in = logical(in);
    hazardMapOut(logical_in) = 1;
    
end


%{
figure
imshow(origImage)
hold on
plot(xv, yv, 'LineWidth', 2)
logical_in = logical(in);
plot(xq(logical_in), yq(logical_in), 'r.')
hold off
%}

end