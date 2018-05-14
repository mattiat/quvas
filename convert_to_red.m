% Function to extract only the red channel
% Used because the retina images contain a lot of red and then allows us to
% have better and more precise images to analyse the blood vessels
% - Inputs : retina images
% - Outputs : retina images with only the red color

function red_img = convert_to_red(img, show_debug_imges)

red_channel = img(:,:,1); % Red channel
a = zeros(size(img, 1), size(img, 2));
red_img = cat(3, red_channel, a, a);
if show_debug_imges
    figure, imshow(red_img), title('Red channel');
end

end