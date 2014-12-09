function ds = apple_decoding_gatherdata(ds)



%Find the available sessions 
ds = apple_gathersessions(ds);




%Split Area Labels
ds = apple_splitarealabels(ds);




%Loop through sessions to determine minimal size of the betas for each session
ds.path = cd; os = [];
for s=1:numel(ds.sessionlist)
  loadname = [ds.path '/apple_ROIdata/' ds.areanames{1} '/' ds.sessionlist{s} '_' ds.areanames{1} '.mat'];
  load(loadname);
  [nRepeats(s),nDim(s)] = size(os.classbetas);
end
maxDim = max(nRepeats);
minDim = min(nRepeats);
minRun = min(nRepeats) / max(os.classlabels);




%Load and combine the sessions
for s=1:numel(ds.sessionlist)

  
  %Add all area files
  classR = [];
  classbetas = [];
  combinedbetas = [];
  combinedR = [];
  for a=1:numel(ds.areanames)
    
    %Load Session / Area File
    loadname = [ds.path '/apple_ROIdata/' ds.areanames{a}  '/' ds.sessionlist{s} '_' ds.areanames{a} '.mat'];
    load(loadname);
    disp(['Adding: ' loadname]);
    os.param.nRuns = max(os.runlabels);
    os.param.nClasses = max(os.classlabels);
    os.runlabels = sort(repmat(1:sum(os.classlabels == 1),1,os.param.nClasses));
    os.constrainlevel = ds.constrainlevel;
    [~,s2] = size(os.classbetas);
    classR = [classR os.classR];
    classbetas = [classbetas os.classbetas];
    combinedbetas = [combinedbetas os.combinedbetas];
    combinedR = [combinedR os.combinedR];
  end
  
  
  %Normalize
  os.combinedR = combinedR;
  os.combinedbetas = combinedbetas;
  os.classR = classR;
  os.classbetas = classbetas;
  os = apple_normalize(os);
  

  %Reduce to same length across subjects
  ds.param.nRuns = minDim ./ os.param.nClasses;
  os.origbetas = os.origbetas(1:minDim,:);
  os.classbetas = os.classbetas(1:minDim,:);
  os.combinedbetas = os.combinedbetas(1:minRun,:);
  os.classR = os.classR(1:ds.param.nRuns,:);
  os.combinedR = os.combinedR(1:ds.param.nRuns,:);

  
  %Reduce to PCA components
  [~,scores,latent] = princomp(os.classbetas);
  nComp = size(scores,2);
  if (nComp > 20)
    os.scorebetas = scores(:,1:20);
  else
    os.scorebetas = scores(:,1:nComp);
  end
  
  
  %Set parameters
  ds.param = os.param;
  ds.param.nRuns = minDim ./ os.param.nClasses;
  ds.classlabels = os.classlabels(1:minDim);
  ds.runlabels = os.runlabels(1:minDim);
  ds.param.nClasses = os.param.nClasses;

  %Store in big ds structure
  [~,s2] = size(os.classbetas);
  [~,s3] = size(os.scorebetas);
  ds.Fval = [ds.Fval ; os.Fval];
  ds.sessionlabels = [ds.sessionlabels ; zeros(s2,1)+s];
  ds.scorelabels = [ds.scorelabels ; zeros(s3,1)+s];
  ds.classbetas = [ds.classbetas os.classbetas];
  ds.scorebetas = [ds.scorebetas os.scorebetas];
  ds.origbetas = [ds.origbetas os.origbetas];
  ds.classR = [ds.classR os.classR];
  ds.combinedR = [ds.combinedR os.combinedR];
  ds.combinedbetas = [ds.combinedbetas os.combinedbetas];
  
end


