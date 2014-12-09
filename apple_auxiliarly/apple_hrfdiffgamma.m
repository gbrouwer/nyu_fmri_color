function [hrf,diffhrf,ds] = sage_hrfdiffgamma(params,ds)


%Assign Parameters
ds.hrfparams.x = params(1);
ds.hrfparams.y = params(2);
ds.hrfparams.z = params(3);


%Create HRF
dt = 0.01;
tmax = max(ds.hrfparams.y, 32);
warning off;
hrf = gampdf(0:dt:tmax, ds.hrfparams.x , 1) - gampdf(0:dt:tmax, tmax, 1)/ds.hrfparams.z;
hrf = convn(hrf, ones(1, max(1, ceil(ds.param.tr(1)))));
warning on;
t = [0:length(hrf)-1]*dt;
diffhrf = [diff(hrf)];
diffhrf(end) = diffhrf(end-1);
diffhrf = [diffhrf diffhrf(end)];
diffhrf = interp1(t, diffhrf,ds.param.tr/2:ds.param.tr/2:max(t));
diffhrf = diffhrf - mean(diffhrf);
diffhrf = diffhrf ./ norm(diffhrf');
diffhrf = diffhrf ./ max(diffhrf);
hrf = interp1(t, hrf, ds.param.tr/2:ds.param.tr/2:max(t));
hrf = hrf - mean(hrf);
hrf = hrf - hrf(1);
hrf = hrf ./ max(hrf);



