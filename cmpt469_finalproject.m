
imgA = im2double(imread('./data/test1/2.jpg'));
imgB = im2double(imread('./data/test1/1.jpg'));

% -------------------------------------------------------------------------
% Get the feature points and match them.
fpvec = getFeaturePoints2(imgA, imgB, 0.5);
h = show_correspondence2(imgA, imgB, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));


% -------------------------------------------------------------------------
% Now compute homographies.
inlierThresh      = 3;
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

overlapImage(imgA, imgB, bestH);


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






