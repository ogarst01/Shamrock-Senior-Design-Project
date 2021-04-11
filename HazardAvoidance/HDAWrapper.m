function HDAWrapper(hazardMap, params)
%{
Senior Design
Team Shamrock
Melissa Rowland
3/22/21

HDAWrapper.m

inputs:
hazardMap - binary image of hazards. '1' indicates hazard
params - struct containing info about simulation

outputs - none

purpose:
Wrapper code for hazard avoidance module.
%}

%Run hazard avoidance module
[xLand, yLand, distanceMap] = HDA1(hazardMap, params);

%Display output if desired
if params.showHDAOutput == true
    displayDTNHwithMarker(xLand, yLand, distanceMap);
end

end

