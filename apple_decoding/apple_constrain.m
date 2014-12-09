function [ntestmatrix,ntrainmatrix] = saffron_constrain(testmatrix,trainmatrix,sessionlabels,thisset)


%Get Labels
theselabels = (sessionlabels(thisset == 1));
sessionID = unique(theselabels);
ntestmatrix = [];
ntrainmatrix = [];



%F-statistic
for i=1:numel(sessionID)

  %Indexes
  index = theselabels == sessionID(i);
  X = trainmatrix(:,index) - 1;
  Y = testmatrix(:,index) - 1;

  %F-test
  [~,nvoxels] = size(X);
  ds.Fval = zeros(nvoxels,1);
  for m=1:nvoxels
    amatrix = X(:,m);
    amatrix = reshape(amatrix',12,2)';
    %[~,anovatab,stats] = anova1(amatrix,[],'off');
    F = saffron_fastFtest(amatrix);
    ds.Fval(m) = F;
  end
  constrain = (ds.Fval > prctile(ds.Fval,0.75*100));

  %Add
  ntrainmatrix = [ntrainmatrix X(:,constrain)+1];
  ntestmatrix = [ntestmatrix Y(:,constrain)+1];
  
end

