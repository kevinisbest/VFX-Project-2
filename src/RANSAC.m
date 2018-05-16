function maxMatch = RANSAC(match, position1, position2, threshold)
    
    
	p = 0.5;
	n = 2;
	P = 0.9999;
    k = ceil(log(1-P)/log(1-p^n));
    
    N = size(match, 1);
%     disp('N');disp(N);
    
    maxMatch = [];
    if N <= n
        maxMatch = match;
        return;
    end

    % run k times
    for trial = 1:k
        % draw n samples randomly
        pool = randperm(N);
        sample_index = pool(1:n);
        
        tmp_match = match;
        sampleMatch = tmp_match(sample_index, :);
        tmp_match(sample_index,:)=[];
        remainMatch = tmp_match;
%         otherMatch(sample_index, :) = [];

        sample_position1 = position1(sampleMatch(:,1), :);
        sample_position2 = position2(sampleMatch(:,2), :);
        other_position1 = position1(remainMatch(:,1), :);
        other_position2 = position2(remainMatch(:,2), :);

        % fit parameters theta with these n samples
        tmp_match = [];
        posDiff = sample_position1 - sample_position2;
        theta = mean(posDiff);

        % for each of other N-n points, calcuate 
        % its distance to the fitted model, count the
        % number of inliner points, c
        for i = 1:size(other_position1, 1)
            d = (other_position1(i,:)-other_position2(i,:)) - theta;
            if sqrt(sum(d.^2)) < threshold
                tmp_match = [tmp_match; remainMatch(i, :)];
            end
        end
        if size(tmp_match, 1) > size(maxMatch, 1)
            maxMatch = tmp_match;
        end
    end
    
%     disp('ransac_N');disp(size(maxMatch,1));
end
