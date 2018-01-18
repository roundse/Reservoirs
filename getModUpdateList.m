function [pre post] = getModUpdateList(mod,Q)

% Return a list of the submodules that reference a separate module, and
% tell whether they correspond to the pre or post.
inx = 0;
pre = zeros(1,Q^2);
post = zeros(1,Q^2);

for i = 1:Q
    for j = 1:Q
        inx = inx + 1;
        if i ~= j
            if i == mod
                pre(inx) = 1;
            elseif j == mod
                post(inx) = 1;
            end
        end
    end
end

end

