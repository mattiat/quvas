%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUVAS QUantifier of Vascular Surfice
% by Francois Sutter, Luca Soldini, Gilles Aeschlimann, Loris Sonno
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This program is used to observe the blood vessels of retina images and
% calculate their size. These values will maybe help us to determinate
% pathologies in some patients, like hypertension for example.
% Inputs : retina images from patients (left and right)
% Outputs : CSV file containing the values of the size of the blood vessels
% of each different patient

clear; % clearing variables from previous runs

% options
debug = false;

% set input and output locations and clean files from old runs
input_dir = './input/';
input_dir_pics = strcat(input_dir, 'DRIVE_database_sample/');
output_dir = './output/';
rmdir(output_dir, 's'); mkdir(output_dir);
output_dir_original = strcat(output_dir, 'original/');
mkdir(output_dir_original);
output_dir_green = strcat(output_dir, 'green/');
mkdir(output_dir_green);
output_dir_red = strcat(output_dir, 'red/');
mkdir(output_dir_red);

% loop over all tif files in the input folder
files = dir(strcat(input_dir_pics, '*.tif'));
for file = files'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load the image and its corresponding mask
    img = imread(strcat(input_dir_pics,file.name));
    if debug
        figure, imshow(img), title('Original image');
    end
    % filename = split(file.name,'.'); <- works for earlier MATLAB versions
    filename = strsplit(file.name,'.');
    % extract file name (splits filename at the dot)
    img_name = filename{1};
    % load mask
    mask = imread(strcat(input_dir, 'universal_mask.gif'));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Changing to red color
    img_red = convert_to_red(img, debug);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Changing to green color
    img_green = convert_to_green(img, debug);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Quantify vascular surface
    quantify_vascular_surface(img, img_name, mask, output_dir_original, debug);
    
    % Quantify vascular surface of red colored images
    quantify_vascular_surface(img_red, img_name, mask, output_dir_red, debug);
    
    % Quantify vascular surface of green colored images
    quantify_vascular_surface(img_green, img_name, mask, output_dir_green, debug);
    
end
