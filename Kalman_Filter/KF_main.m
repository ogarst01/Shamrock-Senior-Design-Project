function KF_main()
    %% GLOBAL CONSTANTS: 
    % April 5 = VIDEO_LENGTH = 1030; % length of important usable frames from the videos
    % April 16 = VIDEO_LENGTH = 139 seconds * sample rate? -> 5 frames per
    % sample... 
    %% Generate IMU Data
    %clear
    %close all
 
    %N = 1000;
    %Fs = 100;
    delT = 0.1;
    
     %% Load IMU Data
 
    cd ..
    cd Data
    cd IMU_data
    
    [time_array, test_data_array] = readingIMUData('april16_run');
    
    test_data_array(:,1) = test_data_array(:,1) - mean(test_data_array(:,1));
    test_data_array(:,2) = test_data_array(:,2) - mean(test_data_array(:,2));
    
    cd ..
    cd ..
    cd Kalman_Filter
 
    time_array = time_array(2:end,:);
    % test_data_array = test_data_array(2:VIDEO_LENGTH,:); % 2:1030 hard coded for this data set. B/c end of video w/ some trash
 
    figure
    plot(test_data_array)
    title('IMU data for april 16 run')
    xlabel('time')
    ylabel('acceleration')
    legend('y IMU data', 'z IMU data')
    
    data_rate_IMU = 10;
 
    %%
    imu_pos = zeros(size(test_data_array));
    
    imu_pos(:,1) = integrate_IMU(test_data_array(:,1),0.1);
    imu_pos(:,2) = integrate_IMU(test_data_array(:,2),0.1);
    
    plot(imu_pos(:,1),imu_pos(:,2));
    
    
    %% Load TRN Data
    cd ..
    cd TRN
    cd saved_run_data
    
    TRN_coords_pre = load('TRN_cord_april16_run2.mat');
    TRN_coords = TRN_coords_pre.coords_vec;
 
    cd .. 
    cd ..
    cd Kalman_Filter
    
    set_size = [46, 14];  %inches
    set_size = set_size.*0.0254; % converts to meters
    % change pixel coords into meters first: 
    x_pix = 2720;
    y_pix = 1530;
    x_meters = set_size(1);
    y_meters = set_size(2);
 
    % Define conversion rate, number of pixels per meter
    cx = x_meters/x_pix;
    cy = y_meters/y_pix; 
 
    TRN_coord_m(:,1) = TRN_coords(:,1).*cx;
    TRN_coord_m(:,2) = TRN_coords(:,2).*cy;
    
    % TRN data rate
    data_rate_TRN = 5;
 
%     %% Run filter 1D
% 
% 
%     filt = KalmanFilter;
% 
%     pos = Position;
% 
%     T = length(test_data_array);
%     pos.delT = delT;
%     pos.siga = 0.5;
%     pos.sigp = 0.0005;
%     pos.sig_TRN = 0.5; % meters
%     x = [0;0];
%     kalman = zeros(2,T);
% 
%     z_imu = integrate_IMU(test_data_array,delT);
% 
%     [A,B,H,P,Q,R,W] = CreateFiltObj(pos);
%     filt = SetKF(filt,x,A,B,H,P,Q,R,W);
% 
%     % filt = Step(filt,u,accData(i,1));
%     % kalman(:,1) = filt.x;
%     % for i = 1:T
%     %     filt = Step(filt,u,imu_pos(i));
%     %     kalman(:,i) = filt.x;
%     % end
% 
%     % for i = 1:T/50
%     %     %accData(i*50-49,1) = 2;  
%     %     for j = 1:50
%     %         %kalman2(:,50*i+j-50) = filt.x;
%     %         filt = Step(filt,u,transpose(accData(50*i+j-50,1)));
%     %         kalman2(:,50*i+j-50) = filt.x;
%     %         50*i+j-50;
%     %     end  
%     % end
% 
%     %filt = Step(filt,imu_pos(1));
%     %kalman(:,1) = filt.x;
%     
%     % if the data was taken about 1 measurement per IMU measurement:
%     % downsample by 1
%     
%     TRN_coord_x_2(:,1) = TRN_coord_m(:,1);%downsample(TRN_coord_m(:,1),5);
% 
%     update_on = 10;
%     
%     count = 1;
%     for i = 2:T
%         filt = Predict(filt, test_data_array(i,1));
%         if mod(i,update_on) == 0
%             filt = Step(filt, TRN_coord_x_2(count,1));
%             count = count + 1;
%         end
%         kalman(:,i) = filt.x;
%     end
% 
% 
% 
% 
%     figure
%     t = 0:T-1;
%     hold on 
%     %plot(t,z_true)
%     plot(t,kalman(1,:))
%     %plot(t,z_imu)
%     legend('KF')
%     xlabel('Time')
%     ylabel('Position')
%     title('Kalman Filter 1D Position Correction')
%     grid on
%     box on
%     hold off
 
    %% 2D
    filt = KalmanFilter;
 
    pos = Position2D;
 
    T = length(test_data_array);
    pos.delT = 0.1;
    pos.siga = 0.5;
    pos.sigp = 0.0005;
    pos.sig_TRN = 0.5; % meters
    x = [0;0;0;0];
    kalman = zeros(4,T);
 
    % z_imu_y = integrate_IMU(test_data_array(:,1),delT);
    % z_imu_z = integrate_IMU(test_data_array(:,2),delT);
 
    z_imu_y = test_data_array(:,1);
    z_imu_z = test_data_array(:,2);
 
    [A,B,H,P,Q,R,W] = CreateFiltObj(pos);
    filt = SetKF(filt,x,A,B,H,P,Q,R,W);
 
    RefreshRate_2d = 10;
    data_ratio = data_rate_TRN/data_rate_IMU * RefreshRate_2d;
 
    for i = 1:T
        filt = Predict(filt, test_data_array(i,:)');
        % TODO not sure this is working? 
        count = 1;
        
        if mod(i,RefreshRate_2d) == 0
            filt = Step(filt,[TRN_coord_m(data_ratio * count,1); TRN_coord_m(data_ratio * count,2)]);
            count = count + 1;
        end
        kalman(:,i) = filt.x;
    end
    
    
    figure
    
    TRN_coord_m_plot(:,1) = downsample(TRN_coord_m(:,1),2);
    TRN_coord_m_plot(:,2) = downsample(TRN_coord_m(:,2),2);
 
    hold on 
    plot(kalman(1,:),kalman(2,:))
    plot(TRN_coord_m_plot(:,1),TRN_coord_m_plot(:,2))
 
    legend('KF2','TRN coords')
    xlabel('x pos')
    ylabel('y pos')
    title('Kalman Filter 2D Position Correction')
    grid on
    box on
    hold off
    
%     figure, 
%     hold on 
%     %plot(t,z_true)
%     % plot3(t,kalman(1,:)',kalman(2,:)')
%     plot3(t,TRN_coord_m_plot(:,1),TRN_coord_m_plot(:,2))
%     plot3(t,z_imu_y, z_imu_z)
%     %plot3(t,accData(:,1), accData(:,2))
%     %plot(t,z_imu)
%     legend('TRN coords','IMU')
%     xlabel('Time')
%     ylabel('x pos')
%     zlabel('y pos')
%     title('Kalman Filter 2D Position Correction')
%     grid on
%     box on
%     hold off
%     
end