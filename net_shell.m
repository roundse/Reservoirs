clear
close all
clc

% 90% chance of an internal connection.
typeConnProb = 0.9;

M = 5;
Q = 3;
T = 30;
excWght = 0.05;
betweenWght = 0.25;
n = 4;
excConnProb = .5;

% Create recurrent connecton matrix in each hierarchy and submodule.
w_exc_exc{1} = [];
w_exc_exc{1} = addModules(w_exc_exc{1},Q,M,n,n);

r = rand;

if r < typeConnProb
    connType = 'internal';
else
    connType = 'external';
end

for t = 1:T
    for m = 1:M % This will be the depth we want to get to
        if strcmp(connType,'internal')
            if m == M
                n = n+1;
                w_exc_exc{1}= addNeuronRecursive(w_exc_exc{1},M,1,n,1,excWght);
            end
%         else
%             mod1 = 0;
%             mod2 = 0;
%             while mod1 == mod2
%                 mod1 = randi([1,Q]);
%                 mod2 = randi([1,Q]);
%             end
%             betweenModWeights = addBetweenMatrix(m,mod1,mod2,excN{m}{mod1},excN{m}{mod2});
%             betweenModWeights{m}{mod1}{mod2} = addExternalConn(m,mod1,mod2,excN{m}{mod1},excN{m}{mod2},betweenWght);
        end
    end
end
% 
% for m = M:-1:1
%     for q = 1:Q
%         figure;
%         hist(w_exc_exc{m}{q})
%         title(['Weight distribution - Module ',num2str(m),' - Submodule ',num2str(q)]);
%     end
% end


