clear
close all
clc

M = 4;
Q = 3;
T = 30;
typeConnProb = zeros(1,M);

disp('Setting connection probabilities for each level.');
% 100pct chance of an internal connection at the very top.
typeConnProb(M) = 1.0;
for i = (M-1):-1:1
    typeConnProb(i) = typeConnProb(i+1)-.1;
end

excWght = 0.05;
betweenWght = 0.25;
excConnProb = .5;
n = 2;

disp('Initializing weights.');
% Create recurrent connecton matrix in each hierarchy and submodule.
between_matrix{1} = [];
between_matrix{1} = initWeights(between_matrix{1},Q^2,M,n);
between_matrix{1} = setInternalConnections(between_matrix{1},Q,M,excWght);

disp('Running network.');
order = 0;
for t = 1:T
    r = rand;
    if r <= typeConnProb(M-1)
        orig_internal = true;
    else
        orig_internal = false;
    end
    % type selection needs to be inside fxns
    [between_matrix{1}, order, internal] = addConnRecursive(between_matrix{1},Q,M,M,excWght,betweenWght,1,typeConnProb,orig_internal,order);
    if internal == true
        %disp('New neuron added; update participating between-module weights.');
        [between_matrix{1}, s] = getModuleSize(between_matrix{1},order,M);
        between_matrix{1} = updateBetweenWeightSize(between_matrix{1},Q,s,order,M);
    end
end
if  ( (any(any(between_matrix{1}{1}{1}{1} == betweenWght))) || (any(any(between_matrix{1}{5}{5}{5} == betweenWght))) || (any(any(between_matrix{1}{9}{9}{9} == betweenWght))) )
    disp('BAD! BAD!');
end

disp('counting neurons');
initial = 0;
[between_matrix{1}, nCount] = getNeuronCount(between_matrix{1},Q,M,initial);
disp(['Total neurons: ',num2str(nCount)]);
initial = 0;
[between_matrix{1}, betweenDegree] = getTotalBetweenModConnCount(between_matrix{1},Q,M,M,initial);
disp(['Total between-mod. edges: ',num2str(betweenDegree)]);


