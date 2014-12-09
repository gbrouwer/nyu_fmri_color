function scores = apple_divisionPCA(data,nComponents,nDivisions)


%Loop
fullscore = [];
s2 = size(data,2);
val = round(linspace(1,s2,nDivisions+1));
for i=1:nDivisions
  matrix = data(:,val(i):val(i+1));
  [~,scores] = princomp(matrix);
  fullscore = [fullscore scores(:,1:nComponents)];
end

%Final PCA
[pc,scores] = princomp(fullscore);

