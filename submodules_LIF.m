% Lab 2: Build an integrate-and-fire model neuron and observe its spiking  
%             for various levels of injected current 

clear
close all
clc


%DEFINE PARAMETERS 
inpN = 10;             % Number of input neurons to one output neuron
inpConn = .9;           % connection probability for input to output
exc_exc_Conn = .9;      % 10% connection probability for recurrent exc
inh_exc_Conn = .9;      % 20% connection probability for inh to exc

N(1) = 1;
inhProb = .2;

% Input distribution
k_inh = 1*(rand(inpN,1)<inhProb);
k_exc = ~k_inh;
inhInds = find(k_exc~=1);
excInds = find(k_exc==1);
numExc = length(excInds);
numInh = length(inhInds);

% Hidden layer distribution
hiddenInh{1} = 1*(rand(N,1)<inhProb);
hiddenExc{1} = ~hiddenInh{1};
hidInhInds{1} = find(hiddenExc{1}~=1);
hidExcInds{1} = find(hiddenExc{1}==1);
excN(1) = length(hidExcInds{1});
inhN(1) = length(hidInhInds{1});

dt = 0.1;               % time step [ms] 
t_end = 600;           % total time of run [ms] 
t_StimStart = 1;      % time to start injecting current [ms] 
t_StimEnd = 600;        % time to end injecting current [ms] 
E_L = -70;              % resting membrane potential [mV] 
V_th = -55;             % spike threshold [mV] 
V_reset = -75;          % value to reset voltage to after a spike [mV] 
V_spike = 20;           % value to draw a spike to, when cell spikes [mV] 
R_m = 10;               % membrane resistance [MOhm]. NOTE: If high, is more sensitive to injected current.
tau = 10;               % membrane time constant [ms] 
f_rate = 0.003;         % ms^-1

T = ceil(t_end/dt);      % Number of time steps per ms.

%DEFINE INITIAL VALUES AND VECTORS TO HOLD RESULTS 
t_vect = 0:dt:t_end;                        % will hold vector of times 
V_vect{1} = zeros(N,length(t_vect));           % initialize the voltage vector (runs faster)
V_plot_vect{1} = zeros(N,length(t_vect));      % pretty version of V_vect to be plotted, that displays a spike 
                                            % whenever voltage reaches threshold 
                                      % index denoting which element of V is being assigned 
V_inf{1} = zeros(N,1);
V_vect{1}(:,1)= E_L;                             % first element of V, i.e. value of V at t=0 
V_plot_vect{1}(:,1) = V_vect{1}(1);                 % if no spike, then just plot the actual voltage V 

%INTEGRATE THE EQUATION tau*dV/dt = -V + E_L + I_e*R_m 
I_Stim = 1.51;                                  % magnitude of pulse of injected current [nA] 
I_e_vect = zeros(1,t_StimStart/dt);             % portion of I_e_vect from t=0 to t=t_StimStart 
I_e_vect = [I_e_vect  I_Stim*ones(1,1+ ...
    ((t_StimEnd-t_StimStart)/dt))];             % add portion from t=t_StimStart to t=t_StimEnd 
I_e_vect = [I_e_vect  zeros(1, ...
    (t_end-t_StimEnd)/dt)];                     % add portion from t=t_StimEnd to t=t_end 


g_in = zeros(inpN,1);
E_in = zeros(inpN,1);

g{1} = zeros(N,1);
E{1} = zeros(N,1);
E{1}(hidInhInds{1}) = -85;

w_in = 0.07 * (rand(N,inpN) < inpConn);
w_exc_exc{1} = 0.000000005 * (rand(excN,excN) < exc_exc_Conn);
w_inh_exc{1} = .0001 * (rand(inhN,excN) < inh_exc_Conn);

