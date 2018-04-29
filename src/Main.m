function Main()
    disp('----- loading images -----');
    [images, focal] = ReadImages(folder);
    [r, c, channel, numbers] = size(images);
    
    disp('----- cylindrical projection -----');
    [warped_images] = Warping(images, numbers, focal);
end