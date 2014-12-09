function ds = apple_createfilter(ds)


%Create Filter
if (ds.designmatrix_filtering == 1)
  n = ds.nVols;
  cutoff = 0.0100;
  freqmax = 1/(2*ds.param.tr);
  freqmin = 1/(n*ds.param.tr);
  freqdelta = 1/(n*ds.param.tr);
  freqs = 0:freqdelta:(freqdelta*(n-1));
  times = 0:ds.param.tr:(ds.param.tr*(n-1));
  hipassfilter = ones(1,ds.nVols);
  hipassfilter(freqs<cutoff) = 0;
  smoothedge = 1-apple_eventRelatedGauss([1 cutoff cutoff/2 0],freqs);
  hipassfilter(find(freqs>cutoff)) = smoothedge(freqs>cutoff);
  if (apple_isodd(n))
      hipassfilter(n:-1:(round(n/2)+1)) = hipassfilter(2:round(n/2));
  else
      hipassfilter(n:-1:(n/2+2)) = hipassfilter(2:n/2);
  end  
  ds.param.hipassfilter = hipassfilter;
  ds.param.hipassfilter(1) = 1;

else
  
  ds.param.hipassfilter = ones(1,ds.nVols);
  
end
