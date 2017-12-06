function m = addModules(m,Q,depth)
depth
while depth > 1
    if iscell(m)
        for i = 1:length(m)
            if iscell(m{i})
                m{i} = addModules(m{i},Q,depth);
%             else
%                 temp{i}{Q} = [];
%                 m{i} = temp;
            end
        end
    else
        error('Input matrix is not a cell.');
    end
    depth = depth - 1
end

end