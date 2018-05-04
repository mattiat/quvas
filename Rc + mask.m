%%%% Changing to red color:
img = imread('*.tif'); % Read image
red = img(:,:,1); % Red channel
a = zeros(size(img, 1), size(img, 2));
just_red = cat(3, red, a, a);
imshow(just_red,just_green,just_blue)
figure, imshow(just_red), title('Red channel')

% same possible with green or blue
green = img(:,:,2); % Green channel
just_green = cat(3, a, green, a);
blue = img(:,:,3); % Blue channel
just_blue = cat(3, a, a, blue);





%%%% Code Red Color + mask
files = dir('*.tif');
% loop over all tif files in the current folder
results =fopen('results.csv', 'w' );
%opens (or create if it did not exist) a result file in current folder
for file = files'
    % load the image
    img = imread(file.name);
    filename = split(file.name,".");
    % splits the filename at the dot
    name = filename{1};
    % stores the file name whithout its extension as a string
    MaskName = strcat(name,'_mask.gif');
    %create the name of mask corresponding to current image
    mask = imread(MaskName);
    % convert the image to red color
    img = imread('01_test.tif');
    red = img(:,:,1);
    a = zeros(size(img, 1), size(img, 2));
    just_red = cat(3, red, a, a);
    % convert the image to black and white
    grayscale = rgb2gray(just_red);
    imgBW=imbinarize(grayscale,'adaptive','sensitivity',0.63);
    
    % store the converted image to disk for debugging
    imwrite(imgBW, strcat(file.name(1:end-4),'_bw.jpg'));
    
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