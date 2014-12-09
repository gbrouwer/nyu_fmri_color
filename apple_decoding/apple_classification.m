function ds = apple_classification(ds)



%Reset
ds.classifier_accuracy_task = [];
ds.classifier_accuracy_rsvp = [];
ds.classifier_accuracy_task_shuffle = [];
ds.classifier_accuracy_rsvp_shuffle = [];
betasTASK = ds.classbetas(apple_isodd(ds.runlabels),:);
betasRSVP = ds.classbetas(apple_iseven(ds.runlabels),:);
ds.theselabels = ds.sessionlabels;


%Give Scores instead of classbetas
betasTASK = ds.scorebetas(apple_isodd(ds.runlabels),:);
betasRSVP = ds.scorebetas(apple_iseven(ds.runlabels),:);
ds.theselabels = ds.scorelabels;
ds.newlabels = ds.runlabels(1:12*3);



%Loop
for t=1:ds.nRandomizations

  %Random Session / Run
  disp(t);
  [BtestTASK,BtrainTASK,BtestRSVP,BtrainRSVP] = apple_divide(ds,betasTASK,betasRSVP);

  %Divide data and classify TASK
  trainstim = repmat(1:ds.param.nClasses,1,2);
  teststim = repmat(1:ds.param.nClasses,1,1);
  predicted = apple_classifier(BtestTASK,BtrainTASK,trainstim,'diaglinear');
  ds.classifier_accuracy_task = [ds.classifier_accuracy_task sum(predicted' == teststim) ./ numel(teststim)];

  
  %Divide data and classify RSVP
  trainstim = repmat(1:ds.param.nClasses,1,2);
  teststim = repmat(1:ds.param.nClasses,1,1);
  predicted = apple_classifier(BtestRSVP,BtrainRSVP,trainstim,'diaglinear');
  ds.classifier_accuracy_rsvp = [ds.classifier_accuracy_rsvp sum(predicted' == teststim) ./ numel(teststim)];

  %Shuffle and permutate
  tmptask = [];
  tmprsvp = [];
  for l=1:25%ds.nRandomizations
    trainstim = trainstim(randperm(numel(trainstim)));
    predicted_task = apple_classifier(BtestTASK,BtrainTASK,trainstim,'diaglinear');
    predicted_rsvp = apple_classifier(BtestTASK,BtrainTASK,trainstim,'diaglinear');
    tmptask = [tmptask sum(predicted_task' == teststim) ./ numel(teststim)];
    tmprsvp = [tmprsvp sum(predicted_rsvp' == teststim) ./ numel(teststim)];
  end
  ds.classifier_accuracy_task_shuffle = [ds.classifier_accuracy_task_shuffle mean(tmptask)];
  ds.classifier_accuracy_rsvp_shuffle = [ds.classifier_accuracy_rsvp_shuffle mean(tmprsvp)];

end


