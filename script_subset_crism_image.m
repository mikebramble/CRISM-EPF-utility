% Code written by: Mike Bramble | michael.s.bramble@jpl.nasa.gov
% script to spatial subset CRISM image
% 20230328 - initial version

%% FILENAME AND FILEPATH

% create variables with the data folder file path and the filename
file_path_data = '/Path/To/Data/'; 
filename_image = 'frt00003e12_07_if166l_trr3';

%% LOAD DATA

% read into matlab the pre-processed I/F image file
header_info = function_pdslblread(strcat(file_path_data,char(filename_image),'.lbl'));
image_cube = multibandread(strcat(file_path_data,char(filename_image),'.img'),[header_info.LINES,header_info.LINE_SAMPLES,header_info.BANDS],'single',0,'bil','ieee-le');

% clean spectral cube
image_cube(isnan(image_cube)) = 0;
image_cube(isinf(image_cube)) = 0;
image_cube(image_cube>1) = 0;
data = image_cube;
    
%% PLOT ORIGINAL IMAGE

% plot the CRISM image prior to subset
figure
imagesc(data(:,:,55))
colormap(gray)
set(gca,'YDir','normal')

%% SUBSET DATA

% image_cube(Y_AXIS_IN_PLOT,X_AXIS_IN_PLOT,:)
data_subset = image_cube(100:300,50:150,:);

%% PLOT SUBSET IMAGE

% plot the CRISM image following the subset
figure
imagesc(data_subset(:,:,55))
colormap(gray)
set(gca,'YDir','normal')

%% EXPORT DATA
% export the image to an IMG file with HDR header

band_numbers = string(1:header_info.BANDS);
band_numbers_join = strjoin(band_numbers,",");

filename_output = strcat(file_path_data,filename_image,'_subset');
function_saveENVI(data_subset,filename_output,band_numbers_join) 


