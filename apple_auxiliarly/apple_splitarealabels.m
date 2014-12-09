function ds = apple_splitarealabels(ds)

%Split Area Labels
count = 0;
splits = strfind(ds.selectedROI,'-');
startval = 1;
for i=1:numel(splits)
  count = count + 1;
  areanames{count} = ds.selectedROI(startval:splits(i)-1);
  startval = splits(i) + 1;
end
count = count + 1;
areanames{count} = ds.selectedROI(startval:end);
ds.areanames = areanames;