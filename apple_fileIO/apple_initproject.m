function ds = apple_initproject(ds)


%Verbose
disp(['Running apple_initproject']);

%Check Existence
if (exist(ds.savename) == 2)

    %Load Session
    load(ds.savename,'ds');
    
else
    
    %Access directory
    cd([ds.projectdir '/' ds.session]);
    

    %Delete previous mrViews
    mrGlobals;
    for i=1:max(size(MLR.views))
        deleteView(i);
    end

         
    %Obtain information from view
    load('mrSession.mat');
    ds.sessioninfo = session;
    ds.param.nRuns = numel(groups(3).scanParams);
    ds.param.dataSize = groups(1).scanParams(1).dataSize;
    ds.param.tr = groups(1).scanParams(1).framePeriod;
    ds.param.nVol = groups(1).scanParams(1).nFrames;
    ds.param.skip = groups(1).scanParams(1).junkFrames;
    ds.param.voxelSize = groups(1).scanParams(1).voxelSize;
  
    

    %Save and Return
    save(ds.savename,'ds');
    save(ds.initialname,'ds');
    cd([ds.rootdir]);

end
