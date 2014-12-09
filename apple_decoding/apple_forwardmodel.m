function ds = apple_forwardmodel(ds,level)


%Clear Variables
betasTASK = ds.classbetas(apple_isodd(ds.runlabels),:);
betasRSVP = ds.classbetas(apple_iseven(ds.runlabels),:);
ds.forward_accuracy_task = [];
ds.forward_accuracy_rsvp = [];
ds.forward_accuracy_task_shuffle = [];
ds.forward_accuracy_rsvp_shuffle = [];
ds.reconList_task = [];
ds.reconList_rsvp = [];
ds.reconMatrix_task = [];
ds.reconMatrix_rsvp = [];
ds.reconArray_rsvp = [];
ds.reconArray_task = [];
ds.reconList_task_shuffle = [];
ds.reconList_rsvp_shuffle = [];
ds.reconMatrix_task_shuffle = [];
ds.reconMatrix_rsvp_shuffle = [];
ds.reconArray_rsvp_shuffle = [];
ds.reconArray_task_shuffle = [];
ds.scorebetasTASK = [];
ds.scorebetasRSVP = [];



%Give Scores instead of classbetas
betasTASK = ds.scorebetas(apple_isodd(ds.runlabels),:);
betasRSVP = ds.scorebetas(apple_iseven(ds.runlabels),:);
ds.theselabels = ds.scorelabels;
ds.newlabels = ds.runlabels(1:12*3);




%Loop through runs
for t=1:ds.nRandomizations

  %Random Session / Run
  [BtestTASK,BtrainTASK,BtestRSVP,BtrainRSVP] = apple_divide(ds,betasTASK,betasRSVP,level);

  
  %Divide data
  trainstim = repmat(1:ds.param.nClasses,1,2);
  teststim = repmat(1:ds.param.nClasses,1,1);
  trainforwardmodel = ds.forwardmodel(1:24,:);
  testforwardmodel = ds.forwardmodel(1:12,:);
  BtrainTASK = zscore(BtrainTASK) + 1;
  BtestTASK = zscore(BtestTASK) + 1;
  BtrainRSVP = zscore(BtrainRSVP) + 1;
  BtestRSVP = zscore(BtestRSVP) + 1;
  ds.scorebetasTASK = [ds.scorebetasTASK BtestTASK];
  ds.scorebetasRSVP = [ds.scorebetasRSVP BtestRSVP];

  
  %Estimate and reconstruct channels TASK
  W = inv(trainforwardmodel'*trainforwardmodel) * trainforwardmodel' * BtrainTASK;
  P = testforwardmodel*W;
  ds.modelfit(t,1) = corr2(reshape(P,numel(P),1),reshape(BtestTASK,numel(BtestTASK),1));
  C = zscore(inv(W * W') * W * BtestTASK')';
  for l=1:numel(teststim)
    [~,predicted(l)] = max(testforwardmodel * C(l,:)');
    [~,maxindex(l)] = max(ds.channels' * C(l,:)');
    ds.reconList_task = [ds.reconList_task ; ds.angles(l) maxindex(l)];
  end
  ds.reconMatrix_task = [ds.reconMatrix_task C];
  ds.reconArray_task = [ds.reconArray_task ; C];
  ds.forward_accuracy_task = [ds.forward_accuracy_task sum(predicted == teststim) ./ numel(teststim)];


  
  %Estimate and reconstruct channels RSVP
  W = inv(trainforwardmodel'*trainforwardmodel) * trainforwardmodel' * BtrainRSVP;
  P = testforwardmodel*W;
  ds.modelfit(t,2) = corr2(reshape(P,numel(P),1),reshape(BtestRSVP,numel(BtestRSVP),1));
  C = zscore(inv(W * W') * W * BtestRSVP')';
  for l=1:numel(teststim)
    [~,predicted(l)] = max(testforwardmodel * C(l,:)');
    [~,maxindex(l)] = max(ds.channels' * C(l,:)');
    ds.reconList_rsvp = [ds.reconList_task ; ds.angles(l) maxindex(l)];
  end
  ds.reconMatrix_rsvp = [ds.reconMatrix_rsvp C];
  ds.reconArray_rsvp = [ds.reconArray_rsvp ; C];
  ds.forward_accuracy_rsvp = [ds.forward_accuracy_rsvp sum(predicted == teststim) ./ numel(teststim)];
 
 
end
