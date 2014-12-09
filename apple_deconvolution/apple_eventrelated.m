function os = apple_eventrelated(session,os)


%Init Project
disp(session)
ds = [];
ds.rootdir = '/Local/Users/gbrouwer/Toolboxes/apple/';
ds.projectdir = '/Volumes/data/MRI-Saffron/';
ds.session = session;
ds.savename = [ds.rootdir 'apple_save/apple_' ds.session '.mat'];
ds.initialname = [ds.rootdir 'apple_initial/apple_' ds.session '.mat'];
ds = apple_initproject(ds);



%Loop to obtain event-related response
matrixHRF = [];
for j=1:ds.param.nROIs
  for i=1:10
    %Get, Transform, Constrain and Average
    os.ROIs{j}.name = ds.ROIs{j}.name;
    HRFs = ds.ROIs{j}.run{i}.deconv.HRFc;
    nVox = size(HRFs,2);
    rsquare = ds.ROIs{j}.run{i}.deconv.HRFrsquarec;
    HRFs = reshape(HRFs,12,12,nVox);
    val = (rsquare > prctile(rsquare,50));
    HRFs = HRFs(:,:,val);
    HRFs = squeeze(mean(HRFs,3));

    %Store
    matrixHRF(j,i,:,:) = HRFs;
  end
end
os.RGB = ds.param.RGB;
os.count = os.count + 1;
os.totalHRF(os.count,:,:,:,:) = matrixHRF;