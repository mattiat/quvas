%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUVAS QUantifier of Vascular Surfice
% by Fran?ois Sute, Luca Soldin, Gilles Aeschliman, Loris Sonno
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO: add a comment here
% - what is this program useful for? (in one or two sentences)
% - what are the inputs
% - what are the outputs

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
    % Changing to green
    % TODO: create a separate function convert_to_green.m  (copy what has
    % been done for convert_to_red.m)
    green_channel = img(:,:,2); % Green channel
    a = zeros(size(img, 1), size(img, 2));
    img_green = cat(3, a, green_channel, a);
    if debug
        figure, imshow(img_green), title('Green channel');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Quantify vascular surfice
    quantify_vascular_surface(img, img_name, mask, output_dir, debug);
    
    %TODO add function invocations to also process the red and green images
end
