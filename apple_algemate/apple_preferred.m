function apple_preferred


%Init
clc;
load('cerulean_LCD at scanner - 10262010');
load('apple_statistics/apple_preferred.mat','tasktuning','rsvptuning','param');



% %Correspondence
% angles = linspace(-pi,pi,13);
% angles = angles(1:end-1);
% xmin  = [-pi 0.0000 0.0 -10.00];
% x0    = [0 1.0000 0.4 +0.00];                
% xmax  = [pi 50.000 10.0 +10.00];
% optimParams = optimset('MaxIter',Inf,'Display', 'off');
% voxcurve = normpdf(1:12,6,2);
% voxcurve = circshift(voxcurve,[0 6]);
% 
% fitparam = lsqnonlin(@apple_gaussian,x0,xmin,xmax,optimParams,voxcurve,angles);
% fitparam
% 
% 
% 
% 
% 
% 
% 
% fitcurve = (exp(fitparam(2).*(cos(angles-fitparam(1))))) ./ (2.*pi.*besseli(0,fitparam(2)));
% fitcurve = (fitcurve .* fitparam(3)) + fitparam(4);
% rsquare = corr2(voxcurve,fitcurve)
% 
% scatter(1:12,voxcurve,'filled');
% hold on;
% plot(fitcurve);

 
ds.DKL = [];
angles = linspace(0,pi*2,13);
angles = angles(1:end-1);
ds.DKL(:,2) = sin(angles) * 0.25;
ds.DKL(:,3) = cos(angles) * 1.00;
ds = cerulean_DKL2ALL(ds);


hangles = linspace(-pi,pi,13);
hangles = hangles(1:12);


% 
% 
% 
v = hist(tasktuning{1},hangles);
scatter(hangles,v,50,ds.RGB,'filled');
hold on;
v = hist(rsvptuning{1},hangles);
scatter(hangles,v,50,ds.RGB,'filled');
plot(hangles,v);
hold on;

% 
% 
% %scatter(tasktuning{1},rsvptuning{1},'filled');




















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
