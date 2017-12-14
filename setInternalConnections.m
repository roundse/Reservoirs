function m = setInternalConnections(m,Q,d,w)
    d = d-1;
    if (d >= 1)    
        for i = 1:Q
            index = getBetweenModIndex(Q,i,i);
            m{index} = setInternalConnections(m{index},Q,d,w);
        end
    else
        % fully connected initial subset.
        m(:,:) = w;
    end
end