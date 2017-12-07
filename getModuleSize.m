function [m s] = getModuleSize(m,order,d,desired_d)
    d = d-1;
    % Check to see if we've reached the bottom of the tree.
    % If we haven't, keep going; otherwise, get the length of the matrix.
    if (d >= desired_d)        
        [m{order(d)} s] = getModuleSize(m{order(d)},order,d,desired_d);
    else
        s = length(m);
    end
end