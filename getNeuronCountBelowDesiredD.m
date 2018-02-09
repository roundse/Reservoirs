function [m, count] = getNeuronCountBelowDesiredD(m,Q,d,dd,mod_dd,count)
    d = d-1;
    if (d > 1)    
        for i = 1:Q
            
            if d <= dd
                index = getBetweenModIndex(Q,i,i);
                [m{index}, count] = getNeuronCount2(m{index},Q,d,dd,mod_dd,count);
            else
                index = getBetweenModIndex(Q,mod_dd,mod_dd);
                [m{index},count] = getNeuronCount2(m{index},Q,d,dd,mod_dd,0);
            end
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