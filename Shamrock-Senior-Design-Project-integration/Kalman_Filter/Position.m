classdef Position
    %POSITION create position tracking matrices in 1 dimension to feed Kalman Filter
    
    properties
        delT         % Time step
        sigp         % System process noise
        siga         % Acceleration measurement noise
        sig_TRN      % TRN noise
    end
    
    methods
        function [A,B,H,P,Q,R,W] = CreateFiltObj(obj)
            A = [1,  obj.delT;
                 0,         1];
              
            B = [obj.delT^2/2; 
                 obj.delT]; 
                
            H = [1, 0];
            Q = [(obj.delT^4/4)*obj.sigp^2, (obj.delT^3/2)*obj.sigp^2;
                 (obj.delT^3/2)*obj.sigp^2,     obj.delT^2*obj.sigp^2];
                                         
            R = obj.sig_TRN^2;
            P = 1e-10*eye(2);
            W = (obj.siga * obj.delT)^2;
        end
    end
end

