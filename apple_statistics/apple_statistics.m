function apple_statistics(subject)


%Init
clc;
st = [];
nPerm = 1000;
load('apple_randindex_nulldistribution.mat','nulldistribution');
load(['apple_statistics/apple_measures_' subject '_100.mat'])
st = apple_algemate_areas(st);
st.HubertIndex = st.HubertIndex(:,:,1:2).^2;


size(st.ratios)
return

%Clustering statistics and plot
apple_nonparametric('Clustering',st.ratios,nPerm,st.ROInames);
apple_nonparametric_baseline('Clustering vs Baseline',st.ratios,nPerm,st.ROInames,2.27);
subplot(2,3,1);
meanratio = squeeze(mean(st.ratios,1));
stdratio = squeeze(std(st.ratios));
handles = apple_barweb(meanratio,stdratio,1,st.ROInames,'Clustering','Visual area','Ratio');
box on;grid on;axis([0 numel(st.ROInames)+1 0 5]);


%Clustering statistics and plot
apple_nonparametric('Adjusted Rand Indices',st.HubertIndex,nPerm,st.ROInames);
apple_nonparametric_montecarlo('Rand Index vs Baseline',st.HubertIndex,st.ROInames,nulldistribution);
subplot(2,3,2);
meanRand = squeeze(mean(st.HubertIndex,1));
stdRand = squeeze(std(st.HubertIndex));
handles = apple_barweb(meanRand,stdRand,1,st.ROInames,'Adjusted Rand Indices','Visual area','Ratio');
box on;grid on;axis([0 numel(st.ROInames)+1 0 1]);
 

%Amplitudes
st.amplitudes = st.amplitudes.*100;
[~,~,~,error] = apple_nonparametric('Amplitudes',st.amplitudes,nPerm,st.ROInames);
subplot(2,3,3);
meanamp = squeeze(mean(st.amplitudes,1));
handles = apple_barweb(meanamp,error,1,st.ROInames,'Amplitudes','Visual area','Ratio');
box on;grid on;axis([0 numel(st.ROInames)+1 0 0.6]);



%Rsquare
[~,~,~,error] = apple_nonparametric('Rsquare',st.rsquares,nPerm,st.ROInames);
subplot(2,3,4);
meanrsquare = squeeze(mean(st.rsquares,1));
stdrsquare = squeeze(std(st.rsquares));
handles = apple_barweb(meanrsquare,error,1,st.ROInames,'Amplitudes','Visual area','Ratio');
box on;grid on;axis([0 numel(st.ROInames)+1 0 1]);



%SNR
[~,~,~,error] = apple_nonparametric('SNR',st.snr,nPerm,st.ROInames);
subplot(2,3,5);
meansnr = squeeze(mean(st.snr,1));
stdsnr = squeeze(std(st.snr));
handles = apple_barweb(meansnr,error,1,st.ROInames,'SNR','Visual area','Ratio');
box on;grid on;axis([0 numel(st.ROInames)+1 0 10]);




%Gain
[~,~,~,error] = apple_nonparametric('gain',st.gain,nPerm,st.ROInames);
subplot(2,3,6);
meangain = squeeze(mean(st.gain,1));
stdgain = squeeze(std(st.gain));
handles = apple_barweb(meangain,error,1,st.ROInames,'Gain','Visual area','Ratio');
box on;grid on;axis([0 numel(st.ROInames)+1 0 0.5]);



%Tuning Width
[~,~,~,error] = apple_nonparametric('Tuning Width',st.width,nPerm,st.ROInames);
subplot(2,3,1);
meanwidth = squeeze(mean(st.width,1));
stdwidth = squeeze(std(st.width));
handles = apple_barweb(meanwidth,error,1,st.ROInames,'Tuning Width','Visual area','Ratio');
box on;grid on;axis([0 numel(st.ROInames)+1 0 30]);