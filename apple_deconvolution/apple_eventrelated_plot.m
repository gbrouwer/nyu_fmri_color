function apple_eventrelated_plot

%Init and load
clc;
os = [];
load('apple_eventrelated.mat');
os.totalHRF = os.totalHRF*50;



%Task HRF
HRFtask = os.totalHRF(:,:,1:2:end,:,:);
HRFtask = squeeze(mean(HRFtask,3));
HRFtask = squeeze(mean(HRFtask,1));



%RSVP HRF
HRFrsvp = os.totalHRF(:,:,2:2:end,:,:);
HRFrsvp = squeeze(mean(HRFrsvp,3));
HRFrsvp = squeeze(mean(HRFrsvp,1));







%Fit Event-related response
Vtask = [];
Vrsvp = [];
for i=1:24
  Vtask = [Vtask mean(squeeze(HRFtask(i,:,:)),2)];
  Vrsvp = [Vrsvp mean(squeeze(HRFrsvp(i,:,:)),2)];
end



%Param
maxIter = inf;
xmin =  [1 4 0.25 0.25 1.5 0.001];
x0   =  [6 16 0.5 0.5 6 0.01];
xmax =  [9 20 1 1 9 0.1];
os.param.tr = 1.5;
os.param.hrflength = 12;
os.param.supersampling = 1;
nFit = size(Vtask,2);




%for i=1:nFit
for i=1:nFit
  
  
  %Fit
  estHRF = Vtask(:,i)';
  estHRF = estHRF ./ max(estHRF(:));
  
  estHRF = estHRF - estHRF(1);
  val = linspace(0,estHRF(end),numel(estHRF));
  estHRF = estHRF - val;
  estHRF = estHRF ./ max(estHRF(:));
  
    
  optimParams = optimset('MaxIter',maxIter,'Display', 'off');
  fitparam = lsqnonlin(@apple_hrfresidual_spm,x0,xmin,xmax,optimParams,estHRF,os);
  
  %Informed Basis function
  fitparam(end+1) = 24;
  [hrf,~,~] = apple_informedbasis(fitparam,os.param.tr,os.param.supersampling);
  hrf = hrf ./ max(hrf(:));
  hrf = hrf(1:numel(estHRF));
  fitval(1,i,:) = fitparam;
  
  
  
  %Fit
  estHRF = Vrsvp(:,i)';
  estHRF = estHRF ./ max(estHRF(:));
  
  estHRF = estHRF - estHRF(1);
  val = linspace(0,estHRF(end),numel(estHRF));
  estHRF = estHRF - val;
  estHRF = estHRF ./ max(estHRF(:));
  
  optimParams = optimset('MaxIter',maxIter,'Display', 'off');
  fitparam = lsqnonlin(@apple_hrfresidual_spm,x0,xmin,xmax,optimParams,estHRF,os);
  
  %Informed Basis function
  fitparam(end+1) = 24;
  [hrf,~,~] = apple_informedbasis(fitparam,os.param.tr,os.param.supersampling);
  hrf = hrf ./ max(hrf(:));
  hrf = hrf(1:numel(estHRF));
  fitval(2,i,:) = fitparam;  
end
  
fitval
%Save
save('apple_eventrelated_fit.mat','fitval');























return

%Base Names
names{1} = 'v1';
names{2} = 'v2';
names{3} = 'v3';
names{4} = 'v4v';
names{5} = 'vo1';
names{6} = 'vo2';
names{7} = 'v3ab';
names{8} = 'lo1';
names{9} = 'lo2';
names{10} = 'mtplus';


%Combine and average
for i=1:10
  HRFdataRSVP{i} = [];
  HRFdataTASK{i} = [];
  for j=1:numel(os.ROIs)
    if ~isempty((strfind(os.ROIs{j}.name,names{i})))
      if (i == 3 & j == 7 | i == 3 & j == 19)
      else
        HRFdataRSVP{i} = [HRFdataRSVP{i} squeeze(HRFrsvp(j,:,:))];
        HRFdataTASK{i} = [HRFdataTASK{i} squeeze(HRFtask(j,:,:))];
      end
    end
  end
  disp(' --- ');
end





%Plot
for i=1:10
  subplot(3,4,i);
  hold on; grid on; box on;
  mval = mean(HRFdataRSVP{i}');
  sval = std(HRFdataRSVP{i}');
  errorbar(mval,sval);

  mval = mean(HRFdataTASK{i}');
  sval = std(HRFdataTASK{i}');
  errorbar(mval,sval,'Color','r');
  title(names{i});
  axis([0 13 -0.25 0.5]);
end


% %Plot Average Activity
% for i=1:12
%   subplot(3,4,i);
%   val1 = squeeze(HRFrsvp(i,:,:));
%   val2 = squeeze(HRFrsvp(i+12,:,:));
%   rsvp = [val1 val2]';
%   errorbar(squeeze(mean(rsvp,1)),std(rsvp));
%   hold on;
%   val1 = squeeze(HRFtask(i,:,:));
%   val2 = squeeze(HRFtask(i+12,:,:));
%   task = [val1 val2]';
%   errorbar(squeeze(mean(task,1)),std(task),'Color','r');
%   title(os.ROIs{i}.name);
%   axis([0 13 -0.25 0.5]);
end


% 
% %Plot Color Specific Activity (RSVP)
% for i=2:14
%   subplot(4,4,i-1);
%   val1 = squeeze(HRFrsvp(i,:,:));
%   val2 = squeeze(HRFrsvp(i+14,:,:));
%   for j=1:12
%      hrf = mean([val1(:,j) val2(:,j)],2);
%      plot(hrf,'Color',os.RGB(j,:));
%      hold on;
%   end
% end

% for i=1:12
%   subplot(5,5,i);
%   val1 = squeeze(HRFtask(i,:,:));
%   val2 = squeeze(HRFtask(i+12,:,:));
%   for j=1:12
%      hrf = mean([val1(:,j) val2(:,j)],2);
%      plot(hrf,'Color',os.RGB(j,:));
%      hold on;
%         axis([0 13 -0.25 0.5]);
%   end
% end
