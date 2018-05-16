function match = Feature_Matching(descriptor1, descriptor2)

    match = [];
%     disp(size(desc1));
%     disp(size(desc2));

    for i = 1:size(descriptor1, 1)
        dists = [];
        for j = 1:size(descriptor2, 1)
            tmp = [dists; Distance(descriptor1(i,:), descriptor2(j,:))];
            dists = tmp;
        end
        [dist1,index] = sort(dists);
        tmp_min1 = dist1(1);
        tmp_index1 = index(1); 
        tmp_min2 = dist1(2);

        if (tmp_min1/tmp_min2) < 0.8
            tmp_match = [match; [i ,tmp_index1]];
            match = tmp_match;
        end
    end
end
function Dis = Distance(descriptor1, descriptor2)
    Dis = sqrt(sum((descriptor1 - descriptor2) .^ 2));
end