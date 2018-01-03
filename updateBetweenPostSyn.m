function [m,top_index,index] = updateBetweenPostSyn(m,Q,s,order,orig_d,d,top_index,index)
    d = d-1;
    
    A = zeros(Q,Q);  
    
    if d > 0
        [pre_m,post_m] = ind2sub(size(A),order(d));
    end

    % Check to see if we've reached level 2 (level above the bottom).
    % If we haven't, keep going; otherwise, get the length of the matrix.
    if d >= 1
        for k = 1:Q
            index = getBetweenModIndex(Q,k,post_m);

            if d == (orig_d-1)
                top_index = index;
                if k ~= post_m
                    [m{index}, top_index, index] = updateBetweenPostSyn(m{index},Q,s,order,orig_d,d,top_index,index);
                end
            else
                [m{index}, top_index, index] = updateBetweenPostSyn(m{index},Q,s,order,orig_d,d,top_index,index);
            end
        end
    else
        m(:,s) = 0;
    end
    
end