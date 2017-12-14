function inx = getBetweenModIndex (Q,mod1,mod2)
A = zeros(Q,Q);

inx = sub2ind(size(A),mod2,mod1);
end

