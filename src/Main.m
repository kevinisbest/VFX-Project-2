function Main(folder)

    focal = 800;
    
    % harris detector parameters
    sigma = 3;
    w = 5;             % parrington=5 grail=5 tree=3 tesv=4
    threshold = 4000;  % parrington=4000 grail=4000 tree=500 tesv=1000
    k = 0.04;

    % ransac parameters
    theta = 10;
    
    disp('----- loading images -----');
    [images] = ReadImages(folder);
    [r, c, channel, numbers] = size(images);
    
    [H,W,channel] = size(images(:,:,:,1));
    
    
    disp('----- cylindrical projection -----');
    [warped_images] = Warping(images, numbers, H, W, channel, focal);
    
    disp('----- harris corner detection and feature detection -----');
    
    for i = 1:numbers
        [featureX, featureY, R]= Harris(warped_images(:,:,:,i), sigma, w, threshold, k);
        disp(length(featureX));
        [feature_pos, feature_descriptor] = SIFT(warped_images(:,:,:,i), featureX, featureY);
        features_pos{i} = feature_pos;
        features_desc{i} = feature_descriptor;
%         figure(i);imshow(warped_images(:,:,:,i));
%         hold on
%         plot(features_pos{i}(:,1),features_pos{i}(:,2), 'r*');
    end
    
    disp('feature matching and RANSAC');
    for j = 1:numbers-1
        desc1 = features_desc{j};
        desc2 = features_desc{j+1};
        pos1 = features_pos{j};
        pos2 = features_pos{j+1};
        match = [];
        % feature matching
        for i = 1:size(desc1, 1)
            dists = [];
            for k = 1:size(desc2, 1)
                dist = sqrt(sum(desc1(i,:)-desc2(k,:).^2));
                dists = [dists; dist];
                
%                 dists = [dists; descriptorDistance(desc1(i,:), desc2(k,:))];
            end
            [min1 min1_idx] = min(dists);
            dists(min1_idx) = [];
            min2 = min(dists);
            %disp(min1);
            %disp(min2);
            if (min1/min2) < 0.8
                match = [match; [i min1_idx]];
            end
        end
        
        % RANSAC
        matchInlier = RANSAC(match, pos1, pos2, theta);
        
        matches{j} = match;
        % disp(matches{j});
        matchInliers{j} = matchInlier;
        % disp(matchInliers{j});
    end
end