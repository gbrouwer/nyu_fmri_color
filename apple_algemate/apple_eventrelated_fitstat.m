function apple_eventrelated_fitstat

%Init
clc;
load('apple_eventrelated_fit');
fitval = fitval(:,:,1:6);
nPerm = 1000;
plistIncrease = [0 50 flipdim(100 - apple_logarithmic_space(0.0001,5,100),2)];
plistDecrease = [apple_logarithmic_space(0.0001,5,100) 50 100];



for p=1:6
  
  %Get Data
  data = squeeze(fitval(:,:,p))';
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

  subplot(2,3,p);
  scatter(data(:,1),data(:,2))
  
  %Compute actual difference
  observed = median(data);
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

  SigDecVal
  SigIncVal

end