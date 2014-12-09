function ds = apple_getmotionestimates(ds,algorithms)


%Get motion estimates for each run
if (algorithms.getmotionestimates == 1)
  
  %Unaveraged data
  if (str2double(ds.session(end-1:end)) == 12 || str2double(ds.session(end-1:end)) == 11 || str2double(ds.session(end-1:end)) == 13)
    cd([ds.projectdir '/' ds.session]);
    cd('MotionComp/TSeries');
    fdir = dir;
    [s1,~] = size(fdir);
    count = 0;
    transforms = [];
    for i=3:s1
      filename = fdir(i).name;
      ext = filename(end-2:end);
      if (strcmp(ext,'mat'))
        load(filename);
        store = []; M = [];
        for j=1:numel(transforms)
           store(j,:,:) = transforms{j};
           R = squeeze(store(j,1:3,1:3));
           M(j,7) = 2 * acosd(0.5 * sqrt(trace(R)+1));
        end
        M(:,1) = squeeze(store(:,1,4));
        M(:,2) = squeeze(store(:,2,4));
        M(:,3) = squeeze(store(:,3,4));
        M(:,4) = squeeze(store(:,1,2));
        M(:,5) = squeeze(store(:,1,3));
        M(:,6) = squeeze(store(:,2,3));
        count = count + 1;
        ds.run{count}.motion = M(ds.param.skip+1:end,:);
      end
    end
  end

  %Averaged data
  if (str2double(ds.session(end-1:end)) == 14 || str2double(ds.session(end-1:end)) == 10)
    cd([ds.projectdir '/' ds.session]);
    cd('MotionComp/TSeries');
    fdir = dir;
    [s1,~] = size(fdir);
    count = 0;
    for i=3:s1
      filename = fdir(i).name;
      ext = filename(end-2:end);
      if (strcmp(ext,'mat'))
        load(filename);
        store = []; M = [];
        for j=1:numel(transforms)
           store(j,:,:) = transforms{j};
           R = squeeze(store(j,1:3,1:3));
           M(j,7) = 2 * acosd(0.5 * sqrt(trace(R)+1));
        end
        M(:,1) = squeeze(store(:,1,4));
        M(:,2) = squeeze(store(:,2,4));
        M(:,3) = squeeze(store(:,3,4));
        M(:,4) = squeeze(store(:,1,2));
        M(:,5) = squeeze(store(:,1,3));
        M(:,6) = squeeze(store(:,2,3));
        count = count + 1;
        temp{count} = M;
      end
    end
    nruns = numel(ds.run);
    for i=1:nruns
      pos = [i nruns+i];
      pos = pos(pos <= count);
      M = [];
      for l=1:numel(pos)
        M = [M temp{pos(l)}];
      end
      ds.run{i}.motion = M(ds.param.skip+1:end,:);
    end
  end
  
  %Save and Return
  save(ds.savename,'ds');
  cd([ds.rootdir]);

end
