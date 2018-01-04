function [m c] = getNeuronTotDegree(m,module,pre,nID,Q,d,c)
d = d-1;

if d >= 1
    for j = 1:3
        if pre == true
            index = getBetweenModIndex(Q,module,j);
        else
            index = getBetweenModIndex(Q,j,module);
        end
        [m{index}, c] = getNeuronTotDegree(m{index},module,pre,nID,Q,d,c);
    end
else
    temp = m;
    temp(temp>0) = 1
    
    if pre == true
        c = c + sum(temp(nID,:));
    else
        c = c + sum(temp(:,nID));
    end
end


end