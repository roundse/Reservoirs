clear
close all
clc

M = 4;
Q = 3;
T = 1;
typeConnProb = zeros(1,M);

disp('Setting connection probabilities for each level.');

% % % ***** 100pct chance of an internal connection at the very top.
% typeConnProb(M) = 1.0;
% for i = (M-1):-1:1
%     typeConnProb(i) = typeConnProb(i+1)-.1;
% end

typeConnProb(1) = 0.7;
typeConnProb(2) = 0.8;
typeConnProb(3) = 0.9;
%typeConnProb(4) = 0.995;

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
    % type selection needs to be inside fxns
    [between_matrix{1}, order, path1, path2, internal] = addConnRecursive(between_matrix{1}, ...
        between_matrix{1},Q,M,M,excWght,betweenWght,n,typeConnProb,[],order,[],[]);
    if internal == true
        %disp('New neuron added; update participating between-module weights.');
        [between_matrix{1}, s] = getModuleSize(between_matrix{1},order,M);
        between_matrix{1} = updateInternalWeightSize(between_matrix{1},Q,s,order,M);
        between_matrix{1} = updateBetweenPreSyn(between_matrix{1},Q,s,order,M,M,0,0);
        between_matrix{1} = updateBetweenPostSyn(between_matrix{1},Q,s,order,M,M,0,0);
    end
    
    [between_matrix{1}, this_count] = getNeuronCountBelowDesiredD(between_matrix{1},Q,M,2,1,0);
    this_count
end

% path = [];
% subscripts = [];
% totalDegPre = [];
% totalDegPost = [];
% c_k = [];
% numNeighbors = [];
% [totalDegPre,totalDegPost,c_k,numNeighbors] = findBaseModules(between_matrix{1}, ...
%     between_matrix{1},Q,M,M,subscripts,path,totalDegPre,totalDegPost,c_k,numNeighbors);
% 
% totalDegree = totalDegPre+totalDegPost;
% 
disp('counting neurons');
initial = 0;
[between_matrix{1}, nCount] = getNeuronCount(between_matrix{1},Q,M,initial);
disp(['Total neurons: ',num2str(nCount)]);
% % initial = 0;
% % [between_matrix{1}, betweenDegree] = getTotalBetweenModConnCount(between_matrix{1},Q,M,M,initial);
% % disp(['Total between-mod. edges: ',num2str(betweenDegree)]);
% 
% % figure;
% numN = 1:nCount;
% deg = sort(totalDegree,'descend');
% % plot(deg,numN);
% % title('Degree distribution');
% % ylabel('Neuron #');
% % xlabel('Degree');
% 
% % figure;
% % hist(totalDegree);
% % xlim([0 max(totalDegree)]);
% % title(['Degree distribution - M = ',num2str(M),', n = ',num2str(Q),', T = ',num2str(T)]);
% % ylabel('Neuron #');
% % xlabel('Degree');
% % 
% % set(gca,'fontsize',15);
% 
% % figure;
% pd = 0;
% y_vec = 1:max(totalDegree);
% for i = 1:max(totalDegree)
%     pd = pd + 1;
%     v = find(totalDegree == i);
%     sz = length(v);
%     perx(pd) = (sz/length(totalDegree));
% end
% % loglog(perx,'o');
% % title(['Degree distribution - M = ',num2str(M),', n = ',num2str(Q),', T = ',num2str(T)]);
% % xlabel('k');
% % ylabel('P(k)');
% 
% 
% % set(gca,'fontsize',15);
% % 
% % figure;
% for k = 1:max(totalDegree)
%     [v i] = find(totalDegree==k);
%     cOfK(k) = mean(c_k(i));
% end
% 
% % loglog(sort(cOfK,'descend'),'o');
% % xlim([10^0 10^2]);
% % ylim([10^-2 10^0]);
% % xlabel('k');
% % ylabel('C(k)');
% % title(['Cluster Coeff - M = ',num2str(M),', n = ',num2str(Q),', T = ',num2str(T)]);
% % 
% % set(gca,'fontsize',15);
% 
% 
% figure;
% [slope_dist intercept_dist] = logfit(y_vec,perx,'loglog')
% ylim([10^-4 10^0]);
% xlim([10^0 10^2]);
% title(['Degree distribution - M = ',num2str(M),', n = ',num2str(Q),', T = ',num2str(T)]);
% xlabel('k');
% ylabel('P(k)');
% set(gca,'fontsize',15);
% annotation('textbox','String',['Slope: ',num2str(abs(round(slope_dist,1)))],'fontsize',15,'fontweight','bold');
% 
% figure;
% [slope_ck intercept_ck] = logfit(y_vec,cOfK,'loglog')
% xlim([10^0 10^2]);
% ylim([10^-2 10^0]);
% xlabel('k');
% ylabel('C(k)');
% title(['Cluster Coeff - M = ',num2str(M),', n = ',num2str(Q),', T = ',num2str(T)]);
% set(gca,'fontsize',15);
% annotation('textbox','String',['Slope: ',num2str(abs(round(slope_ck,1)))],'fontsize',15,'fontweight','bold');





