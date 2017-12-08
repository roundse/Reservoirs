function [m order] = addNeuronRecursive(m,Q,d,v,w,order)
    d = d-1;
    
    % Check to see if we've reached the bottom of the tree.
    % If we haven't, keep going. Otherwise, add a neuron and make connect
    % it to v pre-existing neurons.
    if (d >= 1)
        mod = randi([1,Q]);
        order(d) = mod;
        [m{mod} order] = addNeuronRecursive(m{mod},Q,d,v,w,order);
    else
        l = length(m);
        m(l+1,:) = 0;
        m(:,l+1) = 0;
        l = length(m);
        
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

            while (l == inx || connection == true)
                r1 = rand;
                inx = find([-1 P] < r1, 1, 'last');
                if m(l,inx) == 0
                    connection = false;
                end
            end

            m(l,inx) = w;
            m(inx,l) = w;
        end
        
        %order = flip(order);
    end
end