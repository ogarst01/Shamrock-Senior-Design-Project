function [coords_vec,scale_factor] = wrapper_TRN(dateOfRun, framesPerSec)
    

    if(dateOfRun == 20)
        % april 20 run:
        global_map_string = 'global_april20.PNG';
        local_height = 0.4;
        global_height = 1.08;    
    elseif(dateOfRun == 16)
        % april 16 run:
        global_map_string = 'april5_global_from_.93m.png';
        local_height = 0.3268;
        global_height = .93;
    elseif(dateOfRun == 5)
        % april 5 run: 
        global_map_string = 'april5_global_from_.93m.png';
        local_height = 0.33;
        global_height = 0.98;   
    else
        sprintf("ERROR - dates must be 5,16 or 20!")
    end

    scale_factor = local_height/global_height;

    % count the number of files in the frames directory: 
    yourfolder = '/Users/Olive/Documents/MATLAB/seniorDesign/Shamrock-Senior-Design-Project/Data/frames';
    numPics = dir([yourfolder '/*.png']);
    numPics = length(numPics)

    global_map = imread(global_map_string);

    figure,
    imagesc(global_map);
    title('global map')

    % get to the place where frames are kept (for this
    % efficiency, cannot cd .. into and out of folders each time)
    cd .. 
    cd Data
    cd frames
    
    %% RUN TRN on all the frames
    coords_vec = [];
    time = 0;
    
    % define first guess? 
    old_row = 900;
    old_col = 330;

    % run through all photos and find highest correlation value
    for i = 1:numPics
        coords_vec(i,3) = time;
        s = sprintf('%d',i);
        local_map = strcat('frame_', s, '.png');
        [time, coords] = TRN(global_map, local_map, time, old_row, old_col,scale_factor,framesPerSec);
        coords_vec(i,1:2) = coords;
        old_row = coords(1);
        old_col = coords(2);
    end

    % TODO: convert everything to meters:
    
    cd ..
    %% SAVE THE DATA: 
    cd saved_run_data
    
    fileNameTRN = ['april',num2str(dateOfRun),'_trnOutput_',num2str(framesPerSec),'.mat'];
    save(fileNameTRN,'coords_vec');
    
    cd ..
    %% TEST IT OUT:
    %coords_vec = load('TRN_cord_april16_run.mat','coords_vec');
    %coords_vec = coords_vec.coords_vec;
    %global_map = imread('april16_glob.PNG');
    frame2check = 10;
    check_frame_TRN(coords_vec,global_map,frame2check);

    %% Show the final TRN path over the global image:
    figure,
    hold on
    imagesc(imread(global_map_string))
    pllot3([coords_vec(:,2)'],[coords_vec(:,1)'],[coords_vec(:,3)'],'Color','r', 'LineWidth',4)
    plot([coords_vec(1,2)'],[coords_vec(1,1)'],'gx')
    xlabel('x pixels')
    ylabel('y pixels')
    xlabel('time (sex)')
    title('location of coordinates for april %f', dateOfRun)
    hold off
end