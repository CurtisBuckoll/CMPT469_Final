function [bestH, inliers] = findBestHomography(fpvec)

% Fix the inlier threshold to a radius of 3 pixels.
inlierThresh      = 3;

bestInliers       = 0;
best_inlier_vec   = zeros(1,4);

% Perform RANSAC to determine the homography that best fits the data.
for i=1:10000
    
    % get some random points
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
    
    % Check if it is better than the current best.
    if numInliers > bestInliers
       bestInliers = numInliers;
       best_inlier_vec = inlier_vec;
    end
end

% recompute the H matrix from the most promising inliers.
bestH = computeHomography( best_inlier_vec );
inliers = best_inlier_vec;

end

function y = transformByH( H, x )
    t = H * [ x 1 ]';
    y = [ t(1) / t(3), t(2) / t(3) ];
end


