%% Generate IMU Data
N = 1000;
Fs = 100;
Fc = 0.25;
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

filt = KalmanFilter;





