% Lab 2: Build an integrate-and-fire model neuron and observe its spiking  
%             for various levels of injected current 

clear
close all
clc


%DEFINE PARAMETERS 
inpN = 10;             % Number of input neurons to one output neuron
inpConn = .2;           % connection probability for input to output
exc_exc_Conn = .1;      % 10% connection probability for recurrent exc
inh_exc_Conn = .2;      % 20% connection probability for inh to exc

N = 100;
inhProb = .2;

% Input distribution
k_inh = 1*(rand(inpN,1)<inhProb);
k_exc = ~k_inh;
inhInds = find(k_exc~=1);
excInds = find(k_exc==1);
numExc = length(excInds);
numInh = length(inhInds);

% Hidden layer distribution
hiddenInh = 1*(rand(N,1)<inhProb);
hiddenExc = ~hiddenInh;
hidInhInds = find(hiddenExc~=1);
hidExcInds = find(hiddenExc==1);
excN = length(hidExcInds);
inhN = length(hidInhInds);

dt = 0.1;               % time step [ms] 
t_end = 3000;           % total time of run [ms] 
t_StimStart = 10;      % time to start injecting current [ms] 
t_StimEnd = 900;        % time to end injecting current [ms] 
E_L = -70;              % resting membrane potential [mV] 
V_th = -55;             % spike threshold [mV] 
V_reset = -75;          % value to reset voltage to after a spike [mV] 
V_spike = 20;           % value to draw a spike to, when cell spikes [mV] 
R_m = 10;               % membrane resistance [MOhm]. NOTE: If high, is more sensitive to injected current.
tau = 10;               % membrane time constant [ms] 
f_rate = 0.0037;         % ms^-1

T = ceil(t_end/dt);      % Number of time steps per ms.

%DEFINE INITIAL VALUES AND VECTORS TO HOLD RESULTS 
t_vect = 0:dt:t_end;                        % will hold vector of times 
V_vect = zeros(N,length(t_vect));           % initialize the voltage vector (runs faster)
V_plot_vect = zeros(N,length(t_vect));      % pretty version of V_vect to be plotted, that displays a spike 
                                            % whenever voltage reaches threshold 
                                      % index denoting which element of V is being assigned 
V_inf = zeros(N,1);
V_vect(:,1)= E_L;                             % first element of V, i.e. value of V at t=0 
V_plot_vect(:,1) = V_vect(1);                 % if no spike, then just plot the actual voltage V 

%INTEGRATE THE EQUATION tau*dV/dt = -V + E_L + I_e*R_m 
I_Stim = 1.51;                                  % magnitude of pulse of injected current [nA] 
I_e_vect = zeros(1,t_StimStart/dt);             % portion of I_e_vect from t=0 to t=t_StimStart 
I_e_vect = [I_e_vect  I_Stim*ones(1,1+ ...
    ((t_StimEnd-t_StimStart)/dt))];             % add portion from t=t_StimStart to t=t_StimEnd 
I_e_vect = [I_e_vect  zeros(1, ...
    (t_end-t_StimEnd)/dt)];                     % add portion from t=t_StimEnd to t=t_end 


g_in = zeros(inpN,1);
E_in = zeros(inpN,1);

g = zeros(N,1);
E = zeros(N,1);
E(hidInhInds) = -85;

