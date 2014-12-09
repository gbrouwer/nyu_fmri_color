function [BtestTASK,BtrainTASK,BtestRSVP,BtrainRSVP] = apple_divide(ds,betasTASK,betasRSVP,taskratio)


%Loop through the sessions
BtestTASK = [];
BtrainTASK = [];
BtestRSVP = [];
BtrainRSVP = [];
for i=1:max(ds.theselabels)

  %Pick session
  dum2 = (ds.theselabels == i);
  blockTASK = betasTASK(:,dum2);
  blockRSVP = betasRSVP(:,dum2);

  %Pick a random run
  randomrun = floor(rand*max(ds.newlabels)) + 1;
  dum1 = (ds.newlabels == randomrun);

  %Concatenate
  BtestTASK = [BtestTASK blockTASK(dum1,:)];
  BtrainTASK = [BtrainTASK blockTASK(~dum1,:)];
  BtestRSVP = [BtestRSVP blockRSVP(dum1,:)];
  BtrainRSVP = [BtrainRSVP blockRSVP(~dum1,:)];
  
end

nVox = size(BtestTASK,2);
indices = 1:nVox;
indices = indices < prctile(indices,taskratio);
BtestTASK = BtestTASK(:,indices);
BtrainTASK = BtrainTASK(:,indices);
