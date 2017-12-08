function m = initBetweenWeights(m,Q,d,n)
    d = d-1;
    Q = Q;
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
                    m{i} = initBetweenWeights(m{i},Q,d,n);
            end
        % If we're at the bottom level, accommodate all sets of weight
        % matrices to fill.
%         else
%             temp{Q^2} = [];
%             m = temp;
%             for i = 1:length(m)
%                     m{i} = initBetweenWeights(m{i},Q^2,d,n,w);
%             end            
        end
    else
        % fully connected initial subset.
        temp = zeros(n,n);
        m = temp;
    end
end