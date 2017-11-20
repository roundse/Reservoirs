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
R_m = 10;               % membrane resistance [MOhm] 
tau = 10;               % membrane time constant [ms] 


%DEFINE INITIAL VALUES AND VECTORS TO HOLD RESULTS 
t_vect = 0:dt:t_end;    % will hold vector of times 
V_vect = zeros(1,length(t_vect));  %initialize the voltage vector (runs faster)

i = 1;   % index denoting which element of V is being assigned 
V_vect(i)=E_L;  %first element of V, i.e. value of V at t=0 
I_StimPulse = 1;    % [nA]
%INTEGRATE THE EQUATION tau*dV/dt = -V + E_L + I_e*R_m 
I_e_vect = zeros(1,length(t_vect));  %injected current [nA] 

for t=dt:dt:t_end   %loop through values of t in steps of dt ms    
    if (t < 100 || t > 400)
        I_e_vect(i) = 0;
    else
        I_e_vect(i) = I_StimPulse;
    end
    
    V_inf = E_L + I_e_vect(i)*R_m;          
    % value that V_vect is exponentially  
    % decaying towards at this time step 
    % next line does the integration update rule 
    V_vect(i+1) = V_inf + (V_vect(i) - V_inf)*exp(-dt/tau);   
    i = i + 1;                             
    % add 1 to index, corresponding to moving forward 1 time step 4 
end 

%MAKE PLOTS 
figure(1) 
plot(t_vect, V_vect);   
title('Voltage vs. time'); 
xlabel('Time in ms'); 
ylabel('Voltage in mV'); 