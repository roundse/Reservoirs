function [m, c] = getNeuronTotDegreePost(m,module_list,nID,Q,d,c,path)
d = d-1;

% Module list tells the function where the neuron (nID) is located so that
% we can decide where to look for the degree
if d >= 1
    A = zeros(Q,Q);
    
    for j = 1:Q
        if module_list(d) ~= j
            index = getBetweenModIndex(Q,j,module_list(d));
            path(d) = index;
            [m{index}, c] = getNeuronTotDegreePost(m{index},module_list,nID,Q,d,c,path);
        end
    end
else
    
%     disp('this submodule is on path: ');
%     for i = length(path):-1:1
%         disp(num2str(path(i))');
%     end
%     
    temp = m;
    temp(temp>0) = 1;

    %disp(['the size of this submodule is ',num2str(size(temp))]);
    c = c + sum(temp(:,nID));

end


end