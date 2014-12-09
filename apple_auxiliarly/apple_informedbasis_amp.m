function [hrf,temporal,dispersion] = apple_informedbasis_amp(p,rt,supersampling)


%Create Canonical
rt = rt / supersampling;
[bf,p] = apple_spmhrf(rt,p);


%Create Temporal
dp = 1;
p(6) = p(6) + dp;
D = (bf(:,1) - apple_spmhrf(rt,p))/dp;
bf = [bf D(:)];
p(6) = p(6) - dp;


%Create Dispersion
dp    = 0.01;
p(3)  = p(3) + dp;
D     = (bf(:,1) - apple_spmhrf(rt,p))/dp;
bf    = [bf D(:)];


%Return
hrf = bf(:,1);
temporal = bf(:,2);
dispersion = bf(:,3);
hrf = hrf .* p(7);



%--------------------------------------------------------------------------
function [hrf,p] = apple_spmhrf(RT,p)



%Create HRF
fMRI_T = 16;
dt    = RT/fMRI_T;
u     = [0:(p(7)/dt)] - p(6)/dt;
hrf   = apple_gpdf(u,p(1)/p(3),dt/p(3)) - apple_gpdf(u,p(2)/p(4),dt/p(4))/p(5);
hrf   = hrf([0:(p(7)/RT)]*fMRI_T + 1);
hrf   = hrf'/sum(hrf);
