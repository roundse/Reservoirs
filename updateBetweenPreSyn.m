function [m,top_index,index] = updateBetweenPreSyn(m,Q,s,order,orig_d,d,top_index,index,path)
    d = d-1; 
    
    A = zeros(Q,Q);  

    if d > 0
        [pre_m,post_m] = ind2sub(size(A),order(d));
    end

    % Check to see if we've reached level 2 (level above the bottom).
    % If we haven't, keep going; otherwise, get the length of the matrix.
    if d >= 1
        for k = 1:Q
            index = getBetweenModIndex(Q,pre_m,k);
            path(d) = index;
            if d == (orig_d-1)
                top_index = index;
                %if k ~= pre_m
                    [m{index}, top_index, index] = updateBetweenPreSyn(m{index},Q,s,order,orig_d,d,top_index,index,path);
                %end
            elseif d == 1
             checkIfInternal = zeros(1,length(path));
                for l = 1:length(path)
                    [pre(l),post(l)] = ind2sub(size(zeros(Q,Q)),path(l));
                    if pre(l) == post(l)
                        checkIfInternal(l) = 1;
                    end
                end
                
                if ( sum(checkIfInternal) == length(path) )
                    if k ~= pre_m
                        [m{index}, top_index, index] = updateBetweenPreSyn(m{index},Q,s,order,orig_d,d,top_index,index,path);
                    end
                else
                    [m{index}, top_index, index] = updateBetweenPreSyn(m{index},Q,s,order,orig_d,d,top_index,index,path);
                end                
            else
                [m{index}, top_index, index] = updateBetweenPreSyn(m{index},Q,s,order,orig_d,d,top_index,index,path);
            end
        end
    else
        checkIfInternal = zeros(1,length(path));
        for l = 1:length(path)
            [pre(l),post(l)] = ind2sub(size(zeros(Q,Q)),path(l));
            if pre(l) == post(l)
                checkIfInternal(l) = 1;
            end
        end

        if sum(checkIfInternal) == length(path)
            disp('Somehow added an internal conn while updating pre synapses.');
%                     return;
%                     while mod1 == mod2
%                         mod1 = randi([1,Q]);
%                         mod2 = randi([1,Q]); 
%                     end
%                     index = getBetweenModIndex(Q,mod2,mod1);
%                     order(d-1) = index;
        end         
%         disp('this submodule is on path: ');
%         for i = length(path):-1:1
%             disp(num2str(path(i))');
%         end      
        
        m(s,:) = 0;
    end
    
end