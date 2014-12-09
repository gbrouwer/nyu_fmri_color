function ds = apple_normalize(ds)


%Store Originals
ds.origbetas = ds.classbetas;


%Normalize 1st pass
for m=1:max(ds.runlabels)
  
  %Normalize Canonical GLM
  dum = (ds.runlabels == m);
  thismatrix = ds.classbetas(dum,:);
  meanresponse = mean(thismatrix);
  unitvector = meanresponse  ./ norm(meanresponse);
  projectmatrix = (thismatrix' - unitvector'*(unitvector*thismatrix'))';
  ds.classbetas(dum,:) = projectmatrix;
    
end



%ANOVA
[~,nvoxels] = size(ds.classbetas);
ds.Fval = zeros(nvoxels,1);
for m=1:nvoxels
  amatrix = ds.classbetas(:,m);
  amatrix = reshape(amatrix',ds.param.nClasses,ds.param.nRuns)';
  ds.Fval(m) = apple_fastFtest(amatrix);
end




%Constrain
R = mean(ds.combinedR,1);
constrain = (ds.Fval > prctile(ds.Fval,ds.constrainlevel*100));
ds.origbetas = ds.origbetas(:,constrain);
ds.classbetas = ds.classbetas(:,constrain);
ds.classR = ds.classR(:,constrain);
ds.Fval = ds.Fval(constrain);
ds.combinedbetasRestricted = ds.combinedbetas(:,constrain);




%Normalize 2nd pass
for m=1:max(ds.runlabels)
  
  %Normalize Canonical GLM
  dum = (ds.runlabels == m);
  thismatrix = ds.classbetas(dum,:);
  meanresponse = mean(thismatrix);
  unitvector = meanresponse  ./ norm(meanresponse);
  projectmatrix = (thismatrix' - unitvector'*(unitvector*thismatrix'))';
  ds.classbetas(dum,:) = projectmatrix;

end



