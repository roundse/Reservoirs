function [m,top_index,index] = updateBetweenWeightSize(m,Q,s,order,orig_d,d,top_index,index)
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
                if (i == pre_m || j == pre_m)
                    if i == pre_m
                        index = getBetweenModIndex(Q,j,i);
                    else
                        index = getBetweenModIndex(Q,i,j);
                    end
                    if d == (orig_d-1)
                        top_index = index;
                        if i ~= j
                            [m{index}, top_index, index] = updateBetweenWeightSize(m{index},Q,s,order,orig_d,d,top_index,index);
                        end
                    else
                        [m{index}, top_index, index] = updateBetweenWeightSize(m{index},Q,s,order,orig_d,d,top_index,index);
                    end
                end
            end
        end
    else
        % If at level 1, need to update the size of all matrices that
        % relate to order(1).
        [pre post] = getModUpdateList(module,Q,order,top_index,pre_m);     
        
        for i = 1:length(pre)
            if pre(i) == 1
                m{i}(s,:) = 0;
            elseif post(i) == 1
                m{i}(:,s) = 0;
            end
        end   
    end
    
end