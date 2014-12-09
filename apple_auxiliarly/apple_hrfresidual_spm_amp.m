function residual = apple_hrfresidual_spm_amp(params,refhrf,ds)


%Init
p = params;
p(8) = ds.param.hrflength * ds.param.tr;


%Calculate HRF
dt  = ds.param.tr/ds.param.supersampling;
u   = [0:(p(8)/dt)] - p(6)/dt;
hrf = apple_gpdf(u,p(1)/p(3),dt/p(3)) - apple_gpdf(u,p(2)/p(4),dt/p(4))/p(5);


%Restrict and calculate residual
hrf = hrf'/max(hrf);
hrf = hrf .* p(7);
hrf = hrf(1:numel(refhrf))';
residual =  refhrf  - hrf;

