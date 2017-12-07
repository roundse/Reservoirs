function m = addModules(m,Q,d,n,w)
    d = d-1;
    if (d >= 1)
        temp{Q} = [];
        m = temp;    
        for i = 1:length(m)
                m{i} = addModules(m{i},Q,d,n,w);
        end
    else
        % fully connected initial subset.
        temp = w * ones(n,n);
        m = temp;
    end
end