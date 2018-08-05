sz      = 8;
D       = dct(eye(8));
lengths = 0;
l_ind   = 1;
dots    = 0;
d_ind   = 1;

for c1=1:sz
    v1 = D(:,c1);
    lengths(l_ind) = norm(v1);
    l_ind = l_ind +1;
    for c2=c1+1:sz
        v2 = D(:,c2);
        dots(d_ind) = dot(v1,v2);
        d_ind = d_ind + 1;
    end 
end
for r1=1:sz
    v1 = D(r1,:);
    lengths(l_ind) = norm(v1);
    l_ind = l_ind +1;
    for r2=r1+1:sz
        v2 = D(r2,:);
        dots(d_ind) = dot(v1,v2);
        d_ind = d_ind + 1;
    end 
end

lengths
dots