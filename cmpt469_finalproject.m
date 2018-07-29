
imgA = im2double(imread('./data/test10/2.jpg'));
imgB = im2double(imread('./data/test10/3.jpg'));
imgC = im2double(imread('./data/test10/4.jpg'));
imgD = im2double(imread('./data/test10/1.jpg'));
imgE = im2double(imread('./data/test10/5.jpg'));

ratioThresh = 0.8;

% -------------------------------------------------------------------------
% This part to build an entire panorama from 5 images. The window size is
% determined first, and images are projected into that window.
% First find every best homography
% imgB is the target (center) image.

fpvec = getFeaturePoints2(imgA, imgB, ratioThresh);
%show_correspondence2(imgA, imgB, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
[H1, inliers] = findBestHomography(fpvec);
show_correspondence2(imgA, imgB, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));

fpvec = getFeaturePoints2(imgC, imgB, ratioThresh);
%show_correspondence2(imgC, imgB, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
[H2, inliers] = findBestHomography(fpvec);
show_correspondence2(imgC, imgB, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));

fpvec = getFeaturePoints2(imgD, imgA, ratioThresh);
%show_correspondence2(imgD, imgA, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
[H3, inliers] = findBestHomography(fpvec);
show_correspondence2(imgD, imgA, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));

fpvec = getFeaturePoints2(imgE, imgC, ratioThresh);
%show_correspondence2(imgE, imgC, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
[H4, inliers] = findBestHomography(fpvec);
show_correspondence2(imgE, imgC, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));

[newImH, newImW, translationX, translationY, outIm] = computeFullOutputWindow(imgB, imgA, imgC, imgD, imgE, H1, H2, H3, H4);

imshow(outIm);

%outIm = overlapImage2(imgA, outIm, H1, translationX, translationY, true);
outIm = overlapImage2(imgC, outIm, H2, translationX, translationY, false, false);
%outIm = overlapImage2(imgD, outIm, H1 * H3, translationX, translationY, true);
outIm = overlapImage2(imgE, outIm, H2 * H4, translationX, translationY, false, false);

imshow(outIm);
imwrite(outIm,'result1.png');
keyboard;

% % -------------------------------------------------------------------------
% % This part to warp images one at a time, resizing the window with each new
% % warp.

doBlend = false;

% % -------------------------------------------------------------------------
% % fpvec = getFeaturePoints2(imgE, imgC, ratioThresh);
% % 
% % I = show_correspondence2(imgC, imgE, 0, 0, 0, 0);
% % saveas(I, '.\results\1.png');
% % 
% % I = show_correspondence2(imgC, imgE, fpvec(:,3), fpvec(:,4),fpvec(:,1), fpvec(:,2));
% % saveas(I, '.\results\2.png');
% % 
% % [H, inliers] = findBestHomography(fpvec);
% % 
% % I = show_correspondence2(imgC, imgE, inliers(:,3), inliers(:,4), inliers(:,1), inliers(:,2));
% % saveas(I, '.\results\3.png');
% % 
% % outIm1 = overlapImage(imgE, imgC, H, false, doBlend, false);
% % imwrite(outIm1, '.\results\4.png');
% 
% % -------------------------------------------------------------------------
% 
% % outIm1 = im2double(imread('.\results\SIFT_indifference\method2\4.png'));
% % 
% % fpvec = getFeaturePoints2(imgC, imgB, ratioThresh);
% % 
% % I = show_correspondence2(imgB, outIm1, 0, 0, 0, 0);
% % saveas(I, '.\results\5.png');
% % 
% % I = show_correspondence2(imgB, outIm1, fpvec(:,3), fpvec(:,4), fpvec(:,1), fpvec(:,2));
% % saveas(I, '.\results\6.png');
% % 
% % [H, inliers] = findBestHomography(fpvec);
% % 
% % I = show_correspondence2(imgB, outIm1, inliers(:,3), inliers(:,4),inliers(:,1), inliers(:,2));
% % saveas(I, '.\results\7.png');
% % 
% % outIm1 = overlapImage(outIm1, imgB, H, false, doBlend, true);
% % imwrite(outIm1, '.\results\8.png');
% % 
% % keyboard;
% % -------------------------------------------------------------------------




