function [m, order, internal] = addConnRecursive(m,Q,d,in_w,exc_w,v,probs,internal,order)
    d = d-1;
    % Check to see if we've reached the bottom of the tree.
    % If not, keep going. Otherwise, add a neuron.
    if (d >= 1)
        r = rand;
        if r < probs(d)
            %disp('Adding a within-module connection.');
            internal = true;
            mod = randi([1,Q]);
            index = getBetweenModIndex(Q,mod,mod);
            order(d) = index;
            [m{index}, order, internal] = addConnRecursive(m{index},Q,d,in_w,exc_w,v,probs,internal,order);
        else        
            %disp('Adding a between-module connection.');
            internal = false;
            % can't have the same submodules - that's an internal
            % connection.
            mod1 = 0;
            mod2 = 0;
            while mod1 == mod2
                mod1 = randi([1,Q]);
                mod2 = randi([1,Q]); 
            end
            index = getBetweenModIndex(Q,mod2,mod1);
            order(d) = index;
            [m{index}, order, internal] = addConnRecursive(m{index},Q,d,in_w,exc_w,v,probs,internal,order);
        end
    else
        if internal == true
            m = addNeuron(m,v,in_w);
        else
            m = addExternalConn(m,exc_w);
        end        
    end
end