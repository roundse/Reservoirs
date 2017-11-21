% Lab 2: Build an integrate-and-fire model neuron and observe its spiking  
%             for various levels of injected current 

clear
close all
clc

%DEFINE PARAMETERS 
dt = 0.1;               % time step [ms] 
t_end = 500;            % total time of run [ms] 
t_StimStart = 100;      % time to start injecting current [ms] 
t_StimEnd = 400;        % time to end injecting current [ms] 
E_L = -70;              % resting membrane potential [mV] 
V_th = -55;             % spike threshold [mV] 
V_reset = -75;          % value to reset voltage to after a spike [mV] 
V_spike = 20;           % value to draw a spike to, when cell spikes [mV] 
R_m = 10;               % membrane resistance [MOhm]. NOTE: If high, is more sensitive to injected current.
tau = 10;               % membrane time constant [ms] 


%DEFINE INITIAL VALUES AND VECTORS TO HOLD RESULTS 
t_vect = 0:dt:t_end;                        % will hold vector of times 
V_vect = zeros(1,length(t_vect));           % initialize the voltage vector (runs faster)
V_plot_vect = zeros(1,length(t_vect));      % pretty version of V_vect to be plotted, that displays a spike 
                                            % whenever voltage reaches threshold 
i = 1;                                      % index denoting which element of V is being assigned 
V_vect(i)= E_L;                             % first element of V, i.e. value of V at t=0 
V_plot_vect(i) = V_vect(i);                 % if no spike, then just plot the actual voltage V 

%INTEGRATE THE EQUATION tau*dV/dt = -V + E_L + I_e*R_m 
I_Stim = 1.51;                                  % magnitude of pulse of injected current [nA] 
I_e_vect = zeros(1,t_StimStart/dt);             % portion of I_e_vect from t=0 to t=t_StimStart 
I_e_vect = [I_e_vect  I_Stim*ones(1,1+ ...
    ((t_StimEnd-t_StimStart)/dt))];             % add portion from t=t_StimStart to t=t_StimEnd 
I_e_vect = [I_e_vect  zeros(1, ...
    (t_end-t_StimEnd)/dt)];                     % add portion from t=t_StimEnd to t=t_end 


% To compute avg firing rate, want # spikes/ sec.
% Interspike interval: time between ith and i+1th spike (is). Corresp. FR
% is 1/tisi.

numSpk = 0;      % hold number of spikes that have occurred for this neuron.
for t=dt:dt:t_end   %loop through values of t in steps of dt ms   
    
    V_inf = E_L + I_e_vect(i)*R_m;          
    % value that V_vect is exponentially decaying towards at this time step 
    % next line does the integration update rule 
    V_vect(i+1) = V_inf + (V_vect(i) - V_inf)*exp(-dt/tau);
    
    if (V_vect(i+1) > V_th)                 % cell spiked 
            V_vect(i+1) = V_reset;          % set voltage back to V_reset 
            V_plot_vect(i+1) = V_spike;     % set vector that will be plotted to show a spike here 
            numSpk = numSpk + 1;
    else   
            % voltage didn't cross threshold so cell does not spike
            V_plot_vect(i+1) = V_vect(i+1); % plot the actual voltage 
    end  
    
    i = i + 1;  % add 1 to index, corresponding to moving forward 1 time step 4 
end 

avgFR = 1000*numSpk/(t_StimEnd-t_StimStart)     % gives us average FR in Hz.

%MAKE PLOTS 
figure(1) 
plot(t_vect, V_plot_vect);   
title('Voltage vs. time'); 
xlabel('Time in ms'); 
ylabel('Voltage in mV'); 