%TODO: add a comment here
% - what is this function useful for? (in one or two sentences)
% - what are the inputs
% - what are the outputs

function just_red = convert_to_red(img, show_debug_imges)

red = img(:,:,1); % Red channel
a = zeros(size(img, 1), size(img, 2));
just_red = cat(3, red, a, a);
if show_debug_imges
    figure, imshow(just_red), title('Red channel')
    imwrite(just_red, strcat(output_dir,file.name(1:end-4),'_red.jpg'));
end

end