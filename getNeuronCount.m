function [m, count] = getNeuronCount(m,Q,d,count)
    d = d-1;
    if (d > 1)    
        for i = 1:Q
            index = getBetweenModIndex(Q,i,i);
            [m{index}, count] = getNeuronCount(m{index},Q,d,count);
        end
    else
        % sum up neurons in each submodule for modules at d = 1.
        for i = 1:Q
            index = getBetweenModIndex(Q,i,i);
            temp_count(i) = length(m{index});
        end
        count = count + sum(temp_count);
    end
end