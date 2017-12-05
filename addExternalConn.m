function matrix = addExternalConn(matrix, m, mod1, mod2, N1, N2, w)
    n1 = randi([1,N1]);
    n2 = randi([1,N2]);
    
    matrix{m}{mod1}{mod2}(n1,n2) = w;
end