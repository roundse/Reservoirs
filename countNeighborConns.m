function [m,c,order,i] = countNeighborConns(m,Q,d,p1,p2,c,order,i)
    d = d-1;
    
    % Check for both pre and post connections.
    if d >= 1
        index = getBetweenModIndex(Q,p1(d+1),p2(d+1));
        order(d) = index; 
        [m{index},c,order,i] = countNeighborConns(m{index},Q,d,p1,p2,c,order,i);
    else
        % If a connection exists between these indeces on this path,
        % consider these neighbor neurons connected.

        if m(p1(d+1),p2(d+1)) > 0
            c = 1;
        end
    end
end