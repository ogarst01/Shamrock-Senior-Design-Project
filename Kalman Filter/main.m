%% Generate IMU Data
N = 1000;
Fs = 100;

params = gyroparams('RandomWalk',[0.2 0 0.03]);

t = (0:(1/Fs):((N-1)/Fs))';
acc = zeros(N,3);
angvel = zeros(N,3);
angvel(:,1) = 2*t;
angvel(:,2) = t;
angvel(:,3) = 5;


IMU = imuSensor('SampleRate',Fs,'Gyroscope',params);

[~, gyroData] = IMU(acc, angvel);

figure
plot3(angvel(:,1), angvel(:,2), angvel(:,3), '--', gyroData(:,1), gyroData(:,2), gyroData(:,3))
xlabel('x')
ylabel('y')
zlabel('z')
zlim([0 7])
title('Generated IMU Data')
legend('x (ground truth)', 'x (gyroscope)')



%% Load TRN Data



%% Run filter
clear;
clc;

filt = KalmanFilter;

pos = Position;

T = 1000;
pos.delT = 1;
pos.siga = 0;
pos.sigp = 0;
x = [0; 0; 0];
u = 1;
z = 0.1;
kalman = zeros(3,T);

[A,B,H,P,Q,R] = CreateFiltObj(pos,T);
filt = SetKF(filt,x,A,B,H,P,Q,R);

for i = 1:T
    kalman(:,i) = filt.x;
    filt = Step(filt,u,z);
end

plot3(kalman(1,:),kalman(2,:),kalman(3,:))



