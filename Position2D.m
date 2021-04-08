classdef Position2D
    %POSITION2D create position tracking matrices in 2 dimensions to feed Kalman Filter
    
    properties
        delT         % Time step
        sigp         % Position measurement noise
        siga         % Acceleration measurement noise
    end
    
    methods
        function [A,B,H,P,Q,R] = CreateFiltObj(obj)
            A = [1, 0,      -obj.delT^2/2, 0, 0,            0;
                 0, 1,          -obj.delT, 0, 0,            0;
                 0, 0,                  1, 0, 0,            0;
                 0, 0,                  0, 1, 0,-obj.delT^2/2;
                 0, 0,                  0, 0, 1,    -obj.delT;
                 0, 0,                  0, 0, 0,            1];
            B = [obj.delT^2/2; 
                 obj.delT; 
                 0;
                 obj.delT^2/2; 
                 obj.delT; 
                 0];
            H = [1, 0, 0, 0, 0, 0;
                 0, 0, 0, 1, 0, 0];
            Q = [(obj.delT^4/4)*obj.sigp^2, (obj.delT^3/2)*obj.sigp^2,   -obj.delT^2/2,                         0,                         0,             0;
                 (obj.delT^3/2)*obj.sigp^2,     obj.delT^2*obj.sigp^2,               0,                         0,                         0,             0;
                                         0,                         0,               1,                         0,                         0,             0;
                                         0,                         0,               0, (obj.delT^4/4)*obj.sigp^2, (obj.delT^3/2)*obj.sigp^2, -obj.delT^2/2;
                                         0,                         0,               0, (obj.delT^3/2)*obj.sigp^2,     obj.delT^2*obj.sigp^2,             0;
                                         0,                         0,               0,                         0,                         0,             1];
            R = obj.siga^2*eye(2);
            P = 1e-10*eye(6);
        end
    end
end

