function apple_rename

clc;
fdir = dir;
s1 = size(fdir,1);
for i=3:s1
  fname = fdir(i).name;
  ext = fname(end-2:end);
  if (strcmp(ext,'mat'))
    newname = [fname(1:end-10) '.mat'];
    movefile(fname,newname);
    disp(newname);
  end
end


