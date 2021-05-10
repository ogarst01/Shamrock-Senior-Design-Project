function plotIMU(t, imu_data, plot_integrated)
%plotIMU Plots IMU data
%
% t
%   time vector
%
% imu_data
%   N x 2 vector of accelerometer data

if nargin < 3
    plot_integrated = false;
end

figure('name', 'Accelerometer Data')
plot(t, imu_data)
title('IMU data')
xlabel('time (s)')
ylabel('acceleration (m/s^2)')
legend('y IMU data', 'z IMU data')

figure('name', 'Accelerometer Times')
plot(t(1:end-1), diff(t), '.')
title('Delta IMU Time (s)')
xlabel('time (s)')

%% Position
if plot_integrated
    dt_IMU = mean(diff(t));
    v = cumsum(imu_data * dt_IMU, 1);
    r = cumsum(v * dt_IMU, 1);
    
    imu_pos = zeros(size(imu_data));
    
    imu_pos(:,1) = integrate_IMU(imu_data(:,1), dt_IMU);
    imu_pos(:,2) = integrate_IMU(imu_data(:,2), dt_IMU);
    
    figure
    subplot(2,1,1)
    %plot(imu_pos(:,1),imu_pos(:,2));
    hold on
    plot(r(:,1),r(:,2));
    title('2D Position of integrated IMU data')
    
    subplot(2,1,2)
    plot(t, v);
    title('Velocity of integrated IMU data')
end
end

