function apple_clustering_simulation


%Init
clc;
load('cerulean_LCD at scanner - 10262010');
clusterpeaks = [45 135 225 315] / 180 * pi;




%Colors
nNeurons = 200;
nColors = 12;
phase = 0;
C(:,1) = cos(linspace(phase,phase+(2*pi),nColors+1));
C(:,2) = sin(linspace(phase,phase+(2*pi),nColors+1));
C = C(1:nColors,:);
ds.DKL(:,2:3) = C;
ds.DKL(:,2) = ds.DKL(:,2) .* 0.25;
ds.DKL(:,3) = ds.DKL(:,3) .* 1.00;
ds = cerulean_DKL2ALL(ds);




%Ideal Channels
idealchannel = sin(linspace(0,2*pi,361));
idealchannel = idealchannel(1:end-1);
idealchannel(idealchannel < 0) = 0;
idealchannel = idealchannel.^3;




%Channel space
for i=1:nNeurons
  shift = floor(rand*360)+1;
  shiftlist(i) = shift;
  val = circshift(idealchannel,[0 shift]);
  channels(i,:) = val;
end
origchannels = channels;



%Adust Gain
for i=1:nNeurons
  
  %Peak Tuning
  [~,peak] = max(channels(i,:));
  peak = peak / 180 * pi;

  %Get Shortest distance to cluster peak
  val = [];
  for j=1:numel(clusterpeaks);
    val(j) = abs(circ_dist(clusterpeaks(j),peak));
  end
  minval = min(val);
  minval = minval / pi;
  minval = 1 - min(val);
  minval = minval .^ 4;
  minval(minval < 0) = 0;
  minval = minval.*2 + 0.5;
  minval = 2.5;
  %minval = 1 +  (1 - minval).*2;
  %channels(i,:) = channels(i,:) .* minval;
  channels(i,:) = channels(i,:)+ minval;
end


% channels = channels(shiftlist>90&shiftlist<180,:);
% origchannels = origchannels(shiftlist>90&shiftlist<180,:);
% v1 = mean(channels);
% v2 = mean(origchannels);
% v1 = v1 ./ max(v1);
% v2 = v2 ./ max(v2);
% plot(v1);
% hold on;
% plot(v2,'r');
% 



subplot(2,2,[1 2]);
plot(channels','k'); hold on;
angles = linspace(0,360,nColors+1);
angles = round(angles(1:end-1)) + 1;
angles = angles + 15;
for i=1:numel(angles)
  h = scatter(angles(i),1,'filled');
  set(h,'MarkerEdgeColor',ds.RGB(i,:),'MarkerFaceColor',ds.RGB(i,:));
end
box on; grid on;
axis([1 360 0 3]);



%PCA
subplot(2,2,3); hold on;

X = channels(:,angles)';
[~,scores] = princomp(X);
for i=1:numel(angles);
  h = scatter(scores(i,1),scores(i,2),'filled');
  set(h,'MarkerEdgeColor',ds.RGB(i,:),'MarkerFaceColor',ds.RGB(i,:));
end
