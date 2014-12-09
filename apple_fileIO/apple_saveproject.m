function apple_saveproject(session)


%Init Project
ds = [];
disp(['----------------']);
ds.rootdir = '/Local/Users/gbrouwer/Toolboxes/apple/';
ds.projectdir = '/Volumes/data/MRI-apple/';
ds.session = session;
ds.savename = [ds.rootdir 'apple_save/apple_' ds.session '.mat'];
ds.initialname = [ds.rootdir 'apple_initial/apple_' ds.session '.mat'];
algorithms.logfiles = 1;
algorithms.save = 1;



%Algorithms
ds = apple_initproject(ds);



%ROIs
ds.saveROIs{1} = 'rh_v1';
ds.saveROIs{2} = 'rh_v2';
ds.saveROIs{3} = 'rh_v3';
ds.saveROIs{4} = 'rh_v3ab';
ds.saveROIs{5} = 'rh_v4v';
ds.saveROIs{6} = 'rh_vo1';
ds.saveROIs{7} = 'rh_vo2';
ds.saveROIs{8} = 'rh_lo1';
ds.saveROIs{9} = 'rh_lo2';
ds.saveROIs{10} = 'rh_mtplus';


%Save
ds = apple_save(ds,algorithms);


