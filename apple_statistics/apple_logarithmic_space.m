function values = apple_logarithmic_space(minval,maxval,nSteps)

%Create contrasts with equal spacing in logspace
startval = log(minval);
endval = log(maxval);
values = linspace(startval,endval,nSteps);
values = exp(values);
