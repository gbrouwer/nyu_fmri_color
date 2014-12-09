function ds = apple_meanresponses(ds)


%Compute mean response for each session
comdata_task = [];
comdata_rsvp = [];
totRuns = 0;
for i=1:max(ds.sessionlabels)
  
  %Get data
  dum = (ds.sessionlabels == i);
  thisdata = ds.origbetas(:,dum);
  
  %Reshape data
  [nSamples,nDim] = size(thisdata);
  nRuns = nSamples / ds.param.nClasses;
  totRuns = totRuns + nRuns;

  %Average data
  thisdata = reshape(thisdata,ds.param.nClasses,nRuns,nDim);
  thisdata_task = thisdata(:,1:2:end,:);
  thisdata_rsvp = thisdata(:,2:2:end,:);
  meandata = mean(thisdata_task,3);
  comdata_task = [comdata_task meandata];
  meandata = mean(thisdata_rsvp,3);
  comdata_rsvp = [comdata_rsvp meandata];
  
end
ds.mean_task = comdata_task;
ds.mean_rsvp = comdata_rsvp;








