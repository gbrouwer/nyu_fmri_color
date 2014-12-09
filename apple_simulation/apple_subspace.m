function apple_subspace

%Init
clc;
load('cerulean_LCD at scanner - 10262010');
ds.nColors = 12;
ds.nRuns = 2;
ds.nVoxels = 50;
ds.nChannels = 6;
ds.noiselevel = 0.01;




%Create Channels
ds = apple_create_channels(ds);




%Create Weights
ds = apple_create_weights(ds);
 


%Create Colors
ds = apple_create_colors(ds);




%Create Data
ds = apple_runexperiment(ds);




nIter3 = 10;
nIter1 = 12;
nIter2 = 10;
corvals = linspace(0,0.9,nIter1);
noisevals = linspace(0,0.1,nIter2);
for m=1:nIter3
  for j=1:nIter1
    for i=1:nIter2

      %Add Correlated Noise
      corval = corvals(j);
      noiselevel = noisevals(i);
      n = ds.nVoxels; Rpp = repmat(corval, [n,n]);  Rpp(1:(n+1):n^2) = 1;
      [noise,sampRpp] = apple_noise(Rpp,ds.nColors*2);
      ds.data = ds.betas + noise'.*noiselevel;

      %Forward model + PCA
      Xtrain = ds.data(1:ds.nColors,:);
      Xtest = ds.data(ds.nColors+1:end,:);
      Ftrain = ds.forwardmodel(1:ds.nColors,:);
      Ftest = ds.forwardmodel(ds.nColors+1:end,:);
      W = inv(Ftrain' * Ftrain) * Ftrain' * Xtrain;
      C = inv(W * W') * W * Xtest';
      [~,scores] = princomp(C');
      D = squareform(pdist(scores(:,1:2)));
      D = D(ds.E);
      Pval(m,i,j,1) = corr2(D,ds.D).^2;
      last1 = scores;


      %Just PCA
      [~,scores] = princomp(Xtest);
      D = squareform(pdist(scores(:,1:2)));
      D = D(ds.E);
      Pval(m,i,j,2) = corr2(D,ds.D).^2;
      box on; grid on; hold on;
      last2 = scores;

    end
  end
end

%Average
Pval = squeeze(mean(Pval,1));


subplot(2,2,1);
imagesc(Pval(:,:,1),[0 1])  
colorbar;
subplot(2,2,2);
imagesc(Pval(:,:,2),[0 1])  
colorbar;
subplot(2,2,3);
for i=1:ds.nColors
  scatter(last1(i,1),last1(i,2),100,ds.RGB(i,:),'filled');
  box on; grid on; hold on;
end
subplot(2,2,4);
for i=1:ds.nColors
  scatter(last2(i,1),last2(i,2),100,ds.RGB(i,:),'filled');
  box on; grid on; hold on;
end