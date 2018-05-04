%%%% Changing to red color:
img = imread('./input/DRIVE_database/01_test.tif'); % Read image
figure, imshow(img), title('Red channel')
red = img(:,:,1); % Red channel
a = zeros(size(img, 1), size(img, 2));
just_red = cat(3, red, a, a);
figure, imshow(just_red), title('Red channel')

% same possible with green or blue
green = img(:,:,2); % Green channel
just_green = cat(3, a, green, a);
figure, imshow(just_green), title('Green channel')
blue = img(:,:,3); % Blue channel
just_blue = cat(3, a, a, blue);
figure, imshow(just_blue), title('Blue channel')