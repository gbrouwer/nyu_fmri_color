function apple_modelfit

%Init
clc;
os = [];



%Define areas
os = apple_algemate_areas(os);



%Load
for i=1:numel(os.selectedROIs)
  loadname = ['apple_results/group_' os.selectedROIs{i} '_fstat.mat'];
 	load(loadname);
  os.modelfit(:,i,:) = ds.modelfit;
end



%Save
save('apple_modelfit.mat','os');
