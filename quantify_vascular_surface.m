% Function to calculate the size (in pixels) of the blood vessels of
% different retina images by turning them into black and white
% - Inputs : retina images
% - Outputs : CSV file with the number of white and black pixels for each
% retina image

function quantify_vascular_surface(img, img_name, mask, output_dir, debug)

%opens (or create if it did not exist) a result file in output folder
results =fopen(strcat(output_dir, 'results.csv'), 'a' );

% convert the images to black and white
grayscale = rgb2gray(img);
imgBW=imbinarize(grayscale,'adaptive','sensitivity',0.63);
if debug
    figure, imshow(imgBW), title('BW image')
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
if debug
    if (nBlack_total+nWhite_total ~= height*width)
        error('the pixel count does not match the image pixel number')
    end
end
true_Black_total = nBlack_total-nBlack_mask;
%prints the file name and pixel counts to a new line in the csv file
fprintf(results, '%s,%d,%d,%d\n', ...
    img_name ,true_Black_total, nWhite_total, nWhite_total/true_Black_total);

fclose(results); % close file stream

end