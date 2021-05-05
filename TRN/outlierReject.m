function output_data = outlierReject(input_data)
    data = input_data;
    output_data = [];
    notOutlier = 1;
    for i = 2:size(data,1)-1
        if notOutlier
            max_x = max(data(i-1,1), data(i+1,1));
            min_x = min(data(i-1,1), data(i+1,1));
            x = data(i,1);
            max_y = max(data(i-1,2), data(i+1,2));
            min_y = min(data(i-1,2), data(i+1,2));
            y = data(i,2);
            if  (x > max_x || x < min_x) || (y > max_y || y < min_y)
                notOutlier = 0;
                continue;
            else
                output_data(end+1,:) = data(i,:);
            end
        else
            notOutlier = 1;
            continue;
        end
    end
end