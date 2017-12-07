function inx = getBetweenModIndex (mod1,mod2)
inx = 0;

for i = 1:mod1
    for j = 1:mod2
        inx = inx + 1;
    end
end

end

