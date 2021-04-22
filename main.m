%% Generate IMU Data
clear
%close all


N = 1000;
Fs = 100;
delT = 0.1;

params = accelparams('RandomWalk',[0.02 0.01 0.003]);

t = (0:(1/Fs):((N-1)/Fs))';
acc = zeros(N,3); 
angvel = zeros(N,3);
acc(:,1) = 0.2;
acc(:,2) = .5*t;
acc(:,3) = 0;

z_true = integrate_IMU(acc(:,1), 0.1);

IMU = imuSensor('SampleRate',Fs,'Accelerometer',params);

[accData, gyroData] = IMU(acc, angvel);

accData = -accData;




% figure
% plot3(angvel(:,1), angvel(:,2), angvel(:,3), '--', gyroData(:,1), gyroData(:,2), gyroData(:,3))
% xlabel('x')
% ylabel('y')
% zlabel('z')
% zlim([0 7])
% title('Generated IMU Data')
% legend('x (ground truth)', 'x (gyroscope)')


%% Load IMU Data

[time_array, test_data_array] = readingIMUData('April5_IMUtest.txt');
time_array = time_array(2:end,:);
test_data_array = test_data_array(2:1030,:); % 2:1030 hard coded for this data set. B/c end of video w/ some trash

figure
plot(test_data_array)
legend('y', 'z')

%% Load TRN Data



%% Run filter 1D


filt = KalmanFilter;

pos = Position;

T = size(test_data_array, 1);
pos.delT = delT;
pos.siga = 0.5;
pos.sigp = 0.0005;
pos.sig_TRN = 0.5; % meters
x = [0;0];
kalman = zeros(2,T);

z_imu = integrate_IMU(test_data_array,delT);

[A,B,H,P,Q,R,W] = CreateFiltObj(pos);
filt = SetKF(filt,x,A,B,H,P,Q,R,W);

% filt = Step(filt,u,accData(i,1));
% kalman(:,1) = filt.x;
% for i = 1:T
%     filt = Step(filt,u,imu_pos(i));
%     kalman(:,i) = filt.x;
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

%filt = Step(filt,imu_pos(1));
%kalman(:,1) = filt.x;
for i = 2:T
    filt = Predict(filt, test_data_array(i,1));
    if mod(i,100) == 0
        filt = Step(filt,z_imu(i));
    end
    kalman(:,i) = filt.x;
end




figure
t = 0:T-1;
hold on 
%plot(t,z_true)
plot(t,kalman(1,:))
%plot(t,z_imu)
legend('KF')
xlabel('Time')
ylabel('Position')
title('Kalman Filter 1D Position Correction')
grid on
box on
hold off

%% 2D

filt = KalmanFilter;

pos = Position2D;

T = N;
pos.delT = 1;
pos.siga = 50;
pos.sigp = 0.005;
x = [0;0;0;0;0;0];
u = 1;
kalman = zeros(6,T);

[A,B,H,P,Q,R,W] = CreateFiltObj(pos);
filt = SetKF(filt,x,A,B,H,P,Q,R,W);

for i = 1:T
    kalman(:,i) = filt.x;
    filt = Step(filt,u,[accData(i,1);accData(i,2)]);
end

% for i = 2:T
%     filt = Predict(filt, accData(i,1));
%     if mod(i,100) == 0
%         filt = Step(filt,z_true(i));
%     end
%     kalman(:,i) = filt.x;
% end

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
