function m = addNeuron(m,n1,n2,v)
    m(n1,:) = 0;
    m(:,n2) = 0;
    
    % Connect new neuron to v other previously existing vertices.
    for i = 1:v
        connection = true;
        inx1 = 0;
        inx2 = 0;

        % Update degree counts.
        temp = m;
        temp(temp>0) = 1;
        D = sum(temp);
        totalD = sum(D);

        % Get probability
        P = cumsum(D ./ totalD);

        while inx1==inx2 || connection == true
            r1 = rand;
            inx1 = find([-1 P] < r1, 1, 'last');
            r2 = rand;
            inx2 = find([-1 P] < r2, 1, 'last');
            if m(inx1,inx2) == 0
                connection = false;
            end
        end

        m(inx1,inx2) = w;
    end
end