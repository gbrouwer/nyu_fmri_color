function hrfresidual = sage_hrfresidual(params,refhrf,ds)


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
hrf = interp1(t, hrf, ds.param.tr/2:ds.param.tr/2:max(t));
hrf = hrf - mean(hrf);
if (max(hrf) == 0)
else
    hrf = hrf ./ max(hrf);
end


%Calculate Residual
hrf = hrf(1:numel(refhrf));
hrfresidual =  refhrf  - hrf;
