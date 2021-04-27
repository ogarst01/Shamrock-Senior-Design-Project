classdef Position2D
    %POSITION2D create position tracking matrices in 2 dimensions to feed Kalman Filter
    
    properties
        delT         % Time step
        sigp         % Position measurement noise
        siga         % Acceleration measurement noise (m/s^2)
        sig_TRN      % TRN noise
    end
    
    methods
        function [A,B,H,P,Q,R,W] = CreateFiltObj(obj)
            A = [0, obj.delT, 0,          0;
                 0,        1, 0,          0;
                 0,        0, 1,   obj.delT;
                 0,        0, 0,         1];
            B = [obj.delT^2/2; 
                 obj.delT; 
                 obj.delT^2/2; 
                 obj.delT];
            H = [1, 0, 0, 0;
                 0, 0, 1, 0];
            Q = [(obj.delT^4/4)*obj.sigp^2, (obj.delT^3/2)*obj.sigp^2,                         0,                         0;
                 (obj.delT^3/2)*obj.sigp^2,     obj.delT^2*obj.sigp^2,                         0,                         0;
                                         0,                         0, (obj.delT^4/4)*obj.sigp^2, (obj.delT^3/2)*obj.sigp^2;
                                         0,                         0, (obj.delT^3/2)*obj.sigp^2,     obj.delT^2*obj.sigp^2];
            R = obj.sig_TRN^2 .* eye(2);
            P = 1e-10*eye(4);
            W = (obj.siga * obj.delT)^2;
        end
    end
end

