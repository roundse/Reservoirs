function m = updateInternalWeightSize(m,Q,s,order,orig_d,d)
    d = d-1;
    
    A = zeros(Q,Q);
    [r c] = ind2sub(size(A),order(1));
    if r == c
        mod = r;
    else
        disp('wtf');
    end
    
    if d >= 1
        m{order(d)} = updateBetweenWeightSize(m{order(d)},Q,s,order,orig_d,d);
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