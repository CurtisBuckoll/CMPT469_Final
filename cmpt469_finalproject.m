
imgA = im2double(imread('./data/notredame/1.jpg'));
imgB = im2double(imread('./data/notredame/2.jpg'));
cornersA = detectHarrisFeatures(rgb2gray(imgA));
cornersB = detectHarrisFeatures(rgb2gray(imgB));

%cornersA.size()

% Get the interest points.
p1 = cornersA.selectStrongest(1000).Location;
p2 = cornersB.selectStrongest(1000).Location;

% plot(cornersA.selectStrongest(10));

h = show_correspondence(imgA, imgB, p1(:,1), p1(:,2), p2(:,1), p2(:,2));

fpvec = getFeaturePoints(imgA, imgB, p1, p2, 0.35);

h = show_correspondence2(imgA, imgB, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));

% Now compute homographies.
inlierThresh      = 4;
bestInliers       = 0;
best_inlier_vec   = zeros(1,4);
bestH             = zeros(3,3);

for i=1:5000
    % get random points
    [rp1, rp2, rp3, rp4] = getFourRandomI( size(fpvec, 1) );
    
    pts = [ fpvec(rp1, 1:4); fpvec(rp2, 1:4); fpvec(rp3, 1:4); fpvec(rp4, 1:4) ];
    
    % get the corresponding homography
    H = computeHomography( pts );
    
    numInliers = 0;
    inlier_vec = zeros(1,4);
    inlier_index = 1;
    
    for fp=1:size(fpvec, 1)
        
        target = [fpvec(fp, 3) fpvec(fp, 4)];
        x      = [fpvec(fp, 1) fpvec(fp, 2)];
        y      = transformByH(H, x);
        
        dist = sqrt((y(1,1) - target(1,1))^2 + (y(1,2) - target(1,2))^2);
        
        if dist < inlierThresh
            numInliers = numInliers + 1;
            inlier_vec(inlier_index,:) = fpvec(fp,1:4);
            inlier_index = inlier_index + 1;
        end
    end
    
    if numInliers > bestInliers
       bestH = H;
       bestInliers = numInliers;
       best_inlier_vec = inlier_vec;
    end
end

% recompute the H matrix from the most promising inliers.
bestH = computeHomography( best_inlier_vec );

h = show_correspondence2(imgA, imgB, best_inlier_vec(:,1), best_inlier_vec(:,2), best_inlier_vec(:,3), best_inlier_vec(:,4));

% write the transformed image overtop..
[imAh, imAw, comp] = size(imgA);
[imBh, imBw, comp] = size(imgB);

for y=1:imAh
    for x=1:imAw
        newCoord = transformByH( bestH, [x y] );
        u        = round(newCoord(1,1));
        v        = round(newCoord(1,2));
        
        if (v >= 1 && v <= imBh && u >= 1 && u <= imBw )
            imgB(v,u,:) = imgA(y,x,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
        end
    end
end

imshow(imgB);

keyboard;

function y = transformByH( H, x )
    t = H * [ x 1 ]';
    y = [ t(1) / t(3), t(2) / t(3) ];
end




% res_vec = zeros(1,6);
% 
% res_ratio_vec = zeros(1,5);
% 
% % This contains the result: [ x1, y1, x2, y2, best_cost, next_best ]
% res1 = [ 0, 0, 0, 0, 0, 0 ];
% res2 = [ 0, 0, 0, 0, 0, 0 ];
% 
% best_cost = 999999999999;
% next_best = 999999999999;
% 
% size(p1,1)
% 
% for i=1:size(p1,1)
% 
%     for j=i:size(p1,1)
% 
%         c = SSD_patch(imgA, imgB, p1(i,1), p1(i,2), p2(j,1), p2(j,2), 11);
%         if c < best_cost
%             best_cost = c;
%             res1(:,1:5) = [ p1(i,1), p1(i,2), p2(j,1), p2(j,2), c ];
%         elseif c < next_best
%             next_best = c;
%             res1(:,6)   = c;
%         end   
%     end
%     
%     best_cost = 999999999999;
%     next_best = 999999999999;
%     
%     for k=i:size(p1,1)
% 
%         c = SSD_patch(imgA, imgB, p1(k,1), p1(k,2), p2(i,1), p2(i,2), 11);
%         if c < best_cost
%             best_cost = c;
%             res2(:,1:5) = [ p1(k,1), p1(k,2), p2(i,1), p2(i,2), c ];
%         elseif c < next_best
%             next_best = c;
%             res2(:,6)   = c;
%         end   
%     end
%     
%     % compare costs, take the better of the two.
%     if (res1(:,5) < res2(:,5))
%         res_vec(i,:) = res1;
%     else
%         res_vec(i,:) = res2;
%     end
%     
%     % compare the costs when ratio tested. Want the min one.
%     r1 = res1(:,5) / res1(:,6);
%     r2 = res2(:,5) / res2(:,6);
%     if (r1 < r2)
%         res_ratio_vec(i,1:4) = res1(:,1:4);
%         res_ratio_vec(i,5)   = r1;
%     else
%         res_ratio_vec(i,1:4) = res2(:,1:4);
%         res_ratio_vec(i,5)   = r2;
%     end
% end
% 
% filtered_vec = zeros(1,5);
% index = 1;
% for i=1:size(res_ratio_vec, 1)
%     if res_ratio_vec(i,5) < 0.35
%        filtered_vec(index,:) = res_ratio_vec(i,:);
%        index = index+1;
%     end
% end
% %h = show_correspondence2(imgA, imgB, res_vec(:,1), res_vec(:,2), res_vec(:,3), res_vec(:,4));
% 
% h = show_correspondence2(imgA, imgB, filtered_vec(:,1), filtered_vec(:,2), filtered_vec(:,3), filtered_vec(:,4));








