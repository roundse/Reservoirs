function m = addNeuronRecursive(m,Q,d,desired_d,v,w)
    d = d-1;
    
    % Check to see if we've reached the bottom of the tree.
    % If not, keep going. Otherwise, add a neuron.
    if (d >= desired_d)
        mod = randi([1,Q])
        m{mod} = addNeuronRecursive(m{mod},Q,d,desired_d,v,w);
    else
        [r c] = size(m);
        m(r+1,:) = 0;
        m(:,c+1) = 0;

        % Connect the newly created neuron to v existing vertices.
        for i = 1:v
            connection = true;
            inx = 0;

            % Update degree counts.
            temp = m;
            temp(temp>0) = 1;
            D = sum(temp);
            totalD = sum(D);

            % Get probability
            P = cumsum(D ./ totalD);

            while r+1 == inx || connection == true
                r1 = rand;
                inx = find([-1 P] < r1, 1, 'last');
                if m(r+1,inx) == 0
                    connection = false;
                end
            end

            m(r+1,inx) = w;
        end
    end
end