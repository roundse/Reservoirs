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
            else
                [m{index}, top_index, index] = updateBetweenPreSyn(m{index},Q,s,order,orig_d,d,top_index,index,path);
            end
        end
    else
        
%         disp('this submodule is on path: ');
%         for i = length(path):-1:1
%             disp(num2str(path(i))');
%         end      
        
        m(s,:) = 0;
    end
    
end