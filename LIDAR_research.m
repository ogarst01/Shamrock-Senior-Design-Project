% make the data: 
filename = 'download-1.jpg';
var_noise = 0.001;
downsampled = makingLidarData(filename, var_noise);

% for paper: use nearest neighbor approximation:
