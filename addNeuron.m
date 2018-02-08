function m = addNeuron(orig_m,m,Q,orig_d,v,w,order)
    disp('Adding a new neuron for an internal connection.');
    curr_sz = length(m);
    
    m(curr_sz+1,:) = 0;
    m(:,curr_sz+1) = 0;
    new_sz = length(m);
    
    % Connect the newly created neuron to v existing vertices.
    for i = 1:v
        c_pre = zeros(1,curr_sz);
        c_post = zeros(1,curr_sz);   
        
        path = [];
        for n = 1:curr_sz
           [orig_m, temp_c_pre] = getNeuronTotDegreePre(orig_m,order,n,Q,orig_d,c_pre(n),path);
           c_pre(n) = c_pre(n) + temp_c_pre;

           [orig_m, temp_c_post] = getNeuronTotDegreePost(orig_m,order,n,Q,orig_d,c_post(n),path);
           c_post(n) = c_post(n) + temp_c_post;       
        end
        
        tot_c = c_pre + c_post;
        
        connection = true;
        inx = 0;
        
        D = tot_c;
        totalD = sum(tot_c);

        % Get probability
        P = cumsum(D ./ totalD);

%         % This doesn't allow self-connections.
%         while (l == inx || connection == true)
%             r1 = rand;
%             inx = find([-1 P] < r1, 1, 'last');
%             if ( m(l,inx) == 0 && m(inx,l) == 0 )
%                 connection = false;
%             end
%         end

        % This DOES allow self-connections.
        while (connection == true)
            r1 = rand;
            inx = find([-1 P] < r1, 1, 'last');
            if ( m(new_sz,inx) == 0 && m(inx,new_sz) == 0 )
                connection = false;
            end
        end
        
        m(new_sz,inx) = w;
        m(inx,new_sz) = w; 
    end
end