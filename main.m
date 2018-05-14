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
debug = true;

% set input and output locations and clean files from old runs
input_dir = './input/DRIVE_database_sample/';
output_dir = './output/';
rmdir(output_dir, 's');
mkdir(output_dir);


% loop over all tif files in the input folder
files = dir(strcat(input_dir, '*.tif'));
for file = files'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load the image and its corresponding mask
    img = imread(strcat(input_dir,file.name));
    if debug
        figure, imshow(img), title('Original image');
    end
    % filename = split(file.name,'.'); <- works for earlier MATLAB versions
    filename = strsplit(file.name,'.');
    % splits the filename at the dot
    img_name = filename{1};
    % stores the file name whithout its extension as a string
    MaskName = strcat(input_dir,img_name,'_mask.gif');
    %create the name of mask corresponding to current image
    mask = imread(MaskName);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Changing to red color
    img_red = convert_to_red(img, debug);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Changing to green color
    img_green = convert_to_green(img, debug);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Quantify vascular surface
    quantify_vascular_surface(img, img_name, mask, output_dir, debug);
    
    % Quantify vascular surface of red colored images
    quantify_vascular_surface(img_red, img_name, mask, output_dir, debug);
    
    % Quantify vascular surface of green colored images
    quantify_vascular_surface(img_green, img_name, mask, output_dir, debug);
    
end
