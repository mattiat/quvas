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
show_debug_imges = true;

% set input and output locations and clean files from old runs
input_dir = './input/DRIVE_database/';
rmdir(input_dir, 's'); mkdir input_dir;
output_dir = './output/';
rmdir(output_dir, 's'); mkdir output_dir;
files = dir(strcat(input_dir, '*.tif'));
%opens (or create if it did not exist) a result file in output folder
results =fopen(strcat(output_dir, 'results.csv'), 'w' );

% loop over all tif files in the input folder
for file = files'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load the image and its corresponding mask
    img = imread(strcat(input_dir,file.name));
    if show_debug_imges
        figure, imshow(img), title('Original image');
    end
    % filename = split(file.name,'.'); <- works for earlier MATLAB versions
    filename = strsplit(file.name,'.');
    % splits the filename at the dot
    name = filename{1};
    % stores the file name whithout its extension as a string
    MaskName = strcat(input_dir,name,'_mask.gif');
    %create the name of mask corresponding to current image
    mask = imread(MaskName);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Changing to red color
    just_red = convert_to_red(img, show_debug_imges);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Changing to green
    % TODO: create a separate function convert_to_green.m  (copy what has
    % been done for convert_to_red.m)
    green = img(:,:,2); % Green channel
    just_green = cat(3, a, green, a);
    if show_debug_imges
        figure, imshow(just_green), title('Green channel')
        imwrite(just_red, strcat(output_dir,file.name(1:end-4),'_green.jpg'));
    end
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Quantify vascular surfice
    
    % convert the images to black and white
    grayscale = rgb2gray(img);
    imgBW=imbinarize(grayscale,'adaptive','sensitivity',0.63);
    if show_debug_imges
        figure, imshow(imgBW), title('BW image')
        imwrite(imgBW, strcat(output_dir,file.name(1:end-4),'_bw.jpg'));
    end
    
    % counters for total number of white and black pixels in the image
    nWhite_total = 0; % set to 0 before we begin
    nBlack_total = 0;
    nBlack_mask = 0;
    
    % loop over each row of the image
    for current_row = imgBW'
        % count white pixels in current row
        nWhite_current_row = sum(current_row(:));
        % count black in current row: all pixels in row - white
        nBlack_current_row = numel(current_row) - nWhite_current_row;

        % add pixel counts for current row to total counter
        % (at each iteration, nWhite_total is equal to itself augmented 
        % by the white pixels in the current row)
        nWhite_total = nWhite_total + nWhite_current_row;
        nBlack_total = nBlack_total + nBlack_current_row;
    end
    
    %loop over the mask
    for current_row = mask'
        % count white pixels in current row the /255 is due to mask not
        % being in binarized format so white==255
        nWhite_current_row = sum(current_row(:))/255;
        % count black in current row: all pixels in row - white
        nBlack_current_row = numel(current_row) - nWhite_current_row;

        % add pixel counts for current row to total counter
        % (at each iteration, nBlack_mask is equal to itself augmented 
        % by the black pixels in the current row)
        nBlack_mask = nBlack_mask + nBlack_current_row;
    end
    
    [height, width] = size(imgBW);
    %determine the dimensions of the black and white image
    if (nBlack_total+nWhite_total ~= height*width)
        error('the pixel count does not match the image pixel number')
    end
    true_Black_total = nBlack_total-nBlack_mask;
    fprintf(results, '%s,%d,%d\n',name,true_Black_total, nWhite_total);
    %prints the file name and pixel counts to a new line in the csv file
    
end
fclose(results);