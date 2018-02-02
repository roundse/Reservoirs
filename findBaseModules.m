function [totalDegreePre,totalDegreePost,c_k,nNeigh,order] = ...
    findBaseModules(orig_m,m,Q,orig_d,d,subOrder,order,totalDegreePre,totalDegreePost,c_k,nNeigh)

d = d-1;

if d >= 1
    for h = 1:Q
        index = getBetweenModIndex(Q,h,h);
        subOrder(d) = h;
        order(d) = index;
        [totalDegreePre,totalDegreePost,c_k,nNeigh,order] = findBaseModules(orig_m,m{index}, ...
            Q,orig_d,d,subOrder,order,totalDegreePre,totalDegreePost,c_k,nNeigh);
    end
else
    s = length(m);
%     disp(['this submodule contains ',num2str(s),' neurons']);
%     disp('this submodule is on path: ');
%     for i = length(order):-1:1
%         disp(num2str(order(i))');
%     end
%     disp(['max depth is ',num2str(orig_d)]);
%     disp(['current depth is ',num2str(d)]);
    
    % initialize vector with size of module
    c_pre = zeros(1,s);
    c_post = zeros(1,s);
    
    % initialize cluster coeff calc variables
    numNeighbors = zeros(1,s);
    connectedNeighbors = zeros(1,s);
    clusterCoeff = zeros(1,s);
    
    path = [];
    for n = 1:s
       new_path = [];
       [orig_m, temp_c_pre] = getNeuronTotDegreePre(orig_m,subOrder,n,Q,orig_d,c_pre(n),path);
       c_pre(n) = c_pre(n) + temp_c_pre;
        
       [orig_m, temp_c_post] = getNeuronTotDegreePost(orig_m,subOrder,n,Q,orig_d,c_post(n),path);
       c_post(n) = c_post(n) + temp_c_post;       
        
       [orig_m, p, new_path] = getPathConnected(orig_m,subOrder,n,Q,orig_d,path,new_path);
        
       numNeighbors(n) = size(new_path,1);
        
       if numNeighbors(n) >= 2
           c = zeros(numNeighbors(n),numNeighbors(n));
           for i = 1:numNeighbors(n)
                p1 = new_path(i,:);
                for j = 1:numNeighbors(n)
                    if i ~= j
                        p2 = new_path(j,:);
                        [orig_m, c(i,j)] = countNeighborConns(orig_m,Q,orig_d,p1,p2,0,[],j);
                    end
                end
           end
                    
           connectedNeighbors(n) = sum(sum(c));          
           clusterCoeff(n) = (connectedNeighbors(n))/(numNeighbors(n)*(numNeighbors(n)-1));
       else
           clusterCoeff(n) = 0; 
       end
    end
    
    totalDegreePre = horzcat(totalDegreePre,c_pre);
    totalDegreePost = horzcat(totalDegreePost,c_post);
    c_k = horzcat(c_k,clusterCoeff);
    nNeigh = horzcat(nNeigh,numNeighbors);
end

end