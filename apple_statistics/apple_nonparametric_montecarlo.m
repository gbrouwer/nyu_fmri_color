function apple_nonparametric_montecarlo(analysisname,indata,ROInames,nulldistribution)


%Init
nTask = 2;
taskstats = [];
areastats = [];
interactionstats = [];
nRois = size(indata,2);
nSamples = size(indata,1);
plist = [0 50 flipdim(100-apple_logarithmic_space(0.0001,5,100),2)];
disp('------------------------------------------------------');
disp(analysisname);
disp('------------------------------------------------------');



%--------------------------------------------------------------------------
%Calculate Statistical Significance of task
%--------------------------------------------------------------------------
for i=1:nRois
  
  %Get Data
  data = squeeze(indata(:,i,:));
  data = mean(data,1);
  nRep = size(data,1);
   
  
  %Compute Significant Difference
  hitlist =  data(1) > prctile(nulldistribution,plist);
  dum = (find(hitlist == 1));
  if (isempty(dum)) dum(1) = numel(hitlist); end
  SigVal = (100 - (plist(dum(end)))) ./ 100;
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
  data = mean(data,1);
  nRep = size(data,1);
   
  %Compute Significant Difference
  hitlist =  data(2) > prctile(nulldistribution,plist);
  dum = (find(hitlist == 1));
  if (isempty(dum)) dum(1) = numel(hitlist); end
  SigVal = (100 - (plist(dum(end)))) ./ 100;
  SigVal = double(SigVal);

  %Display Result
  if (SigVal < 0.05)
    disp([ROInames{i} '-> Diverted Attention Value > Baseline; p<' num2str(SigVal)]);
  else
    disp([ROInames{i} '-> Diverted Attention, No Significant difference']);
  end
   
end
disp('------------------------------------------------------');


