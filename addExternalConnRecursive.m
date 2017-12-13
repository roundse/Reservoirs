function m = addExternalConnRecursive(m,Q,d,w)
    d = d-1;
    
    % Check to see if we've reached the bottom of the tree.
    % If not, keep going. Otherwise, add a neuron.
    if (d >= 1)
        mod1 = randi([1,Q]);
        mod2 = randi([1,Q]);   
        index = getBetweenModIndex(mod1,mod2);
        m{index} = addExternalConnRecursive(m{index},Q,d,w);
   
    else
        connection = true;
        inx1 = 0;
        inx2 = 0;

        % Update degree counts.
        temp = m;

        temp(temp>0) = 1;
        
        % If no connections exist, randomly pick two.
        % Otherwise, grow using PA rule.
        if ~any(temp)
            inx1 = randi([1, size(temp,1)]);
            inx2 = randi([1, size(temp,2)]);
        else
            D1 = sum(temp);
            D2 = sum(transpose(temp));
            totalD = sum(D1);

            % Get probability
            P1 = cumsum(D1 ./ totalD);
            P2 = cumsum(D2 ./ totalD);
            
            if (length(find(P1==1)) > 2 || length(find(P2==1)) < 2)
                inx1 = randi([1, size(temp,1)]);
                inx2 = randi([1, size(temp,2)]);
            else
                while connection == true
                    r1 = rand;
                    inx1 = find([-1 P1] < r1, 1);
                    r2 = rand;
                    inx2 = find([-1 P2] < r2, 1);
                    
                    if m(inx1,inx2) == 0 
                        connection = false;
                    end   
                end
            end
        end
        
        m(inx1,inx2) = w;
        m(inx2,inx1) = w;
    end
end