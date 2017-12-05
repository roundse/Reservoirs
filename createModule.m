function [matrix,numNeurons] = createModule(M, Q, n1, n2, w, p)

for m = M:-1:1
    for q = 1:Q
        matrix{m}{q}
        if m == 1
            matrix{m}{q} = w * (rand(n1,n2) < p);
            numNeurons{m}{q} = n1; 
        end
    end
end

end