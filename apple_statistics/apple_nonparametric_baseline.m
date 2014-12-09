function apple_nonparametric_baseline(analysisname,indata,nPerm,ROInames,baseline)


%Init
nTask = 2;
taskstats = [];
areastats = [];
interactionstats = [];
nRois = size(indata,2);
nSamples = size(indata,1);
plist = [apple_logarithmic_space(0.0001,5,100) 50 100];
disp('------------------------------------------------------');
disp(analysisname);
disp('------------------------------------------------------');



%--------------------------------------------------------------------------
%Calculate Statistical Significance of task
%--------------------------------------------------------------------------
for i=1:nRois
  
  %Get Data
  data = squeeze(indata(:,i,:));
  nRep = size(data,1);
  
  
  %Compute Significant Difference
  hitlist =  prctile(data(:,1),plist) > baseline;
  dum = (find(hitlist == 1));
  if (isempty(dum)) dum(1) = numel(hitlist); end
  SigVal = plist(dum(1)) ./ 100;
  SigVal = double(SigVal);

  %Display Result
  if (SigVal < 0.05)
    disp([ROInames{i} '-> Diverted Attention Value > Baseline; p<' num2str(SigVal)]);
  else
    disp([ROInames{i} '-> Diverted Attention, No Significant difference']);
  end
  
end
disp('------------------------------------------------------');

for i=1:nRois
  
  
  %Get Data
  data = squeeze(indata(:,i,:));
  nRep = size(data,1);
  
  
  %Compute Significant Difference
  hitlist =  prctile(data(:,2),plist) > baseline;
  dum = (find(hitlist == 1));
  if (isempty(dum)) dum(1) = numel(hitlist); end
  SigVal = plist(dum(1)) ./ 100;
  SigVal = double(SigVal);

  %Display Result
  if (SigVal < 0.05)
    disp([ROInames{i} '-> Color Naming Value > Baseline; p<' num2str(SigVal)]);
  else
    disp([ROInames{i} '-> Color Naming, No Significant difference']);
  end  
  
end
disp('------------------------------------------------------');






