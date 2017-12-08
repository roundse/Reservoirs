function [m count] = getTotalNeuronCount(m,d,count)
    d = d-1;
    if (d > 1)    
        for i = 1:length(m)
                m{i} = getTotalNeuronCount(m{i},d,count);
        end
    else
        % fully connected initial subset.
        for i = 1:length(m)
            temp_count(i) = length(m{i});
        end
        sum(temp_count)
    end
end