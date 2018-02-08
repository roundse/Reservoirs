function [m, order, path1, path2, internal] = addConnRecursive(orig_m,m,Q,orig_d,d,in_w,exc_w,v,probs,internal,order,path1,path2)
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
            path1(d-1) = mod;
            path2(d-1) = mod;

            [m{index}, order, path1, path2, internal] = addConnRecursive(orig_m,m{index},Q,orig_d,d-1,in_w,exc_w,v,probs,internal,order,path1,path2);            
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
            path1(d-1) = mod1;
            path2(d-1) = mod2;  
            
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
                    path1(d-1) = mod1;
                    path2(d-1) = mod2;                   
                end
                
                if all(all(m{index}))
                    % If a fully connected matrix was chosen, start over.
                    disp(['No between-module connection added because ', ...
                    'the matrix was fully connected.']);
                    return;
                end                
            end
            
            [m{index}, order, path1, path2, internal] = addConnRecursive(orig_m,m{index},Q,orig_d,d-1,in_w,exc_w,v,probs,internal,order,path1,path2);
        end
    else

        if internal == true
            m = addNeuron(orig_m,m,Q,orig_d,v,in_w,path1);
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
            m = addExternalConn(orig_m,m,Q,orig_d,exc_w,path1,path2);
        end        
    end
end