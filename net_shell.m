clear
close all
clc

M = 4;
Q = 3;
T = 1;
typeConnProb = 0.9;

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
    % type selection needs to be inside fxns
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
[w_exc_exc{1}, nCount] = getTotalNeuronCount(w_exc_exc{1},M,initial);
disp(['Total neurons: ',num2str(nCount)]);
initial = 0;
[between_matrix{1}, betweenDegree] = getTotalBetweenModConnCount(between_matrix{1},M,initial);
disp(['Total between-mod. edges: ',num2str(betweenDegree)]);


