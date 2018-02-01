function [m,order,complete_order] = getPathConnected(m,module_list,nID,Q,d,order,complete_order)

d = d-1;

% This function will return a list containing all places along the path
% that an attached neuron is located. The lists will be compared to see if
% connections exist between the neurons on the list.

if d >= 1
    A = zeros(Q,Q);
    
    for j = 1:Q
        index = getBetweenModIndex(Q,module_list(d),j);
        order(d+1) = index;

        [m{index}, order, complete_order] = getPathConnected(m{index},module_list,nID,Q,d,order,complete_order);
    end
else
    
    temp = m;
    temp(temp>0) = 1;

    connected = find(temp(nID,:)==1);
    
    if ~isempty(connected)
        temp_order = zeros(length(connected),length(order));
        for i = 1:length(connected)
            temp_order(i,:) = order;
            temp_order(i,1) = connected(i);
        end
        complete_order = vertcat(complete_order,temp_order);
    end  
end

end