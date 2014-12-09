function [hrf,diffhrf] = apple_hrfdiffgamma_spm(params,refhrf,ds)

%Init
p = params;
p(7) = ds.param.hrflength * ds.param.tr;


%Calculate HRF
dt  = ds.param.tr/ds.param.supersampling;
u   = [0:(p(7)/dt)] - p(6)/dt;
hrf = apple_gpdf(u,p(1)/p(3),dt/p(3)) - apple_gpdf(u,p(2)/p(4),dt/p(4))/p(5);
 

%Derivative
hrf = hrf'/max(hrf);
diffhrf = [0 diff(hrf)'];
diffhrf = diffhrf - mean(diffhrf);
diffhrf = diffhrf ./ norm(diffhrf');
diffhrf = diffhrf ./ max(diffhrf);


%Restrict
hrf = hrf(1:numel(refhrf));
diffhrf = diffhrf(1:numel(refhrf));
