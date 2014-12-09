function apple_renamefiles(string1,string2)

clc;
sdir = dir;
[r1,r2] = size(sdir);
for p=3:r1
  if (sdir(p).isdir == 1)
    disp(sdir(p).name);
    cd(sdir(p).name)
    fdir = dir;
    [s1,s2] = size(fdir);
    for m=3:s1
      fname = fdir(m).name;
      v1 = strfind(fname,string1);
      if ~isempty(strfind(fname,string1))
        newname = fname;
        part1 = newname(1:v1-1);
        part2 = newname(numel(string1)+1:end);
        replacename = [part1 string2 part2];
        disp(['Copying : ' fname ' to ' replacename]);
        movefile(fname,replacename);
      end
    end
    cd ..
  end
end


