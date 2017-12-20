function m = updateBetweenWeightSize(m,Q,s,order,orig_d,d)
    d = d-1;
    
    if d == (orig_d-1)
        top = true;
        if d == 1
            bottom = true;
        else
            bottom = false;
        end
    elseif d == 1
        top = false;
        bottom = true;
    else
        top = false;
        bottom = false;
    end
    
    A = zeros(Q,Q);
    [r c] = ind2sub(size(A),order(1));
    if r == c
        mod = r;
    else
        disp('wtf');
    end
    % Check to see if we've reached level 2 (level above the bottom).
    % If we haven't, keep going; otherwise, get the length of the matrix.
    if ( top == true && bottom == false )
        for i = 1:Q
            for j = 1:Q
                if i ~= j
                    index = getBetweenModIndex(Q,j,i);
                    m{index} = updateBetweenWeightSize(m{index},Q,s,order,orig_d,d);
                end
            end
        end        
    elseif ( top == true && bottom == true )
        % If at level 1, need to update the size of all matrices that
        % relate to order(1).
        [pre post] = getModUpdateList(mod,Q);
        
        for i = 1:Q
            for j = 1:Q
                if i ~= j
                    index = getBetweenModIndex(Q,j,i);
                    if pre(index) == 1
                        m{index}(s,:) = 0;
                    elseif post(i) == 1
                        m{index}(:,s) = 0;
                    end
                end
            end
        end
    elseif ( top == false && bottom == true )
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
    else
        for i = 1:length(m)
            m{i} = updateBetweenWeightSize(m{i},Q,s,order,d);
        end       
    end    
end