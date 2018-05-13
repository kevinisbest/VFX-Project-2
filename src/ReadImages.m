
function [images] = ReadImages(folder, extension)
    images = [];
        
    if( ~exist('extension') )
	extension = 'jpg';
    end

    files = dir([folder, '/*.', extension]);%read .jpg files

    % initialize images and exposureTimes.
    filename = [folder, '/', files(1).name];
    img_count = length(files);
    
    img = imread(filename);
    % img = imrotate(img, 270);
    img_height = size(img,1);
    img_width = size(img,2);
    img_channel = size(img,3);
    disp([img_height,img_width]);
    n=0;
    while(img_height>1000)
        img_height = img_height/2;
        img_width = img_width/2;
        n = n+1
    end
    disp([img_height,img_width]);
    images = zeros(img_height, img_width, img_channel, img_count, 'uint8');
    for i = 1:img_count
        filename = [folder, '/', files(i).name];
        disp(filename);
        img = imread(filename);
        % img = imrotate(img, 270);
        j = n;
        while(j>0)
            img = imresize(img,0.5);
            j = j-1;
        end
        images(:,:,:,i) = img;
    end
    imshow(images(:,:,:,2));
end
