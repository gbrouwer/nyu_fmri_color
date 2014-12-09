function apple_slowfeaturespace

%Init
clc;
ds.nColors = 32;
ds.nRuns = 1;
ds.nVoxels = 100;
ds.nChannels = 6;




%Create Channels
ds = apple_create_channels(ds);




%Create Weights
ds = apple_create_weights(ds);
 



%Create Data
ds = apple_runexperiment(ds);


imagesc(ds.betas);



y = sfa2(ds.betas); 
plot(y);
[pc,scores] = princomp(y);
%plot(scores(:,1:10));