function result = overlapImage(imgA, imgB, H)

% write the transformed image overtop..
[imAh, imAw, comp] = size(imgA);
[imBh, imBw, comp] = size(imgB);

% first get the new window size we must create. We do this by transforming
% the extremes of the image B (its corners) and seeing where we end up.
xformed = zeros(4,2);

% I think find the min and max along the columns of transformed? this
% should give us our new image size, in som way.

topL = transformByH( H, [1 1] );
topR = transformByH( H, [imBw 1] );
botL = transformByH( H, [1 imBh] );
botR = transformByH( H, [imBw imBh] );
xformed(1,:) = topL
xformed(2,:) = topR
xformed(3,:) = botL
xformed(4,:) = botR
minX = min(xformed(:,1));
maxX = max(xformed(:,1));
minY = min(xformed(:,2));
maxY = max(xformed(:,2));

for y=1:imAh
    for x=1:imAw
        newCoord = transformByH( H, [x y] );
        u        = round(newCoord(1,1));
        v        = round(newCoord(1,2));
        
        if (v >= 1 && v <= imBh && u >= 1 && u <= imBw )
            imgB(v,u,:) = imgA(y,x,:); %0.5 .* imgA(y,x,:) + 0.5 .* imgB(v,u,:);
        end
    end
end

imshow(imgB);

keyboard;
end

function y = transformByH( H, x )
    t = H * [ x 1 ]';
    y = [ t(1) / t(3), t(2) / t(3) ];
end