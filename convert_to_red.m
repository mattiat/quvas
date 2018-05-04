%TODO: add a comment here
% - what is this function useful for? (in one or two sentences)
% - what are the inputs
% - what are the outputs

function red_img = convert_to_red(img, show_debug_imges)

red_channel = img(:,:,1); % Red channel
a = zeros(size(img, 1), size(img, 2));
red_img = cat(3, red_channel, a, a);
if show_debug_imges
    figure, imshow(red_img), title('Red channel');
end

end