cd Data
cd global_data
glob_map = imread('april16_glob.PNG');
ground_truth = imread('april16_glob_for_truth_data.PNG');
cd ..
cd ..

figure, 
subplot(3,1,1)
imagesc(glob_map)
subplot(3,1,2)
imagesc(ground_truth)
subplot(3,1,3)
imagesc(hazardMapLidar')
