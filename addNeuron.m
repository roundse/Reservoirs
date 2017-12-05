function m = addNeuron(m,n1,n2)
    m(n1,:) = 0;
    m(:,n2) = 0;
end