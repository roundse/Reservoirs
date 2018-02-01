function [m,c] = countNeighborConns(m,Q,d,p1,p2,c)
    d = d-1;
    
    % Check for both pre and post connections.
    for i = 1:2
        if d >= 1
            if i == 1
                index = getBetweenModIndex(Q,p1(d+1),p2(d+1));
            else
                index = getBetweenModIndex(Q,p2(d+1),p1(d+1));
            end
            [m{index},c] = countNeighborConns(m{index},Q,d,p1,p2,c);
        else
            % If a connection exists between these indeces on this path,
            % consider these neighbor neurons connected.
            if i == 1
                if m(p1(d+1),p2(d+1)) > 0
                    c = c+1;
                end
            else
                if m(p2(d+1),p1(d+1)) > 0
                    c = c+1;
                end
            end
        end
    end
end