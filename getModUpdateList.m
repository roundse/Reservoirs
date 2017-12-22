function [pre post] = getModUpdateList(module,Q,order,top,previous)

% Return a list of the submodules that reference a separate module, and
% tell whether they correspond to the pre or post.
inx = 0;
pre = zeros(1,Q^2);
post = zeros(1,Q^2);

A = zeros(Q,Q);
% Get the subscripts of the top-most connection index.
[post_top, pre_top] = ind2sub(size(A),top);

% Pre and post should be the same, but we need the subscript of the
% top-most module to which a neuron was added.
[post_add, pre_add] = ind2sub(size(A),order(end));

if pre_top == pre_add
    presynaptic = true;
   % disp('this connection is presynaptic');
elseif post_top == pre_add
    presynaptic = false;
   % disp('this connection is postsynaptic');
else
    disp('something is wrong');
end


for i = 1:Q
    for j = 1:Q
        inx = inx + 1;
        if presynaptic == true
            if i == module
                pre(inx) = 1;
            end
        else
            if j == module
                post(inx) = 1;
            end
        end
    end
end

end

