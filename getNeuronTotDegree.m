function [m, c] = getNeuronTotDegreePre(m,module_list,pre,nID,Q,d,c)
d = d-1;

% Module list tells the function where the neuron (nID) is located so that
% we can decide where to look for the degree
if d >= 1
    A = zeros(Q,Q);
    
    for j = 1:Q
        index = getBetweenModIndex(Q,module_list(d),j);
        [m{index}, c] = getNeuronTotDegreePre(m{index},module_list,pre,nID,Q,d,c);
    end
else
    
%     disp('this submodule is on path: ');
%     for i = length(path):-1:1
%         disp(num2str(path(i))');
%     end
%     
    temp = m;
    temp(temp>0) = 1;

    disp(['the size of this submodule is ',num2str(size(temp))]);
    
    c = c + sum(temp(nID,:));

end


end