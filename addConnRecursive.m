function [m, order, internal] = addConnRecursive(m,Q,d,in_w,exc_w,v,probs,internal,order)
    % Check to see if we've reached the bottom of the tree.
    % If not, keep going. Otherwise, add a neuron.
    if d > 1
        if (isempty(internal) || internal == true)
            r = rand;
            if r <= probs(d-1)
                internal = true; 
            else
                internal = false;
            end
        end
        if internal == true
            %disp('Adding a within-module connection.');
%             r = rand;
%             if r < probs(d-1)
%                 internal = true;
                mod = randi([1,Q]);
                index = getBetweenModIndex(Q,mod,mod);                
%             else
%                 internal = false;
%                 mod1 = 0;
%                 mod2 = 0;
%                 % If an internal connection was chosen previously,
%                 % restrict to submodules with different numbers, otherwise
%                 % the connection will be internal again.      
%                 while mod1 == mod2
%                     mod1 = randi([1,Q]);
%                     mod2 = randi([1,Q]); 
%                 end
%                 index = getBetweenModIndex(Q,mod2,mod1);              
%             end

            order(d-1) = index;
            

            [m{index}, order, internal] = addConnRecursive(m{index},Q,d-1,in_w,exc_w,v,probs,internal,order);            
        else        
            internal = false;
            %disp('Adding a between-module connection.');
%             mod1 = 0;
%             mod2 = 0;
%             if d == orig_d
%                 % can't have the same submodules - that's an internal
%                 % connection.                
%                 while mod1 == mod2
%                     mod1 = randi([1,Q]);
%                     mod2 = randi([1,Q]); 
%                 end
%             else
                mod1 = randi([1,Q]);
                mod2 = randi([1,Q]); 
%             end
            index = getBetweenModIndex(Q,mod2,mod1);
            order(d-1) = index;
            
            % Check to make sure a fully-connected matrix wasn't selected.
            if d == 2
                checkIfInternal = zeros(1,length(order));
                for l = 1:length(order)
                    [pre(l),post(l)] = ind2sub(size(zeros(Q,Q)),order(l));
                    if pre(l) == post(l)
                        checkIfInternal(l) = 1;
                    end
                end
                
                if sum(checkIfInternal) == length(order)
%                     disp('internal connection being added, choose two new inds');
%                     return;
                    while mod1 == mod2
                        mod1 = randi([1,Q]);
                        mod2 = randi([1,Q]); 
                    end
                    index = getBetweenModIndex(Q,mod2,mod1);
                    order(d-1) = index;
                end
                
                if all(all(m{index}))
                    % If a fully connected matrix was chosen, start over.
                    disp(['No between-module connection added because ', ...
                    'the matrix was fully connected.']);
                    return;
                end                
            end
            [m{index}, order, internal] = addConnRecursive(m{index},Q,d-1,in_w,exc_w,v,probs,internal,order);
        end
    else

        if internal == true
            m = addNeuron(m,v,in_w);
        else 
            checkIfInternal = zeros(1,length(order));
                for l = 1:length(order)
                    [pre(l),post(l)] = ind2sub(size(zeros(Q,Q)),order(l));
                    if pre(l) == post(l)
                        checkIfInternal(l) = 1;
                    end
                end
                
                if sum(checkIfInternal) == length(order)
                    disp('SOMEHOW STILL ADDED AN INTERNAL CONN');
%                     return;
%                     while mod1 == mod2
%                         mod1 = randi([1,Q]);
%                         mod2 = randi([1,Q]); 
%                     end
%                     index = getBetweenModIndex(Q,mod2,mod1);
%                     order(d-1) = index;
                end            
            m = addExternalConn(m,exc_w);
        end        
    end
end