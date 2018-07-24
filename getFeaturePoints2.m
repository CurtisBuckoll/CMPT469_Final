function fpvec = getFeaturePoints2(imgA, imgB, thresh)

peak_thresh = 0.015;
edge_thresh = 2.0;

[f1,d1] = vl_sift(single(rgb2gray(imgA)), 'PeakThresh', peak_thresh, 'edgethresh', edge_thresh );
[f2,d2] = vl_sift(single(rgb2gray(imgB)), 'PeakThresh', peak_thresh, 'edgethresh', edge_thresh );

matches = getFeatureMatches(d1, d2, thresh);

%size(matches, 2)

fpvec = zeros(1,4);
for i=1:size(matches, 2)
    fpvec(i,:) = [f1((1:2), matches(1,i))' f2((1:2), matches(2,i))'];
end

%h = show_correspondence2(imgA, imgB, fpvec(:,1), fpvec(:,2), fpvec(:,3), fpvec(:,4));



