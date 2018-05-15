function Main(folder)
%%%%%%%%%%
    focal = 443.1;
    
    % harris detector parameters
    k = 0.04;

    % ransac parameters
    theta = 10;
    
    % result location
    result_location = '/Users/kevin_mbp/VFX-Project-2/result/';
    
    % drift erasing parameters
    drift_tag = 1; % do drift correction or not
%%%%%%%%%%
    
    disp('----- loading images -----');
    [images] = ReadImages(folder);
    [r, c, channel, numbers] = size(images);
    
    [H,W,channel] = size(images(:,:,:,1));
    
    
    disp('----- cylindrical projection -----');
    [warped_images] = Warping(images, numbers, H, W, channel, focal);
%     hold on
%     imshow(warped_images(:,:,:,3));
    disp('----- harris corner detection and feature detection -----');
    
    for i = 1:numbers
        [featureX, featureY]= Harris(warped_images(:,:,:,i), k);
%         disp(length(featureX));
        [feature_pos, feature_descriptor] = SIFT(warped_images(:,:,:,i), featureX, featureY);
        features_pos{i} = feature_pos;
        features_desc{i} = feature_descriptor;
%         figure(i);imshow(warped_images(:,:,:,i));
%         hold on
%         plot(features_pos{i}(:,1),features_pos{i}(:,2), 'r*');
    end
    
    disp('----- feature matching and RANSAC -----');
    for j = 1:numbers-1
        desc1 = features_desc{j};
        desc2 = features_desc{j+1};
        
        pos1 = features_pos{j};
        pos2 = features_pos{j+1};
        
        match = [];
        
        % feature matching
        match = Feature_Matching(desc1, desc2);
        
        % RANSAC
        matchInlier = RANSAC(match, pos1, pos2, theta);
        
        matches{j} = match;
%         disp(matches{j});
        matchInliers{j} = matchInlier;
%         disp(matchInliers{j});
    end
    
    disp('----- image matching -----'); % use inliers to count translation amount between images
    drift_y = 0;
    for k = 1:numbers-1
        tran = imageMatching(matchInliers{k}, features_pos{k}, features_pos{k+1});
        trans{k} = tran;
        drift_y = drift_y+trans{k}(2);
    end
    
    
    if (drift_tag)
        disp('----- solve drift problem -----');
        avg_drift_y = round(drift_y / (numbers-1));
    else avg_drift_y = 0;
    end
    
    disp('----- blending -----'); % blend images together
    imNow = warped_images(:,:,:,1);
    for l = 2:numbers
        %disp(trans{l-1});        
        imNow = blendImage(imNow, warped_images(:,:,:,l), trans{l-1}, l-1, avg_drift_y);
    end

%     imwrite(uint8(imNow), fullfile(result_location,'panorama4k.png'));
    imwrite(uint8(imNow), fullfile('../result/panorama.png'));
    disp('done');
end