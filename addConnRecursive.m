function [m, order, internal] = addConnRecursive(m,Q,orig_d,d,in_w,exc_w,v,probs,internal,order)
    % Check to see if we've reached the bottom of the tree.
    % If not, keep going. Otherwise, add a neuron.
    if (d > 1)
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
            order(d-1) = index;
            [m{index}, order, internal] = addConnRecursive(m{index},Q,orig_d,d-1,in_w,exc_w,v,probs,internal,order);
        else        
            %disp('Adding a between-module connection.');
            % can't have the same submodules - that's an internal
            % connection.
            mod1 = 0;
            mod2 = 0;
            if d == orig_d
                while mod1 == mod2
                    mod1 = randi([1,Q]);
                    mod2 = randi([1,Q]); 
                end
            else
                mod1 = randi([1,Q]);
                mod2 = randi([1,Q]); 
            end
            index = getBetweenModIndex(Q,mod2,mod1);
            order(d-1) = index;
            
            % Check to make sure a fully-connected matrix wasn't selected.
            if ( d == 1 && all(all(m{index})) )
                % If a fully connected matrix was chosen, start over.
                disp(['No between-module connection added because ', ...
                'the matrix was fully connected.']);
               	return;
            end
            [m{index}, order, internal] = addConnRecursive(m{index},Q,orig_d,d-1,in_w,exc_w,v,probs,internal,order);
        end
    else
        if internal == true
            m = addNeuron(m,v,in_w);
        else        
            m = addExternalConn(m,exc_w);
        end        
    end
end