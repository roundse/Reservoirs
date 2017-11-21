clear
close all
clc


% DEFINE SIMULATION PARAMETERS
dt = 1;               % time step [ms] 
t_end = 500;            % total time of run [ms] 
t_StimStart = 100;      % time to start injecting current [ms] 
t_StimEnd = 105;        % time to end injecting current [ms] 
numNodes = 1;
numN = 10;
patternElements = 6;
inputPattern = zeros(1,patternElements);
recurrent_weights = zeros(numN,numN);

CONN_PROB = .5;         % Connectivity probability is .5.

% QUESTION: What is the nature of input to the reservoir? For now, I guess
% just code a 1s and 0s pattern with dimensionality of numN.
for i = 1:patternElements
    r = rand;
    inputPattern(i) = 8*r;
end

for i = 1:numN
    for j = 1:numN
        r1 = rand;
        if r1 > 0.5
            r2 = rand;
            recurrent_weights(i,j) = r2;
        end
    end
end

i = 1;
numSpk = zeros(1,10);
for t = dt:dt:t_end
    if (t >= t_StimStart && t <= t_StimEnd)
        I_e_vect = inputPattern(i);
    else
        I_e_vect = 0;
    end
    
    
    for j = 1:numN
        for k = 1:numN
            Inp(k) = I_e_vect*recurrent_weights(j,k);
        end
        totalInput(j) = sum(Inp);
        spk = modelLIF(totalInput);
        if spk == 1
           numSpk(j) = numSpk(j) + 1;
        end
    end
    i = i+1;  
end
    


