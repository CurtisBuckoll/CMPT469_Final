function H = computeHomography( pts )

A = zeros( 2 * size(pts,1), 9 );

for i=1:size(pts,1)
    x1 = pts(i,1);
    y1 = pts(i,2);
    x2 = pts(i,3);
    y2 = pts(i,4);
    A(i*2,:)   = [ x1, y1,  1,  0,  0,  0, -x2*x1, -x2*y1, -x2 ];
    A(i*2+1,:) = [  0,  0,  0, x1, y1,  1, -y2*x1, -y2*y1, -y2 ];
end

[U, D, V]    = svd(A);
%Vtrans       = V';
lastColIndex = size(V,2);
h            = V(:,lastColIndex);

H            = [ h(1:3)'; h(4:6)'; h(7:9)' ];

end

