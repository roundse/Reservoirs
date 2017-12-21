function [pre post] = getModUpdateList(module,Q,order,index)

% Return a list of the submodules that reference a separate module, and
% tell whether they correspond to the pre or post.
inx = 0;
pre = zeros(1,Q^2);
post = zeros(1,Q^2);

A = zeros(Q,Q);
[post_last pre_last] = ind2sub(size(A),index);
temp1 = [pre_last,post_last];
[post_m pre_m] = ind2sub(size(A),order(end));
temp2 = [pre_m,post_m];


for i = 1:Q
    for j = 1:Q
       inx = inx + 1;
       if any(intersect(temp1,temp2))
           if temp1(1) == temp2(1)
                if i == module
                    pre(inx) = 1;
                end
                post(inx) = 0;
           else
               if j == module
                   post(inx) = 1;
               end
               pre(inx) = 0;
           end
       end
    end
end

end

