function os = apple_auxiliary_statistics(os,level)


%Loop through ROIs
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
  val = isinf(RSVPr);
  RSVPr(val) = 0;
  val = isinf(TASKr);
  TASKr(val) = 0;
  betas(betas > 0.1) = 0;
  betas(betas < 0.0) = 0;
  TASKbetas = betas(1:2:end,:);
  RSVPbetas = betas(2:2:end,:);

  
  %Restrict SNR level for TASK
  val = TASKr < prctile(TASKr,level);
  TASKbetas = TASKbetas(:,val);
  
  
%   %Constrain   
%   constrain = (TASKr > prctile(TASKr,50));
%   TASKbetas = TASKbetas(:,constrain);
%   TASKr = TASKr(constrain);
%   RSVPbetas = RSVPbetas(:,constrain);  
%   RSVPr = RSVPr(constrain);

  %Calculate SNR
  RSVPmean = nanmean(RSVPbetas);
  RSVPstd = nanstd(RSVPbetas);
  RSVPsnr = RSVPmean ./ RSVPstd;
  dum = isnan(RSVPsnr);
  RSVPsnr(dum) = 0;
  TASKmean = nanmean(TASKbetas);
  TASKstd = nanstd(TASKbetas);
  
  
  TASKsnr = TASKmean ./ TASKstd;
  dum = isnan(TASKsnr);
  TASKsnr(dum) = 0;
  dum = (TASKsnr > 250);
  TASKsnr(dum) = 250;
  
  %Average Across sessions
  for i=1:max(labels)
    dum = (labels == i);
    os.amplitudes(i,m,1) = mean(mean(RSVPbetas(:,dum)));
    os.amplitudes(i,m,2) = mean(mean(TASKbetas(:,dum)));
    os.rsquares(i,m,1) = mean(mean(RSVPr(:,dum)));
    os.rsquares(i,m,2) = mean(mean(TASKr(:,dum)));
    os.snr(i,m,1) = mean(RSVPsnr(:,dum));
    os.snr(i,m,2) = mean(TASKsnr(:,dum));
  end
  
end

st = [];
st.amplitudes = os.amplitudes;
st.rsquares = os.rsquares;
st.snr = os.snr;
%save(['apple_statistics/apple_balance_' os.subject '_' num2str(level) '.mat'],'st');



%Save Measures for Statistical Testing
load(['apple_statistics/apple_measures_' os.subject '_' num2str(level) '.mat'],'st');
st.amplitudes = os.amplitudes;
st.rsquares = os.rsquares;
st.snr = os.snr;
save(['apple_statistics/apple_measures_' os.subject '_' num2str(level) '.mat'],'st');
