function [m, order] = getPathConnected(m,module_list,nID,Q,d,order)

d = d-1;

% This function will return a list containing all places along the path
% that an attached neuron is located. The lists will be compared to see if
% connections exist between the neurons on the list.

if d >= 1
    A = zeros(Q,Q);
    
    for j = 1:Q
        index = getBetweenModIndex(Q,module_list(d),j);
        if ~isempty(order)
            order(end+1,d+2) = index;
        else
            order(1,d+1) = index;
        end
        [m{index}, order] = getPathConnected(m{index},module_list,nID,Q,d,order);
    end
else
    size(order)
%     disp('this submodule is on path: ');
%     for i = length(order):-1:1
%         disp(num2str(order(i))');
%     end
    
    temp = m;
    temp(temp>0) = 1;

    %disp(['the size of this submodule is ',num2str(size(temp))]);
    connected = find(temp(nID,:)==1);
    
    if ~isempty(connected)
        for i = 1:length(connected)
            temp_order(i,:) = order(end,:);
            temp_order(i,d+1) = connected(i);
        end
    else
        temp_order = [];
    end

    if ~isempty(temp_order)
        order = vertcat(order,temp_order);
    end

%     disp('this submodule is on path: ');
%     for i = 1:size(temp_order,1)
%         %for j = size(temp_order,2):-1:1
%             disp(num2str(temp_order(i,:)));
%         %end
%     end

end

end