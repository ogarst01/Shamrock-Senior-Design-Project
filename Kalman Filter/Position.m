classdef Position
    %POSITION create position tracking matrices to feed Kalman Filter
    
    properties
        delT         % Time step
        sigp         % Position measurement noise
        siga         % Acceleration measurement noise
    end
    
    methods
        function [A,B,H,P,Q,R] = CreateFiltObj(obj,T)
            A = [1,  obj.delT, -T^2/2;
                 0,  1,        -T;
                 0,  0,         1];
            B = [T^2/2; 
                 T; 
                 0];
            H = [1, 0, 0];
            Q = [(T^4/4)*obj.sigp^2, (T^3/2)*obj.sigp^2,   -T^2/2;
                 (T^3/2)*obj.sigp^2,  T^2*obj.sigp^2,       0;
                 0,               0,                1];
            R = obj.siga;
            P = eye(3);
        end
    end
end

