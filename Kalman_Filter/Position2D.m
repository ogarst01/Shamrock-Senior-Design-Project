classdef Position2D
    %POSITION2D create position tracking matrices in 2 dimensions to feed Kalman Filter
%     
%     A: State transition matrix
%     B: Control matrix
%     H: Observation matrix
%     x: Initial state estimate
%     P: Initial covariance estimate
%     Q: Covariance noise
%     R: Sensor covariance
%     W: accelerometer noise
%     
    
    properties
        delT         % Time step
        sigp         % Position measurement noise
        siga         % Acceleration measurement noise (m/s^2)
        sig_TRN      % TRN noise
        siga_proc    % Process noise
    end
    
    methods
        function [A,B,H,P,Q,R,W,V] = CreateFiltObj(obj)
            A = [1, obj.delT, 0,          0;
                 0,        1, 0,          0;
                 0,        0, 1,   obj.delT;
                 0,        0, 0,         1];
            B = [obj.delT^2/2,            0; 
                     obj.delT,            0;
                            0, obj.delT^2/2; 
                            0,     obj.delT]; % this is right  
            H = [1, 0, 0, 0;
                 0, 0, 1, 0];
            Q = [(obj.delT^4/4)*obj.sigp^2, (obj.delT^3/2)*obj.sigp^2,                         0,                         0;
                 (obj.delT^3/2)*obj.sigp^2,     obj.delT^2*obj.sigp^2,                         0,                         0;
                                         0,                         0, (obj.delT^4/4)*obj.sigp^2, (obj.delT^3/2)*obj.sigp^2;
                                         0,                         0, (obj.delT^3/2)*obj.sigp^2,     obj.delT^2*obj.sigp^2];
            
            R = obj.sig_TRN^2.*eye(2);
            P = [obj.sig_TRN^2,   0,              0,    0;
                 0,             0.05,             0,    0;
                 0,                0, obj.sig_TRN^2,    0;
                 0,                0,             0, 0.05];
            V = (obj.siga_proc * obj.delT)^2 * eye(2);
            W = (obj.siga^2)*eye(2);
        end
    end
end