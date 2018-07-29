function outIm = overlapImage(imgA, imgB, H, shrink_large_sides, blend, blendLR)

[imAh, imAw, comp] = size(imgA);
[imBh, imBw, comp] = size(imgB);

% first get the new window size we must create. We do this by transforming
% the extremes of the image A (its corners) and seeing where we end up.
xformed = zeros(4,2);

% I think find the min and max along the columns of transformed? this
% should give us our new image size, in some sense.

botL = transformByH( H, [1 1] );
topL = transformByH( H, [1, imAh] );
botR = transformByH( H, [imAw 1] );
topR = transformByH( H, [imAw imAh] );
xformed(1,:) = topL;
xformed(2,:) = topR;
xformed(3,:) = botL;
xformed(4,:) = botR;
minX = round(min(xformed(:,1)));
maxX = round(max(xformed(:,1)));
minY = round(min(xformed(:,2)));
maxY = round(max(xformed(:,2)));

newImH = imBh;
newImW = imBw;

translationX = 0;
translationY = 0;

%Compute the new image boundaries.
if ( minX < 1 )
    newImW = newImW + abs(minX);
    translationX = translationX + abs(minX);
end
if ( maxX > imBw )
    newImW = newImW + (abs(maxX) - imBw);
    %translationX = translationX + abs(maxX);
end
if ( minY < 1 )
    newImH = newImH + abs(minY);
    translationY = translationY + abs(minY);
end
if ( maxY > imBh )
    newImH = newImH + (abs(maxY) - imBh);
    %translationY = translationY + abs(maxY);
end

outIm = zeros(newImH, newImW, 3);

% Write the underlaying image (imgB) into the new image accounting for the
% vertical and horizontal shifts required.
for y=1:imBh
   for x = 1:imBw
       outIm(translationY + y, translationX + x, :) = imgB(y,x,:);
   end
end

imshow(outIm);

% the minX, maxX, minY, maxY parameters define a bounding box for the warp.
% We can use these parameters to iterate through and perform the inverse
% warp on pixels roughly where the image will end up before translated to
% be in frame.

inv_H = inv(H);

% depending on orientation, it seems that we have to account for
% realignment in some cases..
overlay_translX = 0;
overlay_translY = 0;

img_projected = zeros(newImH, newImW, 3);

