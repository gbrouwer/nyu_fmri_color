function os = apple_algemate_tuningcurves(os,level)

for m=1:numel(os.origbetas)
   
  %Verbose
  disp(['Fitting curves of : ' os.ROInames{m}]);
  
  
  %Get data
  labels = os.sessionlabels{m};
  betas = os.origbetas{m};
  os.runlabels = sort(repmat(1:6,1,12));
  TASKbetas = betas(apple_isodd(os.runlabels),:) .* 100;
  RSVPbetas = betas(apple_iseven(os.runlabels),:) .* 100;
  nVox = size(TASKbetas,2);
  
  
  %Reshape data
  TASKbetas = reshape(TASKbetas,12,3,nVox);
  TASKbetas = squeeze(mean(TASKbetas,2));
  RSVPbetas = reshape(RSVPbetas,12,3,nVox);
  RSVPbetas = squeeze(mean(RSVPbetas,2));

  
  %Remove Mean signal
  meanTASK = mean(TASKbetas,2);
  meanRSVP = mean(RSVPbetas,2);
  W = inv(meanTASK'*meanTASK)*meanTASK'*TASKbetas;
  P = meanTASK * W;
  TASKbetas = TASKbetas - P;
  W = inv(meanRSVP'*meanRSVP)*meanRSVP'*RSVPbetas;
  P = meanRSVP * W;
  RSVPbetas = RSVPbetas - P;

  

  
  %------------------------------------------------------------------------
  %Fit voxels TASK
  %------------------------------------------------------------------------
  fitparam = [];
  rsquare = [];
  angles = linspace(-pi,pi,13);
  angles = angles(1:end-1);
  xmin  = [-pi 0.0000 0.0 -10.00];
  x0    = [0 1.0000 0.4 +0.00];                
  xmax  = [pi 50.000 10.0 +10.00];
  optimParams = optimset('MaxIter',Inf,'Display', 'off');
  
  %Fit
  parfor j=1:nVox
    voxcurve = TASKbetas(:,j)';
    fitparam(j,:) = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,voxcurve,angles); 
  end

  %Recreate and calculate r-square
  parfor j=1:nVox
    voxcurve = TASKbetas(:,j)';
    fitcurve = (exp(fitparam(j,2).*(cos(angles-fitparam(j,1))))) ./ (2.*pi.*besseli(0,fitparam(j,2)));
    fitcurve = (fitcurve .* fitparam(j,3)) + fitparam(j,4);
    rsquare(j) = corr2(voxcurve,fitcurve);
  end

  %fitparam(voxno,:)
  %voxcurve = TASKbetas(:,voxno);
  %h = scatter(angles,voxcurve,'filled');
  %set(h,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
  %curve = (exp(fitparam(voxno,2).*(cos(linspace(-pi,pi,360)-fitparam(voxno,1))))) ./ (2.*pi.*besseli(0,fitparam(voxno,2)));
  %curve = (curve .* fitparam(voxno,3)) + fitparam(voxno,4);
  %hold on;
  %plot(linspace(-pi,pi,360),curve,'r');

  %Store
  fitparam(:,5) = rsquare;
  ts.TASKfitparam{m} = fitparam;
  ts.param = os.param;




  %------------------------------------------------------------------------
  %Fit voxels RSVP
  %------------------------------------------------------------------------
  fitparam = [];
  rsquare = [];
  optimParams = optimset('MaxIter',Inf,'Display', 'off');
  parfor j=1:nVox
    voxcurve = RSVPbetas(:,j)';
    fitparam(j,:) = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,voxcurve,angles); 
  end

  %Recreate and calculate r-square
  parfor j=1:nVox
    voxcurve = RSVPbetas(:,j)';
    fitcurve = (exp(fitparam(j,2).*(cos(angles-fitparam(j,1))))) ./ (2.*pi.*besseli(0,fitparam(j,2)));
    fitcurve = (fitcurve .* fitparam(j,3)) + fitparam(j,4);
    rsquare(j) = corr2(voxcurve,fitcurve);
  end


  %fitparam(voxno,:)
  %curve = (exp(fitparam(voxno,2).*(cos(linspace(-pi,pi,360)-fitparam(voxno,1))))) ./ (2.*pi.*besseli(0,fitparam(voxno,2)));
  %curve = (curve .* fitparam(voxno,3)) + fitparam(voxno,4);
  %voxcurve = RSVPbetas(:,voxno);
  %h = scatter(angles,voxcurve,'filled');
  %set(h,'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0]);
  %plot(linspace(-pi,pi,360),curve,'g');
  

  %Store
  fitparam(:,5) = rsquare;
  ts.RSVPfitparam{m} = fitparam;
  ts.param = os.param;
  ts.labels{m} = labels;
  

end

 
%Save and return
save(['apple_final/apple_' os.subject '-tuning_' num2str(level) '.mat'],'ts');
 











%--------------------------------------------------------------------------
function residual = apple_gaussian(params,curve,angles)


%Parameters
mu = params(1);
k = params(2);
amplitude = params(3);
offset = params(4);


%Create Curve
fitcurve = (exp(k.*(cos(angles-mu)))) ./ (2.*pi.*besseli(0,k));
fitcurve = (fitcurve .* amplitude) + offset;

%Fit
residual = curve - fitcurve;
