function apple_cleanup(session)


%Init and load Project
ds = [];
ds.rootdir = '/Local/Users/gbrouwer/Toolboxes/apple/';
ds.projectdir = '/Volumes/data/MRI-apple/';
ds.session = session;
ds.savename = [ds.rootdir 'apple_save/apple_' ds.session '.mat'];
ds.initialname = [ds.rootdir 'apple_initial/apple_' ds.session '.mat'];
ds = apple_initproject(ds);



%Loop through ROIs
for r=1:numel(ds.ROIs)
  disp(ds.ROIs{r}.name);
  for l=1:numel(ds.ROIs{r}.run)
    Y = ds.ROIs{r}.run{l}.rawdata;
    dum = (std(Y) == 0);
    G = Y(:,~dum);
    Yreplace = mean(G,2);
    nBadSignals = sum(dum);
    disp(['   Number of bad signals: ' num2str(nBadSignals)]);
    Yreplace = repmat(Yreplace,1,nBadSignals);
    Y(:,dum) = Yreplace;
    ds.ROIs{r}.run{l}.rawdata = Y;
  end
end


%Save
save(ds.savename,'ds');