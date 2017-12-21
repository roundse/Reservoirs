function m = updateBetweenWeightSize(m,Q,s,order,orig_d,d)
    d = d-1;
    
    A = zeros(Q,Q);
    [r c] = ind2sub(size(A),order(1));
    if r == c
        module = r;
    else
        disp('wtf');
    end   
    
    if d > 0
        [post_m, pre_m] = ind2sub(size(A),order(d));
    end
    
    % Check to see if we've reached level 2 (level above the bottom).
    % If we haven't, keep going; otherwise, get the length of the matrix.
    if d > 1
        for i = 1:Q
            for j = 1:Q
                if ( (i == pre_m || j == post_m) && i~=j)
                    index = getBetweenModIndex(Q,j,i);
                    m{index} = updateBetweenWeightSize(m{index},Q,s,order,orig_d,d);
                end
            end
        end
    else
        % If at level 1, need to update the size of all matrices that
        % relate to order(1).
        [pre post] = getModUpdateList(module,Q);        
        for i = 1:length(pre)
            if pre(i) == 1
                m{i}(s,:) = 0;
            elseif post(i) == 1
                m{i}(:,s) = 0;
            end
        end   
    end
    
end