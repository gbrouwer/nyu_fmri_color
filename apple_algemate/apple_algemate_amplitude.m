function os = apple_algemate_amplitude(os)

%Loop through ROIs
yratio = [];
ymean = [];
yrsquare = [];
grouptask = [];
grouparea = [];


for m=1:numel(os.origbetas)

  %Get data
  count = 0;
  labels = os.sessionlabels{m};
  betas = os.combinedbetas{m};
  R = os.combinedR{m};
  
  
  %Separate Rsquare
  TASKr = R(1:2:end,:);
  RSVPr = R(2:2:end,:);
  TASKr = squeeze(mean(TASKr,1));
  RSVPr = squeeze(mean(RSVPr,1));

  
  %Remove outliers and separate betas
  betas(betas > 0.1) = 0;
  betas(betas < 0.0) = 0;
  TASKbetas = betas(1:2:end,:);
  RSVPbetas = betas(2:2:end,:);
 
  
  %Constrain   
  constrain = (TASKr > prctile(TASKr,50));
  TASKbetas = TASKbetas(:,constrain);
  TASKr = TASKr(constrain);
  RSVPbetas = RSVPbetas(:,constrain);  
  RSVPr = RSVPr(constrain);
  

  %Calculate ratio and ratio difference
  TASKmean = mean(TASKbetas);
  TASKstd = std(TASKbetas);
  TASKratio = TASKmean ./ TASKstd;
  TASKratiomean = nanmean(TASKratio);
  RSVPmean = mean(RSVPbetas);
  RSVPstd = std(RSVPbetas);
  RSVPratio = RSVPmean ./ RSVPstd;
  RSVPratiomean = nanmean(RSVPratio);
  ratiodifference = TASKratiomean - RSVPratiomean;
  meandifference = nanmean(TASKmean) - nanmean(RSVPmean);
  RsquareDifference = nanmean(TASKr) - nanmean(RSVPr);
  meandifference
  
  %Separate further for anova
  for i=1:10%max(labels)
    dum = (labels == i);
    nTASKmean = mean(TASKbetas(:,dum));
    nTASKstd = std(TASKbetas(:,dum));
    nTASKratio = nTASKmean ./ nTASKstd;
    nTASKratiomean = nanmedian(nTASKratio);

    nRSVPmean = mean(RSVPbetas(:,dum));
    nRSVPstd = std(RSVPbetas(:,dum));
    nRSVPratio = nRSVPmean ./ nRSVPstd;
    nRSVPratiomean = nanmedian(nRSVPratio);

    nratiodifference(i,m) = nTASKratiomean - nRSVPratiomean;
    nmeandifference(i,m) = nanmean(nTASKmean) - nanmean(nRSVPmean);
    nRsquareDifference(i,m) = nanmean(TASKr(:,dum)) - nanmean(RSVPr(:,dum));
    
    yratio = [yratio nTASKratiomean nRSVPratiomean];
    ymean = [ymean nanmean(nTASKmean) nanmean(nRSVPmean)];
    yrsquare = [yrsquare nanmean(TASKr(:,dum)) nanmean(RSVPr(:,dum))];
    grouparea = [grouparea {os.ROInames{m} os.ROInames{m}}];
    grouptask = [grouptask {'task' 'rsvp'}];
    
  end

  dum = isinf(nRsquareDifference);
  nRsquareDifference(dum) = 0;
  dum = isinf(RSVPr);
  RSVPr(dum) = 0;
  dum = isinf(TASKr);
  TASKr(dum) = 0;
  
  %Permutation Test for significance
  for l=1:os.nPermutations
    
    %Crossover
    nVox = size(TASKbetas,2);
    randval = randperm(nVox);
    randval1 = randval(1:floor(nVox/2));
    randval2 = randval(floor(nVox/2)+1:end);
    tmp1 = [TASKbetas(:,randval1) RSVPbetas(:,randval2)];
    tmp2 = [TASKbetas(:,randval2) RSVPbetas(:,randval1)];
    tmpr1 = [TASKr(randval1) RSVPr(:,randval2)];
    tmpr2 = [TASKr(randval2) RSVPr(:,randval1)];
    TASKbetas = tmp1;
    RSVPbetas = tmp2;
    
    %Get rid of Inf rsquare
    dum = isinf(tmpr1);
    tmpr1(dum) = 0;
    dum = isinf(tmpr2);
    tmpr2(dum) = 0;
    
    %Recompute
    rTASKmean = mean(TASKbetas);
    rTASKstd = std(TASKbetas);
    rTASKratio = rTASKmean ./ rTASKstd;
    rTASKratiomean = nanmean(rTASKratio);
    rRSVPmean = mean(RSVPbetas);
    rRSVPstd = std(RSVPbetas);
    rRSVPratio = rRSVPmean ./ rRSVPstd;
    rRSVPratiomean = nanmean(rRSVPratio);
    nulldifference(l) = rTASKratiomean - rRSVPratiomean;
    nulldifferenceR(l) = nanmean(tmpr1) - nanmean(tmpr2);
    nulldifferenceMean(l) = nanmean(rTASKmean) - nanmean(rRSVPmean);
    
  end
  
  
  %Determine percentile
  for i=1:100
    val = 90 + i/10;
    plist(i,1) = prctile(nulldifference,i);
    plist(i,2) = val;
    rlist(i,1) = prctile(nulldifferenceR,i);
    rlist(i,2) = val;
    mlist(i,1) = prctile(nulldifferenceMean,i);
    mlist(i,2) = val;
  end
  
  if (ratiodifference < 0)
    ratiodifference = -ratiodifference;
  end
  if (RsquareDifference < 0)
    RsquareDifference = -RsquareDifference;
  end
  if (meandifference < 0)
    meandifference = -meandifference;
  end
    
  
  dum = find(plist(:,1) <= ratiodifference);
  pvalue(m) = (100 - plist(dum(end),2)) / 100;
  dum = find(rlist(:,1) <= RsquareDifference);
  pvaluer(m) = (100 - rlist(dum(end),2)) / 100;
  dum = find(mlist(:,1) <= meandifference);
  pvaluem(m) = (100 - mlist(dum(end),2)) / 100;
  
  %Store for plotting
  os.amplitudes(m,1) = mean(RSVPmean).*100;
  os.amplitudes(m,2) = mean(TASKmean).*100;
  os.amplitudes_error(m,1) = mean(RSVPstd).*100;
  os.amplitudes_error(m,2) = mean(TASKstd).*100;  


  
  
  %Store for bar graph
  os.amplitudes(m,1) = mean(RSVPmean).*100;
  os.amplitudes(m,2) = mean(TASKmean).*100;
  os.amplitudes_error(m,1) = mean(RSVPstd).*100;
  os.amplitudes_error(m,2) = mean(TASKstd).*100;  

  os.SNR(m,1) = nanmean(RSVPratio);
  os.SNR(m,2) = nanmean(TASKratio);
  os.SNRstd(m,1) = nanstd(RSVPratio);
  os.SNRstd(m,2) = nanstd(TASKratio);
  
  os.rsquare(m,1) = nanmean(RSVPr);
  os.rsquare(m,2) = nanmean(TASKr);
  os.rsquarestd(m,1) = nanstd(RSVPr);
  os.rsquarestd(m,2) = nanstd(TASKr);

