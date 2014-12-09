function ds = apple_gathersessions(ds)

%Empty
ds.HRF = [];
ds.HRFrsquare = [];
ds.classbetas = [];
ds.classR = [];
ds.stimbetas = [];
ds.stimR = [];
ds.combinedbetas = [];
ds.combinedbetasRestricted = [];
ds.combinedR = [];
ds.classbetas = [];
ds.classR = [];
ds.sessionlabels = [];
ds.classbetas = [];
ds.origbetas = [];
ds.Fval = [];
ds.scorelabels = [];
ds.scorebetas = [];



%Find appropriate files
rootdir = cd;
path = [rootdir '/apple_sessions/'];
cd(path);
fdir = dir;
count1 = 0;
count2 = 0;
[s1,s2] = size(fdir);
for i=3:s1
  fname = fdir(i).name;
  ext = fname(end-2:end);
  cval = round(str2double(fname(end-4)));
  if (strcmp(ext,'txt'))
    if (ds.corrected == 0)
      if ((ds.combined == 1 && (cval == 0) || (ds.combined == 0 && (cval == 1 || cval == 2))))
        count1 = count1 + 1;
        if (ds.sessions(count1) == 1)
          count2 = count2 + 1;
          disp(['Selected Session: ' fname(7:end-4)]);
          ds.sessionlist{count2} = fname(7:end-4);
        end
      end
    end
    if (ds.corrected == 1)
      if ((ds.combined == 1 && (cval == 4) || (ds.combined == 0 && (cval == 3))))
        count1 = count1 + 1;
        if (ds.sessions(count1) == 1)
          count2 = count2 + 1;
          disp(['Selected Session: ' fname(7:end-4)]);
          ds.sessionlist{count2} = fname(7:end-4);
        end
      end
    end
    if (ds.corrected == 2)
      if ((ds.combined == 1 && (cval == 4 || cval == 0) || (ds.combined == 0 && (cval == 3 || cval == 1 || cval ==2))))
        count1 = count1 + 1;
        if (ds.sessions(count1) == 1)
          count2 = count2 + 1;
          disp(['Selected Session: ' fname(7:end-4)]);
          ds.sessionlist{count2} = fname(7:end-4);
        end
      end
    end
    if (ds.corrected == 3)
      count1 = count1 + 1;
      if (ds.sessions(count1) == 1)
        count2 = count2 + 1;
        disp(['Selected Session: ' fname(7:end-4)]);
        ds.sessionlist{count2} = fname(7:end-4);
      end
    end
  end
end
cd(rootdir);