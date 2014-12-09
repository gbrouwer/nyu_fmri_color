function ds = apple_forwardmodel_categories(ds)


%Clear Variables
ds.conmatrix_task = zeros(ds.param.nClasses,ds.param.nClasses);
ds.conmatrix_rsvp = zeros(ds.param.nClasses,ds.param.nClasses);
betasTASK = ds.classbetas(apple_isodd(ds.runlabels),:);
betasRSVP = ds.classbetas(apple_iseven(ds.runlabels),:);
runlabels = ds.runlabels(1:12*3);
ds.forward_accuracy_task = [];
ds.forward_accuracy_rsvp = [];
ds.reconList_task = [];
ds.reconList_rsvp = [];
ds.reconMatrix_task = [];
ds.reconMatrix_rsvp = [];
ds.reconArray_rsvp = [];
ds.reconArray_task = [];
ds.scores_task = [];
ds.scores_rsvp = [];


%Give Scores instead of classbetas
betasTASK = ds.scorebetas(apple_isodd(ds.runlabels),:);
betasRSVP = ds.scorebetas(apple_iseven(ds.runlabels),:);
ds.sessionlabels = ds.scorelabels;


%Loop through runs
perm = 100;
for t=1:perm
  
 %Random Session / Run
  BtestTASK = [];
  BtrainTASK = [];
  BtestRSVP = [];
  BtrainRSVP = [];
  for p=1:max(ds.sessionlabels)
    runrand = randperm(max(runlabels));
    dum1 = (ds.sessionlabels == p);
    B0 = [];
    B2 = [];
    for o=1:numel(runrand) - 1
      dum2 = (runlabels == runrand(o));
      include(dum2,dum1) = 1;
      B0 = [B0 ; betasTASK(dum2,dum1)];
      B2 = [B2 ; betasRSVP(dum2,dum1)];
      exclude(dum2,dum1) = 0;
    end
    dum2 = (runlabels == runrand(end));
    B1 = betasTASK(dum2,dum1);
    B3 = betasRSVP(dum2,dum1);
    BtrainTASK = [BtrainTASK B0];
    BtestTASK = [BtestTASK B1];
    BtrainRSVP = [BtrainRSVP B2];
    BtestRSVP = [BtestRSVP B3];
  end
  
  %--------------------------------------------------------------------------------------------------------
  %TASK----------------------------------------------------------------------------------------------------
  %--------------------------------------------------------------------------------------------------------

  %Divide data
  trainmatrix = BtrainTASK;
  testmatrix = BtestTASK;
  trainstim = repmat([1 1 2 2 3 4 5 5 5 6 6 6],1,2);
  teststim = repmat([1 1 2 2 3 4 5 5 5 6 6 6],1,1);
  trainforwardmodel = ds.categorymodel(1:24,:);
  testforwardmodel = ds.categorymodel(1:12,:);
  trainmatrix = zscore(trainmatrix) + 1;
  testmatrix = zscore(testmatrix) + 1;
  
  imagesc(trainforwardmodel)
  
  
  %Estimate and reconstruct channels
  W = inv(trainforwardmodel'*trainforwardmodel) * trainforwardmodel' * trainmatrix;
  forwardmodel_recon = (inv(W * W') * W * testmatrix')';
  forwardmodel_recon = zscore(forwardmodel_recon);
     
  %Store
  ds.reconMatrix_task = [ds.reconMatrix_task forwardmodel_recon];
  ds.reconArray_task = [ds.reconArray_task ; forwardmodel_recon];
  
  %Classification and Reconstruction
  predicted = [];
  for l=1:numel(teststim)
    [~,predicted(l)] = max(testforwardmodel * forwardmodel_recon(l,:)');
    [~,maxindex(l)] = max(ds.channels' * forwardmodel_recon(l,:)');
    ds.conmatrix_task(predicted(l),teststim(l)) = ds.conmatrix_task(predicted(l),teststim(l)) + 1;
    ds.reconList_task = [ds.reconList_task ; ds.angles(l) maxindex(l)];
  end
  
  %Classification Accuracy
  for i=1:numel(teststim)
    for j=1:numel(teststim)
      corfield(i,j) = corr2(forwardmodel_recon(i,:),testforwardmodel(j,:));
    end
  end
  [~,predicted] = max(corfield);
  accuracy = sum(predicted == teststim) ./ numel(teststim);
  ds.forward_accuracy_task = [ds.forward_accuracy_task accuracy];
  
  
  %--------------------------------------------------------------------------------------------------------
  %RSVP----------------------------------------------------------------------------------------------------
  %--------------------------------------------------------------------------------------------------------
  
  %Divide data
  trainmatrix = BtrainRSVP;
  testmatrix = BtestRSVP;
  trainstim = repmat([1 1 2 2 3 3 4 4 4 5 5 5],1,2);
  teststim = repmat([1 1 2 2 3 3 4 4 4 5 5 5],1,1);
  trainforwardmodel = ds.categorymodel(1:24,:);
  testforwardmodel = ds.categorymodel(1:12,:);
  trainmatrix = zscore(trainmatrix) + 1;
  testmatrix = zscore(testmatrix) + 1;
  
  
  %Estimate and reconstruct channels
  W = inv(trainforwardmodel'*trainforwardmodel) * trainforwardmodel' * trainmatrix;
  forwardmodel_recon = (inv(W * W') * W * testmatrix')';
  forwardmodel_recon = zscore(forwardmodel_recon);
     
  %Store
  ds.reconMatrix_rsvp = [ds.reconMatrix_rsvp forwardmodel_recon];
  ds.reconArray_rsvp = [ds.reconArray_rsvp ; forwardmodel_recon];
  
  %Classification and Reconstruction
  predicted = [];
  for l=1:numel(teststim)
    [~,predicted(l)] = max(testforwardmodel * forwardmodel_recon(l,:)');
    [~,maxindex(l)] = max(ds.channels' * forwardmodel_recon(l,:)');
    ds.conmatrix_rsvp(predicted(l),teststim(l)) = ds.conmatrix_rsvp(predicted(l),teststim(l)) + 1;
    ds.reconList_rsvp = [ds.reconList_rsvp ; ds.angles(l) maxindex(l)];
  end
  
  %Classification Accuracy
  for i=1:numel(teststim)
    for j=1:numel(teststim)
      corfield(i,j) = corr2(forwardmodel_recon(i,:),testforwardmodel(j,:));
    end
  end
  [~,predicted] = max(corfield);
  accuracy = sum(predicted == teststim) ./ numel(teststim);
  ds.forward_accuracy_rsvp = [ds.forward_accuracy_rsvp accuracy];  
 
end


mean(ds.forward_accuracy_rsvp)
mean(ds.forward_accuracy_task)

%Display if needed
ds.conmatrix_task = ds.conmatrix_task ./ perm;
ds.conmatrix_rsvp = ds.conmatrix_rsvp ./ perm;
ctask = apple_colormap(ds,ds.conmatrix_task);
crsvp = apple_colormap(ds,ds.conmatrix_rsvp);
if (ds.visible > 0)
  subplot(2,4,2);
  imagesc(ctask);
  xlabel('actual');
  ylabel('predicted');
  title('Task');
  subplot(2,4,6);
  imagesc(crsvp);
  xlabel('actual');
  ylabel('predicted');
  title('RSVP');
end






  
 