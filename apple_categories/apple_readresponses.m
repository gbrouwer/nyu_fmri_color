function apple_readresponses(session)

%Init
clc;
rootdir = cd;
cd('/Volumes/data/MRI-Saffron');
cd(session);
cd('Etc');


%Get Number of Output files
fdir = dir;
[s1,s2] = size(fdir);
nfiles = 0;
for i=3:s1
  if ~isempty(strfind(fdir(i).name,'Saffron-Output'))
    nfiles = nfiles + 1;
  end
end




%Read Files
for no=1:2:nfiles
  
  %Open and Read Output File
  field = zeros(12,5);
  fid = fopen(['Saffron-Output' num2str(no) '.txt'],'r');
  count = 0;
  lines = [];
  while 1
      tline = fgetl(fid);
      if ~ischar(tline), break, end
      count = count + 1;
      lines{count} = tline;
  end
  fclose(fid);
  
  
  %Open and Read Logfile
  fid = fopen(['Saffron-Logfile' num2str(no) '.txt'],'r');
  tline = fgetl(fid);
  for i=1:78
    tline = fgetl(fid);
    val = sscanf(tline,'%f %f %f %f %f');
    trials(i) = val(1);
  end
  fclose(fid);
  dum = (trials < 13);
  trials = trials(dum);
  
  
  %Convert
  for i=1:count
    line = lines{i};
    color = line(1:6);
    if (strfind(color,'Purple'))
      colortype = 1;
    end
    if (strfind(color,'Blue'))
      colortype = 2;
    end
    if (strfind(color,'Green'))
      colortype = 3;
    end
    if (strfind(color,'Yellow'))
      colortype = 4;
    end
    if (strfind(color,'Orange'))
      colortype = 5;
    end
    b = sscanf(line(7:end),'%d %d %d %d');
    timelist(i) = b(end);
    list(i,1:3) = b(1:3);
    list(i,4) = colortype;
  end
  [s1,s2] = size(list);
  
  
  %Detect Flaws
  difflist = [1:s1-1 ; diff(timelist)]';
  difflist = sortrows(difflist,2);
  

  %Field matrix
  if (s1 == 72)
    list(:,2) = trials';
    for i=1:72
      val1 = list(i,2);
      val2 = list(i,4);
      field(val1,val2) = field(val1,val2) + 1;
    end  
    figure;
    imagesc(field);
  end
  
end




%Return
cd(rootdir);

