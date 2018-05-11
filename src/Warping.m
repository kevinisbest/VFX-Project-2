function [warped_images] = Warping(images, numbers, H, W, channel, f)
    
    disp([H,W,channel]);
    
    warped_images = zeros(H, W, channel, numbers, 'uint8');
    y0 = H/2;
    x0 = W/2;
    for y_new = 1:H
        for x_new = 1:W
            x = f*tan((x_new-x0)/f);
            y = sqrt(x*x+f*f)*(y_new-y0)/f;
            x = x+x0;
            y = y+y0;
            x = round(x);
            y = round(y);
            if(0<x) & (x<=W) & (0<y) & (y<=H) warped_images(y_new, x_new, :, :) = images(y, x, :, :);
            else warped_images(y_new, x_new, :, :) = 0;
            end
        end
    end
%     figure(1);imshow(images(:,:,:,1));
%     figure(2);imshow(warped_images(:,:,:,1));
end