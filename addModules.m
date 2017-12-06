function m = addModules(m,Q,d,n1,n2,w)
    d = d-1;
    if (d >= 1)
        temp{Q} = [];
        m = temp;    
        for i = 1:length(m)
                m{i} = addModules(m{i},Q,d,n1,n2,w);
        end
    else
        % fully connected initial subset.
        temp = w * ones(n1,n2);
        m = temp;
    end
end