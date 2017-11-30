function [] = plotRaster(spikeMat,grpID,exc,inh)

hold all;

[r c] = size(spikeMat);

[rSpk cSpk] = find(spikeMat==1);
[rNoSpk cNoSpk] = find(spikeMat~=1);

plot(cSpk,rSpk,'k.');

title(['Raster Plot - ',grpID]);
xlabel('Time t (ms)');
ylabel('Neuron number');
ylim([0 size(spikeMat, 1)+1]);
xlim([0 c]);

end