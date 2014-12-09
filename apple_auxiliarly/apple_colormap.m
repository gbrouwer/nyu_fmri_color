function thismap = apple_colormap(ds,conmatrix)


%Color coding of the confusion matrix
cmap = zeros(ds.param.nClasses,ds.param.nClasses,3);
amap = zeros(ds.param.nClasses,ds.param.nClasses,3);
gmap = zeros(ds.param.nClasses,ds.param.nClasses,3) + 0.5;
for i=1:ds.param.nClasses
  cmap(i,:,1) = ds.param.RGB(i,1);
  cmap(i,:,2) = ds.param.RGB(i,2);
  cmap(i,:,3) = ds.param.RGB(i,3);
end  
amap(:,:,1) = conmatrix;
amap(:,:,2) = conmatrix;
amap(:,:,3) = conmatrix;
thismap = amap .* cmap + (1-amap) .* gmap;
 
