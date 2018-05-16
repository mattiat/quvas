% Function to extract only the green channel
% Used to see if the blood vessels are more visible by extracting only the
% green color of the retina images, as they contain a lot of green
% - Inputs : retina images
% - Outputs : retina images with only the green color

function img_green = convert_to_green(img, show_debug_imges)

green_channel = img(:,:,2); % Green channel
b = zeros(size(img, 1), size(img, 2));
img_green = cat(3, green_channel, b, b);
if show_debug_imges
    figure, imshow(img_green), title('Green channel');
end

end