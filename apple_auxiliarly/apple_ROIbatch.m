function apple_ROIbatch

fdir = dir;
d2 = size(fdir,1);
for i=10:15
  if (fdir(i).isdir)
    cd(fdir(i).name);
    path = cd;
    thisname = [path '/mrSession.mat'];
    disp(thisname);
    if (exist(thisname) == 2)
      
      
      %Remove existing ROIs
      v = mrLoadRet;
      nROIs = numel(v.ROIs);
      if (nROIs > 0)
        v = viewSet(v,'deleteroi',1:nROIs);
      end

      
      %Add ROIs
      cd('ROIs');
      rdir = dir;
      s2 = size(rdir,1);
      for r=3:s2
        fname = rdir(r).name;
        ext = rdir(r).name(end-2:end);
        if strcmp(ext,'mat')
          disp(['Adding : ' fname]);
          load(fname);
          command = ['v = viewSet(v,''newroi'',' fname(1:end-4) ');'];
          eval(command);
        end
      end
      cd ..
      
      
      %Get Scan Coordinates for each ROI
      xform = viewGet(v,'base2scan');


      %Loop through ROIs
      nROIs = numel(v.ROIs);
      for i=1:nROIs

        %Get ROI
        disp(v.ROIs(i).name);
        coords = v.ROIs(i).coords;
        scanCoords = xform * coords;
        scanCoords = round(scanCoords);

        %Unique
        scanCoords = scanCoords';
        scanCoords = unique(scanCoords,'rows');
        scanCoords = scanCoords';
        nVoxels = size(scanCoords,2);

        savename = ['Freesurfer/' v.ROIs(i).name '_scancoords.mat'];
        save(savename,'scanCoords','xform','coords','scanCoords');
      end


        %Close
        mrQuit;

    end
    cd ..
  end
end
