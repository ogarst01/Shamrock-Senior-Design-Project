classdef KalmanFilter
        properties
            A                        % State transition matrix
            B                        % Control matrix
            H                        % Observation matrix
            x                        % Initial state estimate
            P                        % Initial covariance estimate
            Q                        % Covariance noise
            R                        % Sensor covariance  
        end
        
        methods
            function obj = SetKF(obj,x,A,B,H,P,Q,R)
                obj.x = x;
                obj.A = A;
                obj.B = B;
                obj.H = H;
                obj.P = P;
                obj.Q = Q;
                obj.R = R;
            end
            function obj = Step(obj,u, z)
                % Prediction Step
                xnext = obj.A * obj.x + obj.B * u;
                Pnext = (obj.A * obj.P) * transpose(obj.A) + obj.Q;
                % Observation Step
                y = z - obj.H * xnext;
                sigma = obj.H * Pnext * transpose(obj.H) + obj.R;
                % Update Step
                K = Pnext * transpose(obj.H) / sigma;
                obj.x = xnext + K * y;
                obj.P = (eye(size(obj.P)) - K * obj.H) * Pnext;
            end
        end    
end