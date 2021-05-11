function [finalHazardCurr,update] = make_final_hazard_map(shadow_hazard_map,cv_hazard_map,this_coord_f,lidar_hazard_map)
    finalHazardCurr = zeros(1000, 2000);
    % final_map_glob(((this_coord(1) - 90):(this_coord(1)+90)), ((this_coord(2) + 160):(this_coord(2) - 160))) = hazard_map;
    scale_x = (180/2)*0.35;
    scale_y = (320/2)*0.35;

    f_x_s = round(this_coord_f(1) - scale_x);
    f_x_e = round(this_coord_f(1) + scale_x);
    f_y_s = round(this_coord_f(2) - scale_y);
    f_y_e = round(this_coord_f(2) + scale_y);
    
    if(f_x_s < 0)
        f_x_s = 0;
    end
    if(f_y_s < 0)
        f_y_s = 0;
    end
%     if(f_x_e > 720)
%         f_x_e = 720;
%     end
%     if(f_y_e > 1280)
%         f_x_e = 1280;
%     end

   % try
        finalHazardCurr(f_x_s:f_x_e-2, f_y_s:f_y_e-2) = imresize((shadow_hazard_map | cv_hazard_map),[f_x_e-1-f_x_s, f_y_e-1-f_y_s]);
        update = 1; 
    %    return;
    %catch
    %    update = 0; 
    %    return;
   % end
        
    %finalHazard = finalHazard | finalHazardCurr;
end
    %end
    %final_map_glob(((this_coord(1) - 90):(this_coord(1)+90)), ((this_coord(2) + 160):(this_coord(2) - 160))) = hazard_map;

% % plot the whole thing over a larger image: 
% figure(100) 
% hold on 
% imagesc(finalHazard)
% colorbar
% hold off
% %Run HDA algorithm
% HDAWrapper(hazard_map, params);