end



% %Test for Normality
% warning off
% for i=1:20
%   startval = ((i-1)*20) + 1;
%   endval = startval + 20 - 1;
%   [h,p,kstat,critval] = lillietest(yratio(startval:endval));
%   [h,p,kstat,critval] = lillietest(ymean(startval:endval));
%   [h,p,kstat,critval] = lillietest(yrsquare(startval:endval));
% end
% warning on;
% 
% 
pvaluem
pvaluer
pvalue

os.amplitudes
os.SNR
os.rsquare
yrsquare(yrsquare<0) = 0;
[p,tab,stats] = anovan(yratio,{grouptask grouparea},'model',2,'sstype',2,'varnames',{'Task';'Visual Area'});
[p,tab,stats] = anovan(ymean,{grouptask grouparea},'model',2,'sstype',2,'varnames',{'Task';'Visual Area'});
[p,tab,stats] = anovan(yrsquare,{grouptask grouparea},'model',2,'sstype',2,'varnames',{'Task';'Visual Area'});



% 
% bar(mean(nRsquareDifference))
% 

% 
% %Plot amplitudes
% 
% %subplot(4,4,1);
% hold on;
% handles = apple_barweb(os.amplitudes,os.amplitudes_error,1,os.ROInames,'Amplitudes','Visual area','fMRI response amplitude (% signal change)');
% box on;grid on;axis([0 numel(os.selectedROIs)+1 0 1.5*max(os.amplitudes(:))]);
% for i=1:numel(os.origbetas)
%   if (pvaluem(i) < 0.05)
%     h = text(i,os.amplitudes(i,2)+0.10,'*');
%     set(h,'FontSize',20);
%   end
%   if (pvaluem(i) < 0.01)
%     h = text(i,os.amplitudes(i,2)+0.12,'*');
%     set(h,'FontSize',20);
%   end
%   if (pvaluem(i) < 0.001)
%     h = text(i,os.amplitudes(i,2)+0.14,'*');
%     set(h,'FontSize',20);
%   end
% end
% 
% 

