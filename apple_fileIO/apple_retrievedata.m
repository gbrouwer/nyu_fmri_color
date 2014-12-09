function ds = apple_retrievedata(ds,algorithms)

%Create or load the project
if (algorithms.retrievedata == 1)


    %Verbose
    disp(['Running apple_retrievedata']);
 
    
    %Delete Previous Views
    cd([ds.projectdir '/' ds.session]);
    mrGlobals;
    for i=1:max(size(MLR.views))
        deleteView(i);
    end
 
    
    %Find available ROIs
    cd('ROIs');
    fdir = dir;
    if (isfield(ds,'ROIs') == 0)
        nRois = 0;
    else
        nRois = numel(ds.ROIs);
    end
    nNewRois = 0;
    for i=3:max(size(fdir))
        fname = fdir(i).name;
        if (~isempty(strfind(fname,'mat')))

            %Check whether this ROI already exists in the ds.ROIs structure
            if (nRois > 0)
                    roifound = 0;
                    for p=1:nRois
                        if (strcmp(ds.ROIs{p}.name,fname(1:end-4)))
                            roifound = 1;
                        end
                    end
                    if (roifound == 0)
                        nRois = nRois + 1;
                        nNewRois = nNewRois + 1;
                        ds.ROIs{nRois}.name = fname(1:end-4);
                    end
            end
            if (nRois == 0)
                nNewRois = nNewRois + 1;
                nRois = nRois + 1;
                ds.ROIs{nRois}.name = fname(1:end-4);
            end
        end
    end
    cd ..
    ds.param.nROIs = nRois;

    
    %Extract data from ROIs
    v = newView('Volume');
    ds.param.slicetimes = viewGet(v,'slicetimes') * ds.param.tr;
    for r=1:ds.param.nROIs-nNewRois+1:ds.param.nROIs
        disp(['     Extracting data from ROI : ' ds.ROIs{r}.name]);
        for i=1:ds.param.nRuns

            %Load ROI mat file to check for inconsistencies
            cd('ROIs');
            load(ds.ROIs{r}.name);
            string = ['realROI=' ds.ROIs{r}.name ';'];
            eval(string);
            cd ..
            
            %Saved Scancoords method
            ROI = ds.ROIs{r}.name;
            loadname = ['Freesurfer/' ds.ROIs{r}.name '_scancoords.mat'];
            load(loadname);
            [~,nVoxels] = size(scanCoords);
            scanCoords(scanCoords < 1) = 1;
            dum = scanCoords(3,:) > ds.param.dataSize(3);
            scanCoords(3,dum) = ds.param.dataSize(3);
            
            %minVal = min(scanCoords');
            %maxVal = max(scanCoords');
            %y = [];
            %subset = {[minVal(1) maxVal(1)],[minVal(2) maxVal(2)],[minVal(3) maxVal(3)],[]};
            %Y = cbiReadNifti(ds.run{i}.filename,subset);
            %for n=1:nVoxels
            %  coords = scanCoords(1:3,n)' - minVal(1:3) + 1;
            %  y = [y ; squeeze(Y(coords(1),coords(2),coords(3),:))'];
            %end
            %dum = isnan(y);
            %y(dum) = 0;
            
            %Read raw data
            ROI = ds.ROIs{r}.name;
            rois = apple_loadROITSeries(v,ROI,i,3,'keepNAN',true,'matchScanNum=1','matchGroupNum=4');
            dum = isnan(rois.tSeries);
            rois.tSeries(dum) = 0;
            ds.ROIs{r}.run{i}.rawdata = rois.tSeries';

        end

        
        %Get Flatmap coordinates
        cd('Freesurfer');
        loadname = [ROI '_flat.mat'];
        if strcmp(ROI(1:2),'lh')
          plotno = 1;
        else
          plotno = 2;
        end
        load(loadname);
        cd ..
      
        
        %Store coordinates
        ds.ROIs{r}.scan2roi = scan2roi;
        ds.ROIs{r}.coords = rois.coords;
        ds.ROIs{r}.scancoords = rois.scanCoords;
        ds.ROIs{r}.xform = rois.xform;
        ds.ROIs{r}.flatMapCoords = ts.flatMapCoords;
        
    end
     
    
    %Save and Return
    save(ds.savename,'ds');
    save(ds.initialname,'ds');
    cd([ds.rootdir]);
    
end
