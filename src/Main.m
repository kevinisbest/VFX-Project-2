function Main(folder)

    focal = 0;
    
    % harris detector parameters
    sigma = 3;
    w = 5;             % parrington=5 grail=5 tree=3 tesv=4
    threshold = 4000;  % parrington=4000 grail=4000 tree=500 tesv=1000
    k = 0.04;

    
    
    disp('----- loading images -----');
    [images] = ReadImages(folder);
    [r, c, channel, numbers] = size(images);
    
    [H,W,channel] = size(images(:,:,:,1));
    focal = H;
    
    disp('----- cylindrical projection -----');
    [warped_images] = Warping(images, numbers, H, W, channel, focal);
    
    disp('----- harris corner detection and feature detection -----');
    
    for i = 1:numbers
        [featureX, featureY, R]= Harris(warped_images(:,:,:,i), sigma, w, threshold, k);
        disp(length(featureX));
        [feature_pos, feature_descriptor] = SIFT(warped_images(:,:,:,i), featureX, featureY);
        features_pos{i} = feature_pos;
        features_desc{i} = feature_descriptor;
        figure(i);imshow(warped_images(:,:,:,i));
        hold on
        plot(features_pos{i}(:,1),features_pos{i}(:,2), 'r*');
    end
end