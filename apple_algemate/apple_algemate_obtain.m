function os = apple_algemate_obtain(os,level)


%Clear variables
os.classifier_accuracy_task = [];
os.classifier_accuracy_rsvp = [];
os.forward_accuracy_task = [];
os.forward_accuracy_rsvp = [];


%Obtain data
for l=1:numel(os.selectedROIs)

  %Load and Store
  loadname = ['apple_results/' os.subject '_' os.selectedROIs{l} '_' num2str(level) '.mat'];
  disp(loadname);
  load(loadname);

	%Score Matrices
  os.scorebetas{l} = ds.scorebetas;
  os.modelfit{l} = ds.modelfit;
  
  %Confusion matrices
  os.combinedbetas{l} = ds.combinedbetas;
  dum = sort(repmat(1:ds.param.nRuns,1,ds.param.nClasses));
  dumodd = apple_isodd(dum);
  dumeven = apple_iseven(dum);
  os.classbetas_task{l} = ds.classbetas(dumodd,:);
  os.classbetas_rsvp{l} = ds.classbetas(dumeven,:);
  
  
  %Reconstructed matrices
  os.reconList_task{l} = ds.reconList_task;
  os.reconList_rsvp{l} = ds.reconList_rsvp;
  os.reconMatrix_task{l} = ds.reconMatrix_task;
  os.reconMatrix_rsvp{l} = ds.reconMatrix_rsvp;
  os.reconArray_task{l} = ds.reconArray_task;
  os.reconArray_rsvp{l} = ds.reconArray_rsvp;

  %Beta matrices
  os.combinedR{l} = ds.combinedR;
  os.sessionlabels{l} = ds.sessionlabels;
  os.param = ds.param;
  os.param.RGB = os.param.RGB(1:os.param.nClasses,:);
  os.origbetas{l} = ds.origbetas;
   
	%Store Classifier Accuracies
  os.forward_accuracy_task = [os.forward_accuracy_task ; ds.forward_accuracy_task];
  os.forward_accuracy_rsvp = [os.forward_accuracy_rsvp ; ds.forward_accuracy_rsvp];

end





