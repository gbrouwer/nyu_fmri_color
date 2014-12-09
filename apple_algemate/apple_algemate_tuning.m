function apple_algemate_tuning(subject)

%Save and return
clc;
os = [];
st = [];
load(['apple_final/apple_' subject '-tuning.mat'],'ts');
xmin  = [0.0000 0 -10];
x0    = [1.0000 1 0];                
xmax  = [150.000 100 10];
optimParams = optimset('MaxIter',Inf,'Display', 'off');
degangles = linspace(0,360,361);
degangles = degangles(1:end-1);



%Names
os.ROInames{1} = 'V1';
os.ROInames{2} = 'V2';
os.ROInames{3} = 'V3';
os.ROInames{4} = 'hV4v';
os.ROInames{5} = 'VO1';
os.ROInames{6} = 'VO2';
os.ROInames{7} = 'V3AB';
os.ROInames{8} = 'LO1';
os.ROInames{9} = 'LO2';
os.ROInames{10} = 'hMT+';





%Calculate Tuning Width
for i=1:numel(ts.TASKfitparam)

  
  %Get Data
  labels = ts.labels{i};
  task = ts.TASKfitparam{i};
  rsvp = ts.RSVPfitparam{i};

  %Reset
  task(:,5) = task(:,5).^2;
  rsvp(:,5) = rsvp(:,5).^2;
  dum = (task(:,5) < 0.001);
  task(dum,5) = 0.001;

  %Remove inconsistent voxels
  difference = abs(circ_dist(task(:,1),rsvp(:,1)));
  dum = (difference < pi/2);
  task = task(dum,:);
  rsvp = rsvp(dum,:);
  labels = labels(dum);

  %Convert from K to sigma
  task(:,2) = 1 ./ task(:,2);
  rsvp(:,2) = 1 ./ rsvp(:,2);

  %Remove outliers
  dum1 = (task(:,2) < 1);
  dum2 = (rsvp(:,2) < 1);
  dum = sum([dum1 dum2],2);
  dum = (dum == 0);
  task = task(dum,:);
  rsvp = rsvp(dum,:);
  labels = labels(dum,:);
  dum1 = (task(:,2) > 1000);
  dum2 = (rsvp(:,2) > 1000);
  dum = sum([dum1 dum2],2);
  dum = (dum == 0);
  task = task(dum,:);
  rsvp = rsvp(dum,:);
  labels = labels(dum,:);
  
  %Create Gain
  nVox = size(task,1);
  gaintask = [];
  tasktuning{i} = task(:,1);
  for v=1:nVox
    fitparam = task(v,1:4);
    fitparam(2) = 1./fitparam(2);
    fitcurve = (exp(fitparam(2).*(cos(linspace(-pi,pi,100))))) ./ (2.*pi.*besseli(0,fitparam(2)));
    fitcurve = (fitcurve .* fitparam(3)) + fitparam(4);
    gaintask(v) = max(fitcurve) - min(fitcurve);
  end
  gainrsvp = [];
  rsvptuning{i} = rsvp(:,1);
  for v=1:nVox
    fitparam = rsvp(v,1:4);
    fitparam(2) = 1./fitparam(2);
    fitcurve = (exp(fitparam(2).*(cos(linspace(-pi,pi,100)-fitparam(1))))) ./ (2.*pi.*besseli(0,fitparam(2)));
    fitcurve = (fitcurve .* fitparam(3)) + fitparam(4);
    gainrsvp(v) = max(fitcurve) - min(fitcurve);
  end  

  for m=1:max(labels)
    dum = (labels == m);
    ds.width(m,i,1) = mean(rsvp(dum,2));
    ds.width(m,i,2) = mean(task(dum,2));
    ds.gain(m,i,1) = mean(gainrsvp(dum));
    ds.gain(m,i,2) = mean(gaintask(dum));
  end


  
end


%Remove NaNs
mval = nanmean(ds.gain(:));
dum = isnan(ds.gain(:));
ds.gain(dum) = mval;
mval = nanmean(ds.width(:));
dum = isnan(ds.width(:));
ds.width(dum) = mval;






%Save Measures for Statistical Testing
load(['apple_statistics/apple_measures_' subject '.mat']);
st.width = ds.width;
st.gain = ds.gain;
param = ts.param;
save(['apple_statistics/apple_measures_' subject '.mat'],'st','tasktuning','rsvptuning','param');





















































