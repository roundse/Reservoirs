function m = addExternalConnRecursive(m,Q,d,desired_d,w)
    d = d-1;
    
    % Check to see if we've reached the bottom of the tree.
    % If not, keep going. Otherwise, add a neuron.
    if (d >= desired_d)
        mod1 = randi([1,Q]);
        mod2 = randi([1,Q]);   
        index = getBetweenModIndex(mod1,mod2)
        m{index} = addExternalConnRecursive(m{index},Q,d,desired_d,w);
   
    else
        connection = true;
        inx1 = 0;
        inx2 = 0;

        % Update degree counts.
        temp = m;
        temp(temp>0) = 1;
        D = sum(temp);
        totalD = sum(D);

        % Get probability
        P = cumsum(D ./ totalD);

        while connection == true
            r1 = rand;
            inx1 = find([-1 P] < r1, 1, 'last');
            r2 = rand;
            inx2 = find([-1 P] < r2, 1, 'last');
            if m(inx1,inx2) == 0
                connection = false;
            end
        end

        m(inx1,inx2) = w;
    end
end