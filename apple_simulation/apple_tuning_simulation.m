function apple_tuning_simulation


%Init
clc
noiselevel = 0.05;
xmin  = [-pi 0.0000 -10.0 -1.00];
x0    = [0 1.0000 10.0 +0.00];                
xmax  = [pi 1000.000 500.0 +1.00];
angles = linspace(-pi,pi,361);
angles = angles(1:end-1);
optimParams = optimset('MaxIter',Inf,'Display', 'off');








%Create Curve
for i=50:100
  mu = 180;
  sigma = i;

  gcurve = normpdf(angles,0,sigma/180*pi);
  gcurve = circshift(gcurve,[0 mu-180]);

  subplot(2,2,1);
  plot(angles,gcurve)
  hold on;


%Fit Curve
fitparam = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,gcurve,angles); 
fitcurve = exp(fitparam(2).*(cos(angles-fitparam(1)))) ./ (2.*pi.*besseli(0,fitparam(2)));
  
subplot(2,2,2);
  plot(angles,fitcurve)
  hold on;

  
  
%plot(angles,fitcurve,'r');
  list(i,1) = sigma;
  list(i,2) = 1./fitparam(2);
end
figure;
scatter(list(:,1),list(:,2),'filled');
% % 
% % % 
% % % 
% % % %Create Curve
% % % mu = 180;
% % % sigma = 100;
% % % 
% % % 
% % % gcurve = normpdf(angles,0,sigma/180*pi);
% % gcurve = circshift(gcurve,[0 mu-180]);
% % gcurve = gcurve + min(gcurve);
% % gcurve = gcurve ./ max(gcurve);
% % plot(angles,gcurve)
% % 
% % 
% % %Fit Curve
% % fitparam = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,gcurve,angles); 
% % fitparam
% % 
% % %Recreate Curve
% % fitcurve = ((exp(fitparam(2).*(cos(angles-fitparam(1))))).*fitparam(3)) + fitparam(4);
% % hold on;
% % plot(angles,fitcurve,'r');
% % 
% 
% 
% % %Run Simulation
% % fullcurve = [];
% % nloops = 10;
% % for j=1:nloops
% %   disp(j);
% %   noiselevel = j/nloops;
% %   c = j/nloops;
% %   for i=1:100
% % 
% %     %Create Random Curve
% %     param(1) = 0;
% %     param(2) = 2;
% %     param(3) = 1;
% %     param(4) = 0;
% %     fitcurve = ((exp(param(2).*(cos(angles-param(1))))).*param(3)) + param(4);
% % 
% %     %Add Noise
% %     noise = normrnd(0,noiselevel,size(fitcurve));
% %     fitcurve = fitcurve + noise;
% % 
% %     %Fit
% %     fitparam(i,:) = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,fitcurve,angles); 
% % 
% % 
% %     %Recreate at center
% %     fullcurve = [fullcurve ; (exp(fitparam(i,2).*(cos(linspace(-pi,pi,360)))))];
% % 
% %   end
% %   fullcurve = squeeze(mean(fullcurve,1));
% %   mval(j,:) = mean(fitparam);
% %   plot(fullcurve,'Color',[c 1-c 0.5]);
% %   hold on;
% % end
% % 
% % 
% % figure;
% % plot(mval)
% % 
% % mval
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



%--------------------------------------------------------------------------
function residual = apple_gaussian(params,curve,angles)


%Parameters
mu = params(1);
k = params(2);
amplitude = params(3);
offset = params(4);


%Create Curve
fitcurve = (exp(k.*(cos(angles-mu)))) ./ (2*pi*besseli(0,k));
fitcurve = fitcurve;

%Fit
residual = curve - fitcurve;
