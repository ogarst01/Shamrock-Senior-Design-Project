classdef KalmanFilter
        properties
            A                        % State transition matrix
            B                        % Control matrix
            H                        % Observation matrix
            x                        % Initial state estimate
            P                        % Initial covariance estimate
            Q                        % Covariance noise
            R                        % Sensor covariance
            W                        % accelerometer noise
        end
        
        methods
            function obj = SetKF(obj,x,A,B,H,P,Q,R, W)
                obj.x = x;
                obj.A = A;
                obj.B = B;
                obj.H = H;
                obj.P = P;
                obj.Q = Q;
                obj.R = R;
                obj.W = W;
            end
            
            function obj = Predict(obj, z_imu)
                % Prediction Step
                obj.x = obj.A * obj.x + obj.B * z_imu;
                %Q_imu = obj.B * obj.Q * transpose(obj.B);
                obj.P = (obj.A * obj.P) * transpose(obj.A) + obj.Q + obj.B * obj.W * transpose(obj.B); 
            end
            
            function obj = Step(obj, z)
                % Observation Step
                y = z - obj.H * obj.x;
                sigma = obj.H * obj.P * transpose(obj.H) + obj.R;
                % Update Step
                K = obj.P * transpose(obj.H) / sigma;
                obj.x = obj.x + K * y;
                obj.P = (eye(size(obj.P)) - K * obj.H) * obj.P;
            end
            
        end    
end