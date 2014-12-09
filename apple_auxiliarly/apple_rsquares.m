function apple_rsquares

%Init
clc;
load('apple_modelfit/apple_group_100.mat');
os = apple_algemate_areas(os);


%Reshape
for i=1:10
  modelfit(i,:,:) = os.modelfit{i};
end
modelfit = permute(modelfit,[2 1 3]);
size(modelfit)

modelfit = flipdim(modelfit,3);


apple_nonparametric('Model Fit',modelfit,1000,os.ROInames);

%modelfit = squeeze(mean(modelfit,2))



modelfitstd = squeeze(std(modelfit,[],1))
modelfitmean = squeeze(mean(modelfit,1))
handles = apple_barweb(modelfitmean,modelfitstd,1,os.ROInames,'Model Fit','Visual area','Ratio');
box on;grid on;axis([0 numel(os.ROInames)+1 0 0.15]);

%modelfit = flipdim(modelfit,2)
%bar(modelfit)