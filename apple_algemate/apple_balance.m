function apple_balance(subject)


%Init
clc;
nPerm = 1000;


%Gather data
count = 0;
for i=50:10:100
  count = count + 1;
  loadname = ['apple_statistics/apple_balance_' subject '_' num2str(i) '.mat'];
  load(loadname);
  snr(count,:,:) = squeeze(mean(st.snr,1));
  loadname = ['apple_statistics/apple_measures_' subject '_' num2str(i) '.mat'];
  load(loadname);

  
  %Clustering statistics and plot
  st = apple_algemate_areas(st);
  apple_nonparametric('Clustering',st.ratios,nPerm,st.ROInames);
  apple_nonparametric_baseline('Clustering vs Baseline',st.ratios,nPerm,st.ROInames,2.27);
  subplot(2,3,1);
  meanratio = squeeze(mean(st.ratios,1));
  stdratio = squeeze(std(st.ratios));
  handles = apple_barweb(meanratio,stdratio,1,st.ROInames,'Clustering','Visual area','Ratio');
  box on;grid on;axis([0 numel(st.ROInames)+1 0 5]);

end

% 
% for i=1:
% val = squeeze(mean(snr,2))
% plot(val);





%for i=1:10
%  plot(squeeze(snr(:,i,:)))
%  hold on;
%end