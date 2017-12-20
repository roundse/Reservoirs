function m = addNeuron(m,v,w)
    disp('Adding a new neuron for an internal connection.');
    l = length(m);
    m(l+1,:) = 0;
    m(:,l+1) = 0;
    l = length(m);

    % Connect the newly created neuron to v existing vertices.
    for i = 1:v
        connection = true;
        inx = 0;

        % Update degree counts.
        temp = m;

        temp(temp>0) = 1;
        D = sum(temp);
        totalD = sum(D);

        % Get probability
        P = cumsum(D ./ totalD);

        while (l == inx || connection == true)
            r1 = rand;
            inx = find([-1 P] < r1, 1, 'last');
            if ( m(l,inx) == 0 && m(inx,l) == 0 )
                connection = false;
            end
        end

        m(l,inx) = w;
        m(inx,l) = w; 
    end
end