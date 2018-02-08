function m = addExternalConn(orig_m,m,Q,orig_d,w,order1,order2)
    disp('Adding a new connection between modules.');
    
    temp = m;
    
    [s2,s1] = size(m);
    
    %for i = 1:2
    connection = true;
    
    prev_inx1 = 0;
    prev_inx2 = 0;
    inx1 = nan;
    inx2 = nan;

    c_pre_1 = zeros(1,s1);
    c_post_1 = zeros(1,s1);

    c_pre_2 = zeros(1,s2);
    c_post_2 = zeros(1,s2);
    
    path = [];
    
    for n = 1:s1
       [orig_m, temp_c_pre] = getNeuronTotDegreePre(orig_m,order1,n,Q,orig_d,c_pre_1(n),path);
       c_pre_1(n) = c_pre_1(n) + temp_c_pre;

       [orig_m, temp_c_post] = getNeuronTotDegreePost(orig_m,order1,n,Q,orig_d,c_post_1(n),path);
       c_post_1(n) = c_post_1(n) + temp_c_post;       
    end

    tot_1 = c_pre_1 + c_post_1;

    for n = 1:s2
       [orig_m, temp_c_pre] = getNeuronTotDegreePre(orig_m,order2,n,Q,orig_d,c_pre_2(n),path);
       c_pre_2(n) = c_pre_2(n) + temp_c_pre;

       [orig_m, temp_c_post] = getNeuronTotDegreePost(orig_m,order2,n,Q,orig_d,c_post_2(n),path);
       c_post_2(n) = c_post_2(n) + temp_c_post;       
    end
    
    tot_2 = c_pre_2 + c_post_2;
    
    D1 = tot_1;
    D2 = tot_2;
    totalD1 = sum(D1);
    totalD2 = sum(D2);
        
    % If no connections exist or the degree is 1, then randomly choose two
    % neurons.
    % Otherwise, grow using PA rule.
%     if totalD1 == 0 || totalD2 == 0 || totalD1 == 1 || totalD2 == 1
%         inx1 = randi([1, size(temp,1)]);
%         inx2 = randi([1, size(temp,2)]);
%     else


        % Get probability
        P1 = cumsum(D1 ./ totalD1);
        P2 = cumsum(D2 ./ totalD2);

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
                if connection == true
                    inf_count = inf_count + 1;
                    
                    if inf_count == 6
                        disp('gone infinite, exiting');
                        return;
                    end
                end
                r1 = rand;
                temp_inx1 = find([-1 P1] < r1, 1, 'last');
                r2 = rand;
                temp_inx2 = find([-1 P2] < r2, 1, 'last');
                
                % Get a list of candidate indeces less than r, then pick
                % a random index. This helps avoid infinite loop.
%                 inx1 = temp_inx1(randi([1,length(temp_inx1)]));
%                 inx2 = temp_inx2(randi([1,length(temp_inx2)]));

                if m(temp_inx2,temp_inx1) == 0 
                    connection = false;
                    inx1 = temp_inx1;
                    inx2 = temp_inx2;
                else
                    prev_inx1 = temp_inx1;
                    prev_inx2 = temp_inx2;
                end   
            end
        end
%     end

    m(inx2,inx1) = w;
    %end
end