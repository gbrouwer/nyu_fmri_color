function apple_estimation(session)


%Init Project
ds = [];
ds.rootdir = '/Local/Users/gbrouwer/Toolboxes/apple/';
ds.projectdir = '/Volumes/data/MRI-Saffron/';
ds.session = session;
ds.savename = [ds.rootdir 'apple_save/apple_' ds.session '.mat'];
ds.initialname = [ds.rootdir 'apple_initial/apple_' ds.session '.mat'];
algorithms.designmatrices = 1;
algorithms.estimate = 1;



%Algorithms
ds = apple_initproject(ds);
ds = apple_designmatrices(ds,algorithms);
ds = apple_estimate(ds,algorithms);
