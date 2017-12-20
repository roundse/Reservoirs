function [m, count] = getTotalBetweenModConnCount(m,Q,orig_d,d,count)
    d = d-1;
    if (d > 1)    
        for i = 1:Q
            for j = 1:Q
                if d == (orig_d-1)
                    if i~=j
                        index = getBetweenModIndex(Q,j,i);
                        [m{index}, count] = getTotalBetweenModConnCount(m{index},Q,orig_d,d,count);
                    end
                else
                    index = getBetweenModIndex(Q,j,i);
                    [m{index}, count] = getTotalBetweenModConnCount(m{index},Q,orig_d,d,count);                    
                end
            end
        end
    else
        % sum up connections in each submodule for modules at d = 1.
        for i = 1:Q
            for j = 1:Q
                index = getBetweenModIndex(Q,j,i);
                temp = m{index};
                temp(temp>0) = 1;
                count = count + sum(sum(temp));  
            end
        end
    end
end