% SYNAPTIC INPUT MODEL
% I_syn = sum(w_in*g_in(t)*(E_in-v(t))
% g_in = g_in/tau
% To compute avg firing rate, want # spikes/ sec.
% Interspike interval: time between ith and i+1th spike (is). Corresp. FR
% is 1/tisi.

numSpk = zeros(N,1);        % hold number of spikes that have occurred for this neuron.
spkMat = zeros(N,length(t_vect));   % hold spikes per neuron over time to make a raster plot
fired = 0;
t_past = 0;
for t=1:T-1   %loop through values of t in steps of dt ms 
    % Add a new neuron every 4 steps.
    if t == t_past+200
        t_past = t;
        N(1) = N(1)+1;
        V_inf{1}(N(1),:) = 0;
        V_vect{1}(N(1),:) = E_L;
        V_plot_vect{1}(N(1),:) = 0;
        g{1}(N(1),:) = 0;
        I_app(N(1),:) = 0;
        fired(N(1),:) = 0;
        numSpk(N(1)) = 0;

        w_in(N(1),:) = 0.07 * (rand(1,inpN) < inpConn);
        
        inhOrExc = rand;
        if inhOrExc < 0.8
            excN = excN + 1;
            E{1}(N,:) = 0;
            hidExcInds{1}(end+1) = N;
            
            % This only needs to be done if a new exc neuron was added
            w_exc_exc{1}(excN,excN) = 0.000000005 * (rand(1,1) < exc_exc_Conn);
            w_inh_exc{1}(:,excN) = 0.0001 * (rand(inhN,1) < inh_exc_Conn);       
        else
            inhN = inhN + 1;
            E{1}(N,:) = -85;
            hidInhInds{1}(end+1) = N;
            
            % This only needs to be done if a new inh neuron was added
            w_inh_exc{1}(inhN,:) = .0001 * (rand(1,excN) < inh_exc_Conn);           
        end
    end    
    if (t*dt > 200 && t*dt < 700) || (t*dt >900 && t*dt < 1400) || (t*dt > 1600 && t*dt < 2100)  % provide input current over ms = 200:700
        temp_p = rand(inpN,1)<f_rate*dt;
        p(excInds,:) = temp_p(excInds);
        p(inhInds,:) = -1*(temp_p(inhInds));
    else
        p = 0;
    end
    
    % update conductance of g_in   
    I_app = w_in * (g_in .* E_in)-(w_in * g_in) .* V_vect{1}(:,t);
    I_app = I_app - (w_in * g_in) .* V_vect{1}(t);
    g_in = (1-dt/tau) * g_in;
    
    % update recurrent connection conductances
    g{1} = g{1} + fired;
    
    if any(w_inh_exc{1} > 0)
        I_inh = w_inh_exc{1} * (g{1}(hidExcInds{1},:) .* E{1}(hidExcInds{1},:)) - ...
            (w_inh_exc{1} * g{1}(hidExcInds{1},:)) .* V_vect{1}(hidInhInds{1},t);
        I_app(hidInhInds{1},:) = I_app(hidInhInds{1},:) + I_inh;
    end
    if any(w_exc_exc{1} > 0)
        I_exc = w_exc_exc{1}(:,:) * (g{1}(hidExcInds{1},:) .* E{1}(hidExcInds{1},:)) - ...
            (w_exc_exc{1}(:,:) * g{1}(hidExcInds{1},:)) .* V_vect{1}(hidExcInds{1},t);
        I_app(hidExcInds{1},:) = I_app(hidExcInds{1},:) + I_exc;
    end
    
    g{1} = (1-dt/tau)*g{1};
    
    V_inf{1} = E_L + I_app*R_m;        
    %V_inf(inhInds) = E_L - I_app(inhInds)*R_m;
    
    % value that V_vect is exponentially decaying towards at this time step 
    % next line does the integration update rule 
    V_vect{1}(:,t+1) = V_inf{1} + (V_vect{1}(:,t) - V_inf{1})*exp(-dt/tau);
    
    fired = V_vect{1}(:,t+1)>=V_th;
    inds_spk = find(V_vect{1}(:,t+1) >= V_th);
    inds_noSpk = find(V_vect{1}(:,t+1) < V_th);
    g_in = g_in + p;
%     if N > 50
%         disp('updated neuron total');
%         pause
%     end     
%     if any(V_vect(:,t+1)>V_th)
%         disp('at least one cell spiked');
%         pause
%     end

    %if (V_vect(:,t+1) > V_th)                 % cell spiked 
            V_vect{1}(inds_spk,t+1) = V_reset;          % set voltage back to V_reset 
            V_plot_vect{1}(inds_spk,t+1) = V_spike;     % set vector that will be plotted to show a spike here 
            numSpk(inds_spk) = numSpk(inds_spk) + 1;
            spkMat(inds_spk,t) = 1;
           
    %else   
%             % voltage didn't cross threshold so cell does not spike
%             V_plot_vect(t+1) = V_vect(t+1); % plot the actual voltage 
            V_plot_vect{1}(inds_noSpk,t+1) = V_vect{1}(inds_noSpk,t+1);
    %end  
   
end 

avgFR = 1000*numSpk/(t_StimEnd-t_StimStart);     % gives us average FR in Hz.

%MAKE PLOTS 
figure(1) 
plot(t_vect, V_plot_vect{1});   
title('Voltage vs. time'); 
xlabel('Time in ms'); 
ylabel('Voltage in mV'); 

figure;
grpID = 'Hidden Layer';
plotRaster(spkMat,grpID,hidExcInds,hidInhInds);