function m = addExternalConn(m,w)
    disp('Adding a new connection between modules.');
    
    connection = true;
    
    prev_inx1 = 0;
    prev_inx2 = 0;
    inx1 = nan;
    inx2 = nan;

    % Update degree counts.
    temp = m;

    temp(temp>0) = 1;

    % If no connections exist or the degree is 1, then randomly choose two
    % neurons.
    % Otherwise, grow using PA rule.
    
    if ( ~(any(any(temp))) ||  sum(sum(temp)) == 1 )
        inx1 = randi([1, size(temp,1)]);
        inx2 = randi([1, size(temp,2)]);
    else
        D1 = sum(temp);
        D2 = sum(transpose(temp));
        totalD = sum(D1);

        % Get probability
        P1 = cumsum(D1 ./ totalD);
        P2 = cumsum(D2 ./ totalD);

        % Randomly select neurons if the matrix is too small for PA rule,
        % or if the matrix has too few connections to begin with.
        if ( (length(P1) <= 2 && length(P2) <=2) || ...
                (length(unique(P1)) ~= length(P1) || ...
            (length(unique(P2)) ~= length(P2))) )
            inx1 = randi([1, size(temp,1)]);
            inx2 = randi([1, size(temp,2)]);
        else
            inf_count = 0;
            while connection == true
                if (prev_inx1 == inx1 && prev_inx2 == inx2)
                    inf_count = inf_count + 1;
                    
                    if inf_count == 5
                        disp('gone infinite, exiting');
                        return;
                    end
                end
                r1 = rand;
                temp_inx1 = find([-1 P1] < r1);
                r2 = rand;
                temp_inx2 = find([-1 P2] < r2);
                
                % Get a list of candidate indeces less than r, then pick
                % a random index. This helps avoid infinite loop.
                inx1 = temp_inx1(randi([1,length(temp_inx1)]));
                inx2 = temp_inx2(randi([1,length(temp_inx2)]));

                if m(inx1,inx2) == 0 
                    connection = false;
                else
                    prev_inx1 = inx1;
                    prev_inx2 = inx2;
                end   
            end
        end
    end

    m(inx1,inx2) = w;
end