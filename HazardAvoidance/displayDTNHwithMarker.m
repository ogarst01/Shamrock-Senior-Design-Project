function displayDTNHwithMarker(xCoord, yCoord, distanceMap)
%{
Senior Design
Team Shamrock
Melissa Rowland
3/22/21

inputs:
xCoord - x coordinate of optimal landing site (in pixels)
yCoord - y coordinate of optimal landing site (in pixels)
distanceMap - map of distances to nearest hazard (in pixels)

outputs:
none

purpose:
Display the results of HDA by showing the chosen landing site on top of the
distance to nearest hazard map.

questions/future improvements:
-make cross hairs actual size of lander
%}

%If no safe landing site available, xCoord and yCoord are empty []
[xSize, ~] = size(xCoord);
[ySize, ~] = size(yCoord);

%If safe landing site is available, display on top of DTNH map
if xSize > 0 && ySize > 0
    figure
    image(distanceMap)
    hold on
    plot(xCoord, yCoord, 'r+', 'MarkerSize', 10, 'LineWidth', 2)
    title('DTNH Map with Chosen Site')
end

end