if ~shrink_large_sides

    if (minX > 1 )
       overlay_translX = minX; 
    end
    if (minY > 1 )
       overlay_translY = minY ;
    end

    for y=1:maxY - minY
       for x=1:maxX - minX
            to_sample = transformByH( inv_H, [x+minX-1, y+minY-1] );
            u         = round(to_sample(1,1));
            v         = round(to_sample(1,2));

            if (v >= 1 && v <= imAh && u >= 1 && u <= imAw )

                img_projected(y + overlay_translY,x + overlay_translX,:) = imgA(v,u,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
            end
       end
    end
    
else
   
    
    if (minX > 1 )
       overlay_translX = minX; 
    end
    if (minY > 1 )
       overlay_translY = minY ;
    end
        

    for y=1:maxY - minY
       for x=1:maxX - minX
            to_sample = transformByH( inv_H, [x+minX-1, y+minY-1] );
            u         = round(to_sample(1,1));
            v         = round(to_sample(1,2));

            if (v >= 1 && v <= imAh && u >= 1 && u <= imAw )

                img_projected(y + overlay_translY,x + overlay_translX,:) = imgA(v,u,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
            end
       end
    end
    
    flattened = warp_image_flat(outIm, img_projected, blendLR);
    
    outIm = outIm + flattened;
end

if ( blend )
    outIm = twoBandBlend(outIm, img_projected, blendLR);
else
    targetMask = rgb2gray(outIm) > 0;
    projMask   = rgb2gray(img_projected) > 0;
    outIm = img_projected + outIm .* xor(targetMask, targetMask & projMask);
end

imshow(outIm);
%keyboard;

end

function y = transformByH( H, x )
    t = H * [ x 1 ]';
    y = [ t(1) / t(3), t(2) / t(3) ];
end


% function result = warp_image_flat(target, projected, LROrientation)
% 
% [imh, imw, comp] = size(target);
% 
% target_mask = rgb2gray(target) > 0;
% proj_mask   = rgb2gray(projected) > 0;
% overlap_mask = target_mask & proj_mask;
% proj_non_overlap_mask = xor(overlap_mask, proj_mask);
% 
% imshow(double(overlap_mask));
% imshow(double(proj_mask));
% 
% overlap_region = (target_mask & proj_mask) .* projected;
% 
% % get a bounding box for the overlap region.
% rp = regionprops(overlap_mask, 'BoundingBox', 'Area');
% area = [rp.Area].';
% [~,ind] = max(area);
% BB_overlap = rp(ind).BoundingBox;
% 
% imshow(double(overlap_mask));
% rectangle('Position', BB_overlap, 'EdgeColor', 'red');
% 
% rp = regionprops(proj_non_overlap_mask, 'BoundingBox', 'Area');
% area = [rp.Area].';
% [~,ind] = max(area);
% BB_projected = rp(ind).BoundingBox;
% 
% imshow(double(proj_non_overlap_mask));
% rectangle('Position', BB_projected, 'EdgeColor', 'red');
% 
% overlap_mask_not_cutoff = zeros(imh, imw, 1);
% overlap_mask_not_cutoff(:,floor(BB_overlap(1,1)):imw) = 1;
% imshow( overlap_mask_not_cutoff );
% overlap_mask_not_cutoff = overlap_mask_not_cutoff & proj_mask;
% imshow( overlap_mask_not_cutoff );
% 
% rp = regionprops(overlap_mask_not_cutoff, 'BoundingBox', 'Area');
% area = [rp.Area].';
% [~,ind] = max(area);
% BB_overlap = rp(ind).BoundingBox;
% 
% [p1 p2 p3 p4] = BB_to_coords( BB_overlap(1,1), BB_overlap(1,2), BB_overlap(1,3), BB_overlap(1,4) )
% 
% [q1 q2 q3 q4] = BB_to_coords( BB_projected(1,1), BB_projected(1,2), BB_projected(1,3), BB_projected(1,4) )
% 
% pointsforHomog = zeros(4,4)
% 
% pointsforHomog(1,:) = [ p3 p3 ];
% pointsforHomog(2,:) = [ p1 p1 ];
% pointsforHomog(3,:) = [ q3 q3(1,1) p3(1,2) ];
% pointsforHomog(4,:) = [ q1 q1(1,1) p1(1,2) ];
% 
% H = computeHomography( pointsforHomog );
% 
% startX = floor(BB_projected(1,1)) + 1;
% startY = floor(BB_projected(1,2)) + 1;
% endX  = startX - 1 + BB_projected(1,3);
% endY = startY - 1 + BB_projected(1,4);
% 
% result = zeros(imh, imw, 3);
% 
% inv_H = inv(H);
% 
% % Do forward warping
% for x=startX:endX
%    for y=startY:endY
%        
%         to_sample = transformByH( inv_H, [x, y] );
%         u         = round(to_sample(1,1));
%         v         = round(to_sample(1,2));
%                        
%         if (v >= 1 && v <= imh && u >= 1 && u <= imw )
%             if ( proj_mask(v,u) == 1 )
%                 result(y,x,:) = projected(v,u,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
%             end
%        end
%    end
% end
% 
% warped_mask = rgb2gray(result) > 0;
% 
% result = result .* xor(overlap_mask_not_cutoff, warped_mask) + overlap_region;
% 
% imshow(result)
% 
% end
% 
% 
% % p1, p2 ... start at top left corner and follow clockwise orientation
% function [p1, p2, p3, p4] = BB_to_coords( topL, topR, w, h )
% 
% p1 = [floor(topL), floor(topR)]
% 
% p2 = [floor(topL) + w, floor(topR)]
% 
% p3 = [floor(topL), floor(topR) + h]
% 
% p4 = [floor(topL) + w, floor(topR) + h]
% 
% end










