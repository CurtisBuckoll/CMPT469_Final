function [a, b, c, d] = getFourRandomI( maxsz )
% these random numbers cannot be the same..

    a = randi([1 maxsz]);
    b = randi([1 maxsz]);
    c = randi([1 maxsz]);
    d = randi([1 maxsz]);
    while b == a
       b = randi([1 maxsz]);
    end
    while c == b || c == a
       c = randi([1 maxsz]); 
    end
    while d == c || d == b || d == a
       d = randi([1 maxsz]); 
    end
end