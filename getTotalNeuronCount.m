function [m count] = getTotalNeuronCount(m,d,count)
    d = d-1;
    if (d > 1)    
        for i = 1:length(m)
            [m{i} count] = getTotalNeuronCount(m{i},d,count);
        end
    else
        % sum up neurons in each submodule for modules at d = 1.
        for i = 1:length(m)
            temp_count(i) = length(m{i});
        end
        count = count + sum(temp_count);
    end
end