function apple_interaction_test


%Init
clc;
nRep = 100;
nArea = 10;
nTask = 2;
nPerm = 1000;
y = [];
noise = 1;
count = 0;
plistIncrease = [0 50 flipdim(100 - apple_logarithmic_space(0.0001,5,100),2)];
plistDecrease = [apple_logarithmic_space(0.0001,5,100) 50 100];




%Task Names
tasknames{1} = 'diverted attention';
tasknames{2} = 'color naming';




%Area Names
areanames{1} = 'v1';
areanames{2} = 'v2';
areanames{3} = 'v3';
areanames{4} = 'v4v';
areanames{5} = 'vo1';
areanames{6} = 'vo2';
areanames{7} = 'v3ab';
areanames{8} = 'lo1';
areanames{9} = 'lo2';
areanames{10} = 'mt';








%Create data
for i=1:nRep
  for j=1:nArea
    for l=1:nTask
      matrix(i,j,l) = normrnd(l,noise);
      if (j == 4 && l == 1)
        matrix(i,j,l) = normrnd(l,noise);
      end
      if (j == 4 && l == 2)
        matrix(i,j,l) = normrnd(l+1,noise);
      end
      y = [y  matrix(i,j,l)];
      count = count + 1;
      tasklabel{count} = num2str(l);
      arealabel{count} = num2str(j);
    end
  end
end











% %Randomization test on visual area
% for i=1:nArea
%   
%   %Get Data
%   data = squeeze(matrix(:,i,:));
%   
%   %Randomize
%   nulldistribution = [];
%   for j=1:nPerm
%     randval1 = randperm(nRep*2);
%     randdata = data(randval1');
%     randdata = reshape(randdata,nRep,2);
%     meanval = mean(randdata);
%     nulldistribution(j) = meanval(2) - meanval(1);
%   end
%   
%   %Compute actual difference
%   observed = mean(data);
%   observed = observed(2) - observed(1);
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
%   %Display Result
%   if (SigDecVal < 0.05)
%     disp([areanames{i} '-> Color Naming < Diverted attention; p<' num2str(SigDecVal)]);
%   end
%   if (SigIncVal < 0.05)
%     disp([areanames{i} '-> Color Naming > Diverted attention; p<' num2str(SigIncVal,'%2.6f')]);
%   end
%   if (SigIncVal > 0.05 && SigDecVal > 0.05)
%     disp([areanames{i} '-> No Significant difference']);
%   end
%   
% end








% %Randomization test on visual area
% for i=1:nTask
%   
%   %Get Data
%   data = squeeze(matrix(:,:,i));
%   
%   %Randomize
%   nulldistribution = [];
%   for j=1:nPerm
%     randval1 = randperm(nRep*nArea);
%     randdata = data(randval1');
%     randdata = reshape(randdata,nRep,nArea);
%     meanval = mean(randdata);
%     nulldistribution(j) = meanval(2) - meanval(1);
%   end
%   
%   
%   %Loop Through Area to determine pairwise difference
%   meanval = mean(data,1);
%   sigmatrix = zeros(nArea,nArea,nTask);
%   for j=1:nArea
%     for l=1:nArea
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


  
  
  
%Interaction Test
data = squeeze(matrix(:,:,:));
data = data(:,:,2) - data(:,:,1);

  
%Randomize
nulldistribution = [];
for j=1:nPerm
  randval1 = randperm(nRep*nArea);
  randdata = data(randval1');
  randdata = reshape(randdata,nRep,nArea);
  meanval = mean(randdata);
  nulldistribution(j) = meanval(2) - meanval(1);
end
   
   
%Loop Through Area to determine pairwise difference
meanval = mean(data,1);
sigmatrix = zeros(nArea,nArea) + 0.5;
for j=1:nArea
  for l=1:nArea

    %Get Observed Value
    observed = meanval(j) - meanval(l);

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
    SigDecVal = double(SigDecVal);
    SigIncVal = double(SigIncVal);

    %Display Result
    if (SigDecVal < 0.05)
      sigmatrix(j,l) = -SigDecVal;
    end
    if (SigIncVal < 0.05)
      sigmatrix(j,l) = SigIncVal;
    end

  end

end

sigmatrix
bar(squeeze(mean(matrix,1)))


  
  
  
  
  
  
  
  
  
%   %Randomize
%   nulldistribution = [];
%   for j=1:nPerm
%     randval1 = randperm(nRep*2);
%     randdata = data(randval1');
%     randdata = reshape(randdata,nRep,2);
%     meanval = mean(randdata);
%     nulldistribution(j) = meanval(2) - meanval(1);
%   end
%   
%   %Compute actual difference
%   observed = mean(data);
%   observed = observed(2) - observed(1);
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
%   %Display Result
%   if (SigDecVal < 0.05)
%     disp([areanames{i} '-> Color Naming < Diverted attention; p<' num2str(SigDecVal)]);
%   end
%   if (SigIncVal < 0.05)
%     disp([areanames{i} '-> Color Naming > Diverted attention; p<' num2str(SigIncVal,'%2.6f')]);
%   end
%   if (SigIncVal > 0.05 && SigDecVal > 0.05)
%     disp([areanames{i} '-> No Significant difference']);
%   end
%   










