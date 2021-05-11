function KF_main()
    %% Parameters
    clear
    close all
    clc
 
    % position/IMU kf params
    delT = 0.1;
    siga = 0.5;
    sigp = 0.0005;
    sig_TRN = 0.2; % meters
    siga_proc = 1;
    
    % refresh rate params
    data_rate_IMU = 10;
    data_rate_TRN = 5;
    RefreshRate_2d = 10;
   
    
     %% Load IMU Data
 
    addpath(genpath(fullfile('..','Data')));
    [time_array, test_data_array] = readingIMUData(fullfile('..','Data','IMU_Data','april16_run'));
    
    % normalize IMU data
    test_data_array(:,1) = test_data_array(:,1) - mean(test_data_array(:,1));
    test_data_array(:,2) = test_data_array(:,2) - mean(test_data_array(:,2));
 
    figure
    plot(test_data_array)
    title('Noramlized IMU data for april 16 run')
    xlabel('time')
    ylabel('acceleration')
    legend('y IMU data', 'z IMU data')
    
   
    %% Load TRN Data
    
    addpath(genpath(fullfile('..','Data')));
    TRN_coords_pre = load(fullfile('..','TRN','saved_run_data','TRN_cord_april16_run2.mat'));
    TRN_coords = TRN_coords_pre.coords_vec;
 
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
    
    
    %% 2D
    
    % create classes
    filt = KalmanFilter;
    pos = Position2D;
 
    % define position class params
    T = length(test_data_array);
    pos.delT = delT;
    pos.siga = siga;
    pos.sigp = sigp;
    pos.sig_TRN = sig_TRN; % meters
    pos.siga_proc = siga_proc;
   
    % initial x estimate (april 16th data)
    x = [TRN_coord_m(1,1);0;TRN_coord_m(1,2);0];
    kalman = zeros(4,T);

    % create the KF
    [A,B,H,P,Q,R,W] = CreateFiltObj(pos);
    filt = SetKF(filt,x,A,B,H,P,Q,R,W);
 
    % find data ratio
    data_ratio = data_rate_TRN/data_rate_IMU * RefreshRate_2d;
 
    % run KF on IMU with TRN updates
    for i = 1:T
        filt = Predict(filt, test_data_array(i,:)'); 
        count = 1;
        
        if mod(i,RefreshRate_2d) == 0
            filt = Step(filt,[TRN_coord_m(data_ratio * count,1); TRN_coord_m(data_ratio * count,2)]);
            count = count + 1;
        end
        xHist(:,i) = filt.x;
        PHist(:,:,i) = filt.P;
    end

    %% Plot Settings

    set(0,'defaultAxesBox','on');
    set(0,'defaultAxesXGrid','on')
    set(0,'defaultAxesYGrid','on')
    set(0,'defaultLineLinewidth', 1.5)
    set(0,'defaultLineMarkersize', 20);
    set(0,'defaultFigureWindowStyle', 'Docked')


    %% Plotting

    close all
    %plotIMU(time_array, accel_data.', true)
    %plotTRN(t_TRN, TRN_coord_m.')
    plotKFOutputs(time_array, xHist, PHist)

    figure
    plot(xHist(1,:),xHist(3,:))
    
    
    
    
    
    


end