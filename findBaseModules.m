function [totalDegreePre,totalDegreePost] = findBaseModules(orig_m,m,Q,orig_d,d,subOrder,order,totalDegreePre,totalDegreePost)

d = d-1;

if d >= 1
    for h = 1:Q
        index = getBetweenModIndex(Q,h,h);
        subOrder(d) = h;
        order(d) = index;
        [totalDegreePre,totalDegreePost] = findBaseModules(orig_m,m{index},Q,orig_d,d,subOrder,order,totalDegreePre,totalDegreePost);
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
   
    % run through pre and post
    
    path = [];
    for n = 1:s
        [orig_m, temp_c_pre] = getNeuronTotDegreePre(orig_m,subOrder,n,Q,orig_d,c_pre(n),path);
        c_pre(n) = c_pre(n) + temp_c_pre;
        
        [orig_m, temp_c_post] = getNeuronTotDegreePost(orig_m,subOrder,n,Q,orig_d,c_post(n));
        c_post(n) = c_post(n) + temp_c_post;        
    end

    totalDegreePre = horzcat(totalDegreePre,c_pre);
    totalDegreePost = horzcat(totalDegreePost,c_post);
end

end