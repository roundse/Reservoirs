function [m, count] = getTotalBetweenModConnCount(m,Q,d,count)
    d = d-1;
    if (d > 1)    
        for i = 1:Q
            for j = 1:Q
                %if i~=j
                    index = getBetweenModIndex(Q,j,i);
                    [m{index}, count] = getTotalBetweenModConnCount(m{index},Q,d,count);
                %end
            end
        end
    else
        % sum up connections in each submodule for modules at d = 1.
        for i = 1:Q
            for j = 1:Q
                if i~=j
                    index = getBetweenModIndex(Q,j,i);
                    temp = m{index};
                    temp(temp>0) = 1;
                    count = count + sum(sum(temp));
                end
            end
        end
    end
end