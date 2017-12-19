function [m, order, internal] = addConnRecursive(m,Q,d,in_w,exc_w,v,probs,internal,order)
    d = d-1;
    % Check to see if we've reached the bottom of the tree.
    % If not, keep going. Otherwise, add a neuron.
    if (d >= 1)
        if internal == true
            %disp('Adding a within-module connection.');
            r = rand;
            if r <= probs(d)
                internal = true;
            else
                internal = false;
            end
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
            
            % Check to make sure a fully-connected matrix wasn't selected.
            if ( d == 1 && all(all(m{index})) )
                % If a fully connected matrix was chosen, start over.
                disp(['No between-module connection added because ', ...
                'the matrix was fully connected.']);
               	return;
            end
                
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