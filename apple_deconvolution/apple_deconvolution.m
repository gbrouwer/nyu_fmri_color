function apple_deconvolution(session)


%Init Project
ds = [];
ds.rootdir = '/Local/Users/gbrouwer/Toolboxes/apple/';
ds.projectdir = '/Volumes/data/MRI-Saffron/';
ds.session = session;
ds.savename = [ds.rootdir 'apple_save/apple_' ds.session '.mat'];
ds.initialname = [ds.rootdir 'apple_initial/apple_' ds.session '.mat'];
algorithms.deconvolution_matrices = 1;
algorithms.deconvolve = 1;
algorithms.createhrfs = 1;


%Algorithms
ds = apple_initproject(ds);
ds = apple_deconvolution_matrices(ds,algorithms);
ds = apple_deconvolve(ds,algorithms);
ds = apple_createhrfs(ds,algorithms);



