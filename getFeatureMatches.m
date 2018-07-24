function [matches, score] = getFeatureMatches(d1, d2, thresh)

score   = zeros(1);
matches = zeros(2,1);

% d1_best_index = 0;
% d2_best_index = 0;

% size(d1, 2)
% size(d2, 2)

match_index = 1;

for i=1:size(d1, 2)
    
    best_cost      = 999999999999;
    next_best_cost = 999999999999;

    for k=1:size(d2, 2)   
        c = computeDescriptorDistance(d1(:,i), d2(:,k));
        
        if ( c < best_cost )
            best_cost = c;
            d1_best_index = i;
            d2_best_index = k;
        elseif ( c < next_best_cost)
            next_best_cost = c;
        end
    end
    
    s = best_cost / next_best_cost;
    
    if ( s < thresh )

        matches(:,match_index) = [ d1_best_index, d2_best_index ]';
        score(match_index) = s;
        match_index = match_index + 1;
    end
end

end


function cost = computeDescriptorDistance(d1, d2)
    diff = (double(d1) - double(d2)).^2;
    cost = sum(diff);
end