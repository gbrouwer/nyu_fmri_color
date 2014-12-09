function apple_motionestimates(session)


%Init Project
ds = [];
ds.rootdir = '/Local/Users/gbrouwer/Toolboxes/apple/';
if (str2num(session(end)) < 3)
  ds.projectdir = '/Volumes/data/MRI-Saffron/';
else
  ds.projectdir = '/Volumes/storage/MRI-Apple/';
end
ds.session = session;
ds.savename = [ds.rootdir 'apple_save/apple_' ds.session '.mat'];
ds.initialname = [ds.rootdir 'apple_initial/apple_' ds.session '.mat'];
algorithms.logfiles = 1;
algorithms.getmotionestimates = 1;



%Algorithms
ds = apple_initproject(ds);
ds = apple_getmotionestimates(ds,algorithms);


