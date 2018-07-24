function outIm = overlapImage(imgA, imgB, H)

[imAh, imAw, comp] = size(imgA);
[imBh, imBw, comp] = size(imgB);

% first get the new window size we must create. We do this by transforming
% the extremes of the image B (its corners) and seeing where we end up.
xformed = zeros(4,2);

% I think find the min and max along the columns of transformed? this
% should give us our new image size, in some sense.

botL = transformByH( H, [1 1] );
topL = transformByH( H, [1, imAh] );
botR = transformByH( H, [imAw 1] );
topR = transformByH( H, [imAw imAh] );
xformed(1,:) = topL
xformed(2,:) = topR
xformed(3,:) = botL
xformed(4,:) = botR
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

if (minX > 1 )
   overlay_translX = minX; 
end

for y=1:maxY - minY
   for x=1:maxX - minX
        to_sample = transformByH( inv_H, [x+minX-1, y+minY-1] );
        u         = round(to_sample(1,1));
        v         = round(to_sample(1,2));
        
        if (v >= 1 && v <= imAh && u >= 1 && u <= imAw )
            
            outIm(y,x + overlay_translX,:) = imgA(v,u,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
        end
   end
end

imshow(outIm);
keyboard;


% for y=1:imAh
%     for x=1:imAw
%         newCoord = transformByH( H, [x y] );
%         u        = round(newCoord(1,1));
%         v        = round(newCoord(1,2));
%         
%         if (v >= 1 && v <= imBh && u >= 1 && u <= imBw )
%             imgB(v,u,:) = imgA(y,x,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
%         end
%     end
% end
% 
% imshow(imgB);
% 
% keyboard;
end

function y = transformByH( H, x )
    t = H * [ x 1 ]';
    y = [ t(1) / t(3), t(2) / t(3) ];
end