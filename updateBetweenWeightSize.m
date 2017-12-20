function m = updateBetweenWeightSize(m,Q,s,order,d)
    A = zeros(Q,Q);
    d = d-1;
    [r c] = ind2sub(size(A),order(1));
    if r == c
        mod = r;
    else
        disp('wtf');
    end
    % Check to see if we've reached level 2 (level above the bottom).
    % If we haven't, keep going; otherwise, get the length of the matrix.
    if (d >= 2)
        for i = 1:length(m)
            m{i} = updateBetweenWeightSize(m{i},Q,s,order,d);
        end
    else
        % If at level 1, need to update the size of all matrices that
        % relate to order(1).
        [pre post] = getModUpdateList(mod,Q);
        
        for i = 1:length(pre)
            if pre(i) == 1
                m{i}(s,:) = 0;
            elseif post(i) == 1
                m{i}(:,s) = 0;
            end
        end
        
    end    
end