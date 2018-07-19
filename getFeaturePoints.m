function fpvec = getFeaturePoints(imgA, imgB, p1, p2, thresh)
res_vec = zeros(1,6);

res_ratio_vec = zeros(1,5);

% This contains the result: [ x1, y1, x2, y2, best_cost, next_best ]
res1 = [ 0, 0, 0, 0, 0, 0 ];
res2 = [ 0, 0, 0, 0, 0, 0 ];

best_cost = 999999999999;
next_best = 999999999999;

size(p1,1)

for i=1:size(p1,1)

    for j=i:size(p1,1)

        c = SSD_patch(imgA, imgB, p1(i,1), p1(i,2), p2(j,1), p2(j,2), 11);
        if c < best_cost
            best_cost = c;
            res1(:,1:5) = [ p1(i,1), p1(i,2), p2(j,1), p2(j,2), c ];
        elseif c < next_best
            next_best = c;
            res1(:,6)   = c;
        end   
    end
    
    best_cost = 999999999999;
    next_best = 999999999999;
    
    for k=i:size(p1,1)

        c = SSD_patch(imgA, imgB, p1(k,1), p1(k,2), p2(i,1), p2(i,2), 11);
        if c < best_cost
            best_cost = c;
            res2(:,1:5) = [ p1(k,1), p1(k,2), p2(i,1), p2(i,2), c ];
        elseif c < next_best
            next_best = c;
            res2(:,6)   = c;
        end   
    end
    
    % compare costs, take the better of the two.
    if (res1(:,5) < res2(:,5))
        res_vec(i,:) = res1;
    else
        res_vec(i,:) = res2;
    end
    
    % compare the costs when ratio tested. Want the min one.
    r1 = res1(:,5) / res1(:,6);
    r2 = res2(:,5) / res2(:,6);
    if (r1 < r2)
        res_ratio_vec(i,1:4) = res1(:,1:4);
        res_ratio_vec(i,5)   = r1;
    else
        res_ratio_vec(i,1:4) = res2(:,1:4);
        res_ratio_vec(i,5)   = r2;
    end
end

fpvec = zeros(1,5);
index = 1;
for i=1:size(res_ratio_vec, 1)
    if res_ratio_vec(i,5) < thresh
       fpvec(index,:) = res_ratio_vec(i,:);
       index = index+1;
    end
end

end