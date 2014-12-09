function apple_modelfit

%Init
clc;
os = [];


%Load
load('apple_modelfit.mat','os');
os.modelfit = flipdim(os.modelfit,3).^2;


%Define areas
os = apple_algemate_areas(os);


%Analysis
[~,~,~,error] = apple_nonparametric('Model Fit',os.modelfit,10,os.ROInames);
error = error * 10;
meanamp = squeeze(mean(os.modelfit,1));
handles = apple_barweb(meanamp,error,1,os.ROInames,'Model Fit','Visual area','R-square');
box on;grid on;axis([0 numel(os.ROInames)+1 0 0.02]);
