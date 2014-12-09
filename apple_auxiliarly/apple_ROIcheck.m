function apple_ROIcheck

%Init and Load
clc;
path = cd;
load('/Local/Users/gbrouwer/Toolboxes/Apple/apple_initial/apple_sj_04162014.mat');
map = zeros(104,80,24);


%Fill with ROI coordinates
for i=1:numel(ds.ROIs)
  coords = ds.ROIs{i}.scancoords;
  nVoxels = size(coords,2);
  for v=1:nVoxels
    map(coords(1,v),coords(2,v),coords(3,v)) = i;
  end
end


mrDispOverlay(map,1,4);