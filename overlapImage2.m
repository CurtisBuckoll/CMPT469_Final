function outIm = overlapImage2(imgA, target, H, translationX, translationY, blend, blendLR)

%outIm = target;

[imTh, imTw, comp] = size(target);
[imAh, imAw, comp] = size(imgA);

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

inv_H = inv(H);

% -------------------------------------------------------------------------
% Taking below code and adding functionality for blending..

img_projected = zeros(imTh, imTw, 3);

for y=1:maxY - minY
   for x=1:maxX - minX
        to_sample = transformByH( inv_H, [x+minX-1, y+minY-1] );
        u         = round(to_sample(1,1));
        v         = round(to_sample(1,2));
        
        if (v >= 1 && v <= imAh && u >= 1 && u <= imAw )
            
            img_projected(y + minY + translationY, x + minX + translationX,:) = imgA(v,u,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
        end
   end
end

if ( blend )
    outIm = twoBandBlend(img_projected, target, blendLR);
else
    targetMask = rgb2gray(target) > 0;
    projMask   = rgb2gray(img_projected) > 0;
    outIm = img_projected + target .* xor(targetMask, targetMask & projMask);
end

%outIm = twoBandBlend(img_projected, target, blendLR);

imshow(outIm);
keyboard;

%imshow(target);
%imshow(img_projected);

%keyboard;

% -------------------------------------------------------------------------

% for y=1:maxY - minY
%    for x=1:maxX - minX
%         to_sample = transformByH( inv_H, [x+minX-1, y+minY-1] );
%         u         = round(to_sample(1,1));
%         v         = round(to_sample(1,2));
%         
%         if (v >= 1 && v <= imAh && u >= 1 && u <= imAw )
%             
%             outIm(y + minY + translationY, x + minX + translationX,:) = imgA(v,u,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
%         end
%    end
% end


%keyboard;

end

function y = transformByH( H, x )
    t = H * [ x 1 ]';
    y = [ t(1) / t(3), t(2) / t(3) ];
end