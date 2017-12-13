clear
close all
clc

% 90% chance of an internal connection.
typeConnProb = 0.9;

M = 2;
Q = 3;
T = 30;
excWght = 0.05;
betweenWght = 0.25;
n = 2;
excConnProb = .5;

% Create recurrent connecton matrix in each hierarchy and submodule.
w_exc_exc{1} = [];
w_exc_exc{1} = addModules(w_exc_exc{1},Q,M,n,excWght);
between_matrix{1} = [];
between_matrix{1} = initBetweenWeights(between_matrix{1},Q^2,M,n);
order = zeros(1,M-1);


desiredDepth = 1;
for t = 1:T
    r = rand;

    if r < typeConnProb
        connType = 'internal';
    else
        connType = 'external';
    end    
    
    if strcmp(connType,'internal')
        disp('Adding a new internal connection.');
        [w_exc_exc{1} order] = addNeuronRecursive(w_exc_exc{1},Q,M,1,excWght,order);
        [w_exc_exc{1} s] = getModuleSize(w_exc_exc{1},order,M);
        between_matrix{1} = updateBetweenWeightSize(between_matrix{1},Q,s,order,M);
    else
        disp('Adding a between-module connection.');
        between_matrix{1} = addExternalConnRecursive(between_matrix{1},Q,M,betweenWght);
    end
end


disp('counting neurons');
initial = 0;
[w_exc_exc{1} count] = getTotalNeuronCount(w_exc_exc{1},M,initial);
disp(['Total neurons: ',num2str(count)]);

% 
% for m = M:-1:1
%     for q = 1:Q
%         figure;
%         hist(w_exc_exc{m}{q})
%         title(['Weight distribution - Module ',num2str(m),' - Submodule ',num2str(q)]);
%     end
% end


