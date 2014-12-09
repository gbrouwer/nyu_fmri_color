function ds = apple_runexperiment(ds)


%Reset variables
count = 0;
ds.classlabels = [];
ds.runlabels = [];
ds.betas = [];


%Compute voxel activity
for r=1:ds.nRuns
  thisdata = [];
  for o=1:ds.nColors
    ds.classlabels = [ds.classlabels o];
    ds.runlabels = [ds.runlabels r];
    count = count + 1;
    angle = round((o-1) ./ ds.nColors * 360) + 1;
    channelresponse = ds.channels(:,angle);
    ds.forwardmodel(count,:) = channelresponse;
    thisdata = [thisdata ds.weights * channelresponse];
  end
  ds.betas = [ds.betas ; thisdata'];
end

