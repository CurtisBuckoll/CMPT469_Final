% imgA = im2double(imread('blendtest1.png'));
% imgB = im2double(imread('blendtest2.png'));
% 
% blended = twoBandBlend_X(imgA, imgB);
% 
% imshow(blended);
% keyboard;

function blended = twoBandBlend(im1, im2, blendLR)

%  imwrite(im1,'blendtest1.png');
%  imwrite(im2,'blendtest2.png');


% -------------------------------------------------------------------------

im1_mask = rgb2gray(im1) > 0;
im2_mask = rgb2gray(im2) > 0;

overlap_mask = im1_mask & im2_mask;

% imshow(double(overlap_mask));
% imshow(double(im2_mask));

im1_over_im2 = im1_mask .* im1 + xor(im2_mask, overlap_mask) .* im2;
im2_over_im1 = xor(im1_mask, overlap_mask) .* im1 + im2_mask .* im2;

% imshow(im1_over_im2);
% imshow(im2_over_im1);

im1_low = imgaussfilt(im1_over_im2, 5);
im2_low = imgaussfilt(im2_over_im1, 5);
im1_high = im1_over_im2 - im1_low;
im2_high = im2_over_im1 - im2_low;

% imshow(im1_low)
% imshow(im2_low)
% imshow(im1_high)
% imshow(im2_high)

% get a bounding box for the overlap region.
rp = regionprops(overlap_mask, 'BoundingBox', 'Area');
area = [rp.Area].';
[~,ind] = max(area);
BB = rp(ind).BoundingBox;
% BB contains [x,y, width, height]

%imshow(double(overlap_mask));

startX = floor(BB(1,1));
startY = floor(BB(1,2));
endX  = startX + BB(1,3);
endY = startY + BB(1,4);

[imh, imw, comp] = size(im1);
blended = zeros(imh, imw, 3);

e = 2.718281828459;

% Write in the linearly blended pixels
for x=startX:endX
   for y=startY:endY
       if ( overlap_mask(y,x) == 1 )
           r = (x - startX) / (endX - startX);
           
           if (~blendLR)
              r = 1 - r; 
           end
           
           %blended(y,x,:) = (1-r) .* (im1_low(y,x,:) + im1_high(y,x,:)) + r .* (im2_low(y,x,:) + im2_high(y,x,:));
           
           % blend the hi freq on a different (non-linear) curve.
           r_hi  = 1/(e^(-(30*(r-0.5))) + 1);
           r_low = 1/(e^(-(10*(r-0.5))) + 1);
           %blended(y,x,:) = (1-r_hi) .* im1_low(y,x,:) + r_hi .* im2_low(y,x,:) + (1-r_hi) .* im1_high(y,x,:) + r_hi .* im2_high(y,x,:);
           blended(y,x,:) = (1-r_low) .* im1_low(y,x,:) + r_low .* im2_low(y,x,:) + (1-r_hi) .* im1_high(y,x,:) + r_hi .* im2_high(y,x,:);
       end
   end
end
%rectangle('Position', BB, 'EdgeColor', 'red');
%blended = blended + overlap_mask .* (im1_high);% + im2_high);
%imshow(blended);

%low_freq_avg = overlap_mask .* (im1_low + im2_low) ./2;

%blended = blended + hi_freq_sum  = overlap_mask .* (im1_high);% + im2_high);

% imshow(low_freq_avg);
% imshow(hi_freq_sum);

blended = xor(im1_mask, overlap_mask) .* im1 + blended + xor(im2_mask, overlap_mask) .* im2;
%imshow(blended)


%keyboard;
 

% -------------------------------------------------------------------------

% im1_mask = rgb2gray(im1) > 0;
% im2_mask = rgb2gray(im2) > 0;
% 
% overlap_mask = im1_mask & im2_mask;
% 
% % imshow(double(overlap_mask));
% % imshow(double(im2_mask));
% 
% im1_over_im2 = im1_mask .* im1 + xor(im2_mask, overlap_mask) .* im2;
% im2_over_im1 = xor(im1_mask, overlap_mask) .* im1 + im2_mask .* im2;
% 
% imshow(im1_over_im2);
% imshow(im2_over_im1);
% 
% im1_low = imgaussfilt(im1_over_im2, 5);
% im2_low = imgaussfilt(im2_over_im1, 5);
% im1_high = im1_over_im2 - im1_low;
% im2_high = im2_over_im1 - im2_low;
% 
% % imshow(im1_low)
% % imshow(im2_low)
% % imshow(im1_high)
% % imshow(im2_high)
% 
% low_freq_avg = overlap_mask .* (im1_low + im2_low) ./2;
% hi_freq_sum  = overlap_mask .* (im1_high);% + im2_high);
% 
% % imshow(low_freq_avg);
% % imshow(hi_freq_sum);
% 
% blended = xor(im1_mask, overlap_mask) .* im1 + (low_freq_avg + hi_freq_sum) + xor(im2_mask, overlap_mask) .* im2;
% imshow(blended)
% 
% 
% keyboard;
 
end







