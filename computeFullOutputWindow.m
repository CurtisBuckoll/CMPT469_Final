function [newImH, newImW, translationX, translationY, outIm] = computeFullOutputWindow(imgTarget, imgA, imgB, imgC, imgD, H1, H2, H3, H4)

[imAh, imAw, comp] = size(imgA);
[imBh, imBw, comp] = size(imgB);
[imCh, imCw, comp] = size(imgC);
[imDh, imDw, comp] = size(imgD);

% first get the new window size we must create. We do this by transforming
% the extremes of the image B (its corners) and seeing where we end up.
xformed = zeros(4,4);

[a, b, c, d] = getExtrema(H1, imAh, imAw);
xformed(1,1:4) = [a b c d];
[a, b, c, d] = getExtrema(H2, imBh, imBw);
xformed(2,1:4) = [a b c d];
[a, b, c, d] = getExtrema(H1 * H3, imCh, imCw);
xformed(3,1:4) = [a b c d];
[a, b, c, d] = getExtrema(H2 * H4, imDh, imDw);
xformed(4,1:4) = [a b c d];

% I think find the min and max along the columns of transformed? this
% should give us our new image size, in some sense.

minX = min(xformed(:,1));
maxX = max(xformed(:,2));
minY = min(xformed(:,3));
maxY = max(xformed(:,4));

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

% Write the underlaying image (imgB) into the new image accounting for the
% vertical and horizontal shifts required.

outIm = zeros(newImH, newImW, 3);

for y=1:imBh
   for x = 1:imBw
       outIm(translationY + y, translationX + x, :) = imgTarget(y,x,:);
   end
end

end

function [minX, maxX, minY, maxY] = getExtrema(H, imh, imw)

    xformed = zeros(4,2);

    botL = transformByH( H, [1 1] );
    topL = transformByH( H, [1, imh] );
    botR = transformByH( H, [imw 1] );
    topR = transformByH( H, [imw imh] );
    xformed(1,:) = topL;
    xformed(2,:) = topR;
    xformed(3,:) = botL;
    xformed(4,:) = botR;
    minX = round(min(xformed(:,1)));
    maxX = round(max(xformed(:,1)));
    minY = round(min(xformed(:,2)));
    maxY = round(max(xformed(:,2)));

end

function y = transformByH( H, x )
    t = H * [ x 1 ]';
    y = [ t(1) / t(3), t(2) / t(3) ];
end