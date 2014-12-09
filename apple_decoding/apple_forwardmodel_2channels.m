function ds = apple_forwardmodel(ds)


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
  [BtestTASK,BtrainTASK,BtestRSVP,BtrainRSVP] = apple_divide(ds,betasTASK,betasRSVP);

  
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
  C = zscore(inv(W * W') * W * BtestRSVP')';
  for l=1:numel(teststim)
    [~,predicted(l)] = max(testforwardmodel * C(l,:)');
    [~,maxindex(l)] = max(ds.channels' * C(l,:)');
    ds.reconList_rsvp = [ds.reconList_task ; ds.angles(l) maxindex(l)];
  end
  ds.reconMatrix_rsvp = [ds.reconMatrix_rsvp C];
  ds.reconArray_rsvp = [ds.reconArray_rsvp ; C];
  ds.forward_accuracy_rsvp = [ds.forward_accuracy_rsvp sum(predicted == teststim) ./ numel(teststim)];
 

  %Estimate and reconstruct channels TASK/RSVP shuffled
  tmptask = [];
  tmprsvp = [];
  for r=1:ds.nRandomizations
    Ftest = testforwardmodel;
    Ftrain = trainforwardmodel;
    [s1,s2] = size(Ftrain);
    Ftrain = Ftrain(randperm(s1),:);
    [s1,s2] = size(Ftest);
    Ftest = Ftest(randperm(s1),:);
    
    W = inv(Ftrain'*Ftrain) * Ftrain' * BtrainTASK;
    C = zscore(inv(W * W') * W * BtestTASK')';
    for l=1:numel(teststim)
      [~,predicted(l)] = max(Ftest * C(l,:)');
      [~,maxindex(l)] = max(ds.channels' * C(l,:)');
      ds.reconList_task_shuffle = [ds.reconList_task_shuffle ; ds.angles(l) maxindex(l)];
    end
    ds.reconMatrix_task_shuffle = [ds.reconMatrix_task_shuffle C];
    ds.reconArray_task_shuffle = [ds.reconArray_task_shuffle ; C];  
    tmptask = [tmptask sum(predicted == teststim) ./ numel(teststim)];
    
    W = inv(Ftrain'*Ftrain) * Ftrain' * BtrainRSVP;
    C = zscore(inv(W * W') * W * BtestRSVP')';
    for l=1:numel(teststim)
      [~,predicted(l)] = max(Ftest * C(l,:)');
      [~,maxindex(l)] = max(ds.channels' * C(l,:)');
      ds.reconList_rsvp_shuffle = [ds.reconList_rsvp_shuffle ; ds.angles(l) maxindex(l)];
    end
    ds.reconMatrix_rsvp_shuffle = [ds.reconMatrix_rsvp_shuffle C];
    ds.reconArray_rsvp_shuffle = [ds.reconArray_rsvp_shuffle ; C];  
    tmprsvp = [tmprsvp sum(predicted == teststim) ./ numel(teststim)];
  end
  ds.forward_accuracy_task_shuffle = [ds.forward_accuracy_task_shuffle mean(tmptask)];  
  ds.forward_accuracy_rsvp_shuffle = [ds.forward_accuracy_rsvp_shuffle mean(tmprsvp)];  
    
  
end

mean(ds.forward_accuracy_rsvp)
mean(ds.forward_accuracy_task)
ds.forward_accuracy_rsvp
ds.forward_accuracy_task