function apple_algemate(subject,level)


%Init and load
load('cerulean_LCD at scanner - 10262010');
cs = ds; os = [];
os.nChannels = 6;
os.ratio = 0.75;
os.nDim = 3;
os.subject = subject;
os.catlist = [1 1 2 2 3 3 4 4 5 5 5 5];
os.nPermutations = 100;




%Define areas
os = apple_algemate_areas(os);




%Retrieve stored data
os = apple_algemate_obtain(os,level);




%Store for Analysis
%os = apple_algemate_storematrices(os,level);
 
 
 
  
%Clustering and Rand Indices
%os = apple_algemate_clustering(os,level);
 
 

%Auxiliary Statistics (Mean / SNR / R-square)
%os = apple_auxiliary_statistics(os,level);
 
 
 
 
% %Fit Tuning curves
% os = apple_algemate_tuningcurves(os,level);
% 
% 
% 
% 
%Save
save(['apple_modelfit/apple_' subject '_' num2str(level) '.mat'],'os');