w_in = 0.07 * (rand(N,inpN) < inpConn);
w_exc_exc = 0.000000005 * (rand(excN,excN) < exc_exc_Conn);
w_inh_exc = .0001 * (rand(inhN,excN) < inh_exc_Conn);

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
%     % Add a new neuron every 4 steps.
%     if t == t_past+200
%         t_past = t;
%         N = N+1;
%         V_inf(N,:) = 0;
%         V_vect(N,:) = E_L;
%         V_plot_vect(N,:) = 0;
%         g(N,:) = 0;
%         I_app(N,:) = 0;
%         fired(N) = 0;
%         numSpk(N) = 0;
%         
%         inpConnRand = rand;
%         if inpConnRand < inpConn
%             w_in(N,:) = 0.07;
%         else
%             w_in(N,:) = 0;
%         end
%         
%         inhOrExc = rand;
%         if inhOrExc < 0.8
%             excN = excN + 1;
%             E(N) = 0;
%             hidExcInds(end+1) = N;
%             
%             % This only needs to be done if a new exc neuron was added
%             excConnRand = rand;
%             if excConnRand < exc_exc_Conn
%                 w_exc_exc(excN,excN) = 0.000000005;
%             else
%                 w_exc_exc(excN,excN) = 0;
%             end     
%             inhConnRand = rand;
%             if inhConnRand < inh_exc_Conn
%                 w_inh_exc(:,excN) = .0001;
%             else
%                 w_inh_exc(:,excN) = 0;
%             end            
%         else
%             inhN = inhN + 1;
%             E(N) = -85;
%             hidInhInds(end+1) = N;
%             
%             % This only needs to be done if a new inh neuron was added
%             inhConnRand = rand;
%             if inhConnRand < inh_exc_Conn
%                 w_inh_exc(inhN,:) = .0001;
%             else
%                 w_inh_exc(inhN,:) = 0;
%             end            
%         end
%     end    
    if (t*dt > 200 && t*dt < 700) || (t*dt >900 && t*dt < 1400) || (t*dt > 1600 && t*dt < 2100)  % provide input current over ms = 200:700
        temp_p = rand(inpN,1)<f_rate*dt;
        p(excInds,:) = temp_p(excInds);
        p(inhInds,:) = -1*(temp_p(inhInds));
    else
        p = 0;
    end
    
    % update conductance of g_in   
    I_app = w_in * (g_in .* E_in)-(w_in * g_in) .* V_vect(:,t);
    I_app = I_app - (w_in * g_in) .* V_vect(t);
    g_in = (1-dt/tau) * g_in;
    
    % update recurrent connection conductances
    g = g + fired;
    I_inh = w_inh_exc * (g(hidExcInds,:) .* E(hidExcInds,:)) - ...
        (w_inh_exc * g(hidExcInds,:)) .* V_vect(hidInhInds,t);
    I_exc = w_exc_exc * (g(hidExcInds,:) .* E(hidExcInds,:)) - ...
        (w_exc_exc * g(hidExcInds,:)) .* V_vect(hidExcInds,t);
    
    I_app(hidInhInds) = I_app(hidInhInds) + I_inh;
    I_app(hidExcInds) = I_app(hidExcInds) + I_exc;
    g = (1-dt/tau)*g;
    
    V_inf = E_L + I_app*R_m;        
    %V_inf(inhInds) = E_L - I_app(inhInds)*R_m;
    
    % value that V_vect is exponentially decaying towards at this time step 
    % next line does the integration update rule 
    V_vect(:,t+1) = V_inf + (V_vect(:,t) - V_inf)*exp(-dt/tau);
    
    fired = V_vect(:,t+1)>=V_th;
    inds_spk = find(V_vect(:,t+1) >= V_th);
    inds_noSpk = find(V_vect(:,t+1) < V_th);
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
            V_vect(inds_spk,t+1) = V_reset;          % set voltage back to V_reset 
            V_plot_vect(inds_spk,t+1) = V_spike;     % set vector that will be plotted to show a spike here 
            numSpk(inds_spk) = numSpk(inds_spk) + 1;
            spkMat(inds_spk,t) = 1;
           
    %else   
%             % voltage didn't cross threshold so cell does not spike
%             V_plot_vect(t+1) = V_vect(t+1); % plot the actual voltage 
            V_plot_vect(inds_noSpk,t+1) = V_vect(inds_noSpk,t+1);
    %end  
   
end 

avgFR = 1000*numSpk/(t_StimEnd-t_StimStart);     % gives us average FR in Hz.

%MAKE PLOTS 
figure(1) 
plot(t_vect, V_plot_vect);   
title('Voltage vs. time'); 
xlabel('Time in ms'); 
ylabel('Voltage in mV'); 

figure;
grpID = 'Hidden Layer';
plotRaster(spkMat,grpID,hidExcInds,hidInhInds);