% -------------------------------------------------------------------------
% Get the feature points and match them for imgA and imgB
fpvec = getFeaturePoints2(imgA, imgB, ratioThresh);

I = show_correspondence2(imgA, imgB, 0, 0, 0, 0);
saveas(I, '.\results\1.png');

I = show_correspondence2(imgA, imgB, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
saveas(I, '.\results\2.png');

[H, inliers] = findBestHomography(fpvec);

I = show_correspondence2(imgA, imgB, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));
saveas(I, '.\results\3.png');

outIm1 = overlapImage(imgA, imgB, H, false, doBlend, false);
imwrite(outIm1, '.\results\4.png');

% -------------------------------------------------------------------------
% Now do the same with outIm1 and imgC

fpvec = getFeaturePoints2(imgC, outIm1, ratioThresh);

I = show_correspondence2(imgC, outIm1, 0, 0, 0, 0);
saveas(I, '.\results\5.png');

I = show_correspondence2(imgC, outIm1, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
saveas(I, '.\results\6.png');

[H, inliers] = findBestHomography(fpvec);

I = show_correspondence2(imgC, outIm1, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));
saveas(I, '.\results\7.png');

outIm1 = overlapImage(imgC, outIm1, H, false, doBlend, true);
imwrite(outIm1, '.\results\8.png');

% -------------------------------------------------------------------------
% Now do the same with outIm1 and imgC

fpvec = getFeaturePoints2(imgD, outIm1, ratioThresh);

I = show_correspondence2(imgD, outIm1, 0, 0, 0, 0);
saveas(I, '.\results\9.png');

I = show_correspondence2(imgD, outIm1, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
saveas(I, '.\results\10.png');

[H, inliers] = findBestHomography(fpvec);

I = show_correspondence2(imgD, outIm1, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));
saveas(I, '.\results\11.png');

outIm1 = overlapImage(imgD, outIm1, H, false, doBlend, false);
imwrite(outIm1, '.\results\12.png');

% -------------------------------------------------------------------------
% Now do the same with outIm1 and imgC

fpvec = getFeaturePoints2(imgE, outIm1, ratioThresh);

I = show_correspondence2(imgE, outIm1, 0, 0, 0, 0);
saveas(I, '.\results\13.png');

I = show_correspondence2(imgE, outIm1, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));
saveas(I, '.\results\14.png');

[H, inliers] = findBestHomography(fpvec);
I = show_correspondence2(imgE, outIm1, inliers(:,1), inliers(:,2), inliers(:,3), inliers(:,4));
saveas(I, '.\results\15.png');

outIm1 = overlapImage(imgE, outIm1, H, false, doBlend, true);
imwrite(outIm1, '.\results\16.png');


keyboard;

% -------------------------------------------------------------------------




% Now compute homographies.
% inlierThresh      = 3;
% bestInliers       = 0;
% best_inlier_vec   = zeros(1,4);
% bestH             = zeros(3,3);
% 
% for i=1:5000
%     % get random points
%     [rp1, rp2, rp3, rp4] = getFourRandomI( size(fpvec, 1) );
%     
%     pts = [ fpvec(rp1, 1:4); fpvec(rp2, 1:4); fpvec(rp3, 1:4); fpvec(rp4, 1:4) ];
%     
%     % get the corresponding homography
%     H = computeHomography( pts );
%     
%     numInliers = 0;
%     inlier_vec = zeros(1,4);
%     inlier_index = 1;
%     
%     for fp=1:size(fpvec, 1)
%         
%         target = [fpvec(fp, 3) fpvec(fp, 4)];
%         x      = [fpvec(fp, 1) fpvec(fp, 2)];
%         y      = transformByH(H, x);
%         
%         dist = sqrt((y(1,1) - target(1,1))^2 + (y(1,2) - target(1,2))^2);
%         
%         if dist < inlierThresh
%             numInliers = numInliers + 1;
%             inlier_vec(inlier_index,:) = fpvec(fp,1:4);
%             inlier_index = inlier_index + 1;
%         end
%     end
%     
%     if numInliers > bestInliers
%        bestH = H;
%        bestInliers = numInliers;
%        best_inlier_vec = inlier_vec;
%     end
% end
% 
% % recompute the H matrix from the most promising inliers.
% bestH = computeHomography( best_inlier_vec );

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






