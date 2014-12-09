function [taskstats,areastats,interactionstats,error] = apple_nonparametric(analysisname,indata,nPerm,ROInames)


%Init
nTask = 2;
taskstats = [];
areastats = [];
interactionstats = [];
nRois = size(indata,2);
nSamples = size(indata,1);
plistIncrease = [0 50 flipdim(100 - apple_logarithmic_space(0.0001,5,100),2)];
plistDecrease = [apple_logarithmic_space(0.0001,5,100) 50 100];
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
  

  %Randomize
  nulldistribution = [];
  for j=1:nPerm
    randval1 = randperm(nRep*2);
    randdata = data(randval1');
    randdata = reshape(randdata,nRep,2);
    meanval = mean(randdata);
    nulldistribution(j) = meanval(2) - meanval(1);
    nulldistribution1(j) = meanval(1);
    nulldistribution2(j) = meanval(2);
  end
  
  %Compute actual difference
  observed = mean(data);
  observed = observed(2) - observed(1);
  
  %Compute Significant Decrease
  hitlist = observed < prctile(nulldistribution,plistDecrease);
  dum = (find(hitlist == 1));
  if (isempty(dum)) dum(1) = numel(hitlist); end
  SigDecVal = plistDecrease(dum(1)) ./ 100;
  
  %Compute Significant Increase
  hitlist = observed > prctile(nulldistribution,plistIncrease);
  dum = (find(hitlist == 1));
  if (isempty(dum)) dum(1) = 1; end
  SigIncVal = (100 - (plistIncrease(dum(end)))) ./ 100;

  %Display Result
  if (SigDecVal < 0.05)
    disp([ROInames{i} '-> Color Naming < Diverted attention; p<' num2str(SigDecVal)]);
  end
  if (SigIncVal < 0.05)
    disp([ROInames{i} '-> Color Naming > Diverted attention; p<' num2str(SigIncVal,'%2.6f')]);
  end
  if (SigIncVal > 0.05 && SigDecVal > 0.05)
    disp([ROInames{i} '-> No Significant difference; p=' num2str(SigIncVal,'%2.6f')]);
  end
  

  %Error
  error(i,1) = std(nulldistribution1);
  error(i,2) = std(nulldistribution2);
  
  
end
disp('------------------------------------------------------');

























































% 
% 
% 
% 
% %--------------------------------------------------------------------------
% %Calculate Statistical Significance of visual area
% %--------------------------------------------------------------------------
% for i=1:nTask
%   
%   %Get Data
%   data = squeeze(indata(:,:,i));
%   nRep = size(data,1);
%   
%   
%   %Randomize
%   nulldistribution = [];
%   for j=1:nPerm
%     randval1 = randperm(nRep*nRois);
%     randdata = data(randval1');
%     randdata = reshape(randdata,nRep,nRois);
%     meanval = mean(randdata);
%     nulldistribution(j) = meanval(2) - meanval(1);
%   end
%    
%   
%   %Loop Through Area to determine pairwise difference
%   meanval = mean(data,1);
%   sigmatrix = zeros(nRois,nRois,nTask) + 0.5;
%   for j=1:nRois
%     for l=1:nRois
%       
%       %Get Observed Value
%       observed = meanval(j) - meanval(l);
%  
%       %Compute Significant Decrease
%       hitlist = observed < prctile(nulldistribution,plistDecrease);
%       dum = (find(hitlist == 1));
%       if (isempty(dum)) dum(1) = numel(hitlist); end
%       SigDecVal = plistDecrease(dum(1)) ./ 100;
% 
%       %Compute Significant Increase
%       hitlist = observed > prctile(nulldistribution,plistIncrease);
%       dum = (find(hitlist == 1));
%       if (isempty(dum)) dum(1) = 1; end
%       SigIncVal = (100 - (plistIncrease(dum(end)))) ./ 100;
%       SigDecVal = double(SigDecVal);
%       SigIncVal = double(SigIncVal);
% 
%       %Display Result
%       if (SigDecVal < 0.05)
%         sigmatrix(j,l,i) = -SigDecVal;
%       end
%       if (SigIncVal < 0.05)
%         sigmatrix(j,l,i) = SigIncVal;
%       end
%       
%     end
%     
%   end
%   
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %--------------------------------------------------------------------------
% %Calculate Statistical Interaction
% %--------------------------------------------------------------------------
% data = squeeze(indata(:,:,:));
% nRep = size(data,1);
% 
%    
% %Randomize
% nulldistribution = [];
% for j=1:1000
% 
%   randarea1 = floor(rand * nRois) + 1;
%   randarea2 = floor(rand * nRois) + 1;
%   randval1 = floor(rand * nRep) + 1;
%   randval2 = floor(rand * nRep) + 1;
%   
%   val1 = data(randval1,randarea1,1);
%   val2 = data(randval1,randarea1,2);
%   nulldistribution(j) = val2 - val1;
% end
% 
%  
% %Loop Through Area to determine pairwise difference
% % meanval = mean(data,1);
% sigmatrix = zeros(nRois,nRois) + 0.5;
% val = squeeze(mean(data,1));
% for j=1:nRois
%   
%   
%   for i=1:1000
% 
%     randarea1 = floor(rand * nRois) + 1;
%     randarea2 = floor(rand * nRois) + 1;
%     randval1 = floor(rand * nRep) + 1;
%     randval2 = floor(rand * nRep) + 1;
%     val1 = data(randval1,randarea1,1);
%     val2 = data(randval1,randarea1,2);
%     nulldistribution(j) = val2 - val1;
% 
%   end
% 
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   
%   %Get Observed Value
%   observed = (val(j,2) - val(j,1)) ./ (val(j,2) + val(j,1)) 
%   prctile(nulldistribution,95)
%   
%   %Compute Significant Decrease
%   hitlist = observed < prctile(nulldistribution,plistDecrease);
%   dum = (find(hitlist == 1));
%   if (isempty(dum)) dum(1) = numel(hitlist); end
%   SigDecVal = plistDecrease(dum(1)) ./ 100;
% 
%   %Compute Significant Increase
%   hitlist = observed > prctile(nulldistribution,plistIncrease);
%   dum = (find(hitlist == 1));
%   if (isempty(dum)) dum(1) = 1; end
%   SigIncVal = (100 - (plistIncrease(dum(end)))) ./ 100;
%   SigDecVal = double(SigDecVal);
%   SigIncVal = double(SigIncVal);
% 
% 
% 
%   %Display Result
%   if (SigDecVal < 0.05)
%     sigmatrix(j,l) = -SigDecVal;
%   end
%   if (SigIncVal < 0.05)
%     sigmatrix(j,l) = SigIncVal;
%   end
% 
% end
% sigmatrix
% 
% 
