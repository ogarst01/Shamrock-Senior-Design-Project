%% Generate IMU Data
clear
%close all


N = 500;
Fs = 100;

params = accelparams('RandomWalk',[0.2 0.1 0.03]);

t = (0:(1/Fs):((N-1)/Fs))';
acc = zeros(N,3);
angvel = zeros(N,3);
acc(:,1) = 2;
acc(:,2) = .5*t;
acc(:,3) = 0;


IMU = imuSensor('SampleRate',Fs,'Accelerometer',params);

[accData, gyroData] = IMU(acc, angvel);

accData = -accData;

for i = 1: length(accData)
    
end



% figure
% plot3(angvel(:,1), angvel(:,2), angvel(:,3), '--', gyroData(:,1), gyroData(:,2), gyroData(:,3))
% xlabel('x')
% ylabel('y')
% zlabel('z')
% zlim([0 7])
% title('Generated IMU Data')
% legend('x (ground truth)', 'x (gyroscope)')



%% Load TRN Data



%% Run filter 1D


filt = KalmanFilter;

pos = Position;

T = N;
pos.delT = 1;
pos.siga = 10;
pos.sigp = 0.5;
x = [0;0;0];
u = 1;
kalman = zeros(3,T);

[A,B,H,P,Q,R] = CreateFiltObj(pos);
filt = SetKF(filt,x,A,B,H,P,Q,R);

% for i = 1:T
%     kalman2(:,i) = filt.x;
%     filt = Step(filt,u,transpose(accData(i,2)));
% end

% for i = 1:T/50
%     %accData(i*50-49,1) = 2;  
%     for j = 1:50
%         %kalman2(:,50*i+j-50) = filt.x;
%         filt = Step(filt,u,transpose(accData(50*i+j-50,1)));
%         kalman2(:,50*i+j-50) = filt.x;
%         50*i+j-50;
%     end  
% end

for i = 1:T
    if mod(i,50) ~= 0
        kalman2(:,i) = filt.x;
        filt = Step(filt,u,transpose(accData(i,2)));
    else
        accData(i,2) = acc(i,2);
        kalman2(:,i) = filt.x;
        filt = Step(filt,u,accData(i,2));     
    end
    
    
    
end




figure
t = 0:T-1;
hold on 
plot(t,acc(:,2))
%plot(t,kalman1(1,:))
plot(t,kalman2(1,:))
plot(t,accData(:,2))
legend('true','KF2','IMU')
xlabel('Time')
ylabel('Position')
title('Kalman Filter 1D Position Correction')
hold off

%% 2D

filt = KalmanFilter;

pos = Position2D;

T = N;
pos.delT = 1;
pos.siga = 50;
pos.sigp = 0.005;
x = [2;0;0;0;0;0];
u = 1;
kalman = zeros(6,T);

[A,B,H,P,Q,R] = CreateFiltObj(pos);
filt = SetKF(filt,x,A,B,H,P,Q,R);

for i = 1:T
    kalman(:,i) = filt.x;
    filt = Step(filt,u,[accData(i,1);accData(i,2)]);
end

figure
t = 0:T-1;
hold on 
plot3(t,acc(:,1),acc(:,2))
%plot(t,kalman1(1,:))
plot3(t,kalman(1,:)',kalman(2,:)')
plot3(t,accData(:,1), accData(:,2))
legend('true','KF2','IMU')
xlabel('Time')
ylabel('x pos')
zlabel('y pos')
title('Kalman Filter 2D Position Correction')
