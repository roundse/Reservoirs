function m = initWeights(m,Q,d,n)
    d = d-1;
    % Check to see if at the bottom of the tree.
    % If we are not at the bottom, keep looking.
    % Otherwise, initialize weight matrices.
    if (d >= 1)
        % If we're more than 1 level from the bottom, keep adding Q
        % submodules.
        if d >= 1
            temp{Q} = [];
            m = temp;    
            for i = 1:length(m)
                    m{i} = initWeights(m{i},Q,d,n);
            end           
        end
    else
        % No connections between modules to begin with.
        temp = zeros(n,n);
        m = temp;
    end
end