%   
% 
%   
%   
%   
%   
%   %For Anova
%   for a=1:10
%     thisdum = (labels == a);
%     list1 = task(thisdum,2);
%     list2 = rsvp(thisdum,2);
%     y = [y mean(list1) mean(list2)];
%     list1 = gaintask(thisdum);
%     list2 = gainrsvp(thisdum);
%     yg = [yg mean(list1) mean(list2)];
%     list1 = task(thisdum,4);
%     list2 = rsvp(thisdum,4);
%     yo = [yo mean(list1) mean(list2)];
%     gtask = [gtask {'task','rsvp'}];
%     garea = [garea {os.ROInames{i} os.ROInames{i}}];
%   end
% 
%   
%   
%   
%   %Permutation Test
%   difference = [];
%   for p=1:100
%     list1 = task(:,2);
%     list2 = rsvp(:,2);
%     randval = randperm(numel(task(:,1)));
%     index1 = randval(1:floor(numel(list1)/2));
%     index2 = randval(floor(numel(list1)/2)+1:end);
%     tmp1 = [list1(index1) ; list2(index1)];
%     tmp2 = [list1(index2) ; list2(index2)];
%     difference(p) = median(tmp1) - median(tmp2);
%   end
%   median(task(:,4)) - median(rsvp(:,4));
%   %prctile(difference,99)
% %   
% %   task
% %   scatter(task(:,4),rsvp(:,4),'filled');
% %   
% %   
% %   
%   
%   
% 
%   
%   %Mean/Std Tuning Width
%   nVox = size(task,1);
%   mrsvp(i) = median(rsvp(:,2));
%   mtask(i) = median(task(:,2));
%   srsvp(i) = std(rsvp(:,2));
%   stask(i) = std(task(:,2));
%   [h,p,ci,stats] = ttest(task(:,2),rsvp(:,2));
%   vgrsvp(i) = median(gainrsvp);
%   vgtask(i) = median(gaintask);
%   vgsrsvp(i) = std(gainrsvp);
%   vgstask(i) = std(gaintask);
% 
% 
% 
%   
%   
%   %Fit RSVP with gaussian
%   fitparam = [0 1/mrsvp(i) 1 0];
%   angles = linspace(-pi,pi,360);
%   fitcurve = (exp(fitparam(2).*(cos(angles-fitparam(1))))) ./ (2.*pi.*besseli(0,fitparam(2)));
%   gaussparam = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,fitcurve,degangles);
%   gcurve = (normpdf(degangles,180,gaussparam(1)) .* gaussparam(2)) + gaussparam(3);
%   param(i,1) = gaussparam(1);
%   
%   %Fit TASK with gaussian
%   fitparam = [0 1/mtask(i) 1 0];
%   angles = linspace(-pi,pi,360);
%   fitcurve = (exp(fitparam(2).*(cos(angles-fitparam(1))))) ./ (2.*pi.*besseli(0,fitparam(2)));
%   gaussparam = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,fitcurve,degangles);
%   gcurve = (normpdf(degangles,180,gaussparam(1)) .* gaussparam(2)) + gaussparam(3);
%   param(i,2) = gaussparam(1);
% 
% end
% 
% 
% 
% 
% %Bar Graph
% subplot(2,2,1);
% multiplier = 1 ./ mean([mrsvp./param(:,1)' mtask./param(:,2)']);
% mrsvp = mrsvp * multiplier;
% mtask = mtask * multiplier;
% handles = apple_barweb([mrsvp' mtask'],[srsvp' stask'],1,os.ROInames,'Tuning Widths','Visual area','Sigma (degrees)');
% box on;grid on;axis([0 11 0 150]);
% 
% 
% subplot(2,2,2);
% handles = apple_barweb([vgrsvp' vgtask'],[vgsrsvp' vgstask'],1,os.ROInames,'Gain','Visual area','Gain (% Signal change)');
% box on;grid on;axis([0 11 0 0.5]);
% 
% 
% %2-way Anova
% anovan(y,{gtask garea},'model',2,'sstype',2,'varnames',{'task';'areas'})
% anovan(yg,{gtask garea},'model',2,'sstype',2,'varnames',{'task';'areas'})
% anovan(yo,{gtask garea},'model',2,'sstype',2,'varnames',{'task';'areas'})
% 
% 
% 
% 
% 
% %--------------------------------------------------------------------------
% function residual = apple_gaussian(params,curve,angles)
% 
% 
% %Parameters
% sigma = params(1);
% amplitude = params(2);
% offset = params(3);
% 
% 
% %Create Curve
% fitcurve = (normpdf(angles,180,sigma) .* 5) + offset;
% 
%  
% %Fit
% residual = curve - fitcurve;
