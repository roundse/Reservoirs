clear
close all
clc


w = rand(10,10);
[spk v] = simLIFNet(w,'simTime',1000);