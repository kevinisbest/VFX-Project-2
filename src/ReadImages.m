
function [images,focal] = ReadImages(folder, extension)
    images = [];
    exposureTimes = [];
    
    if( ~exist('extension') )
	extension = 'jpeg';
    end

    files = dir([folder, '/*.', extension]);%read .jpg files

    % initialize images and exposureTimes.
    filename = [folder, '/', files(1).name];
    info = imfinfo(filename);
    number = length(files);
    images = zeros(info.Height, info.Width, info.NumberOfSamples, number, 'uint8');

    for i = 1:number
	filename = [folder, '/', files(i).name];
	img = imread(filename);
	images(:,:,:,i) = img;% return original images;
    exif_info = imfinfo(filename);
    exif_info = exif_info.DigitalCamera;
    focal(i) = exif_info.FocalLength;
    end
    
end
