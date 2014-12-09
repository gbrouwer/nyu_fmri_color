function labels = apple_shiftlabels(labels,benchlabels)


%Create random permutations
for i=1:1000
  matrix(i,:) = randperm(max(labels));
end
matrix = unique(matrix,'rows');
[s1,s2] = size(matrix);


%Determine best label identifiers
maxval = 0;
for i=1:s1
  perm = matrix(i,:);
  for l=1:max(labels)
    dum = (labels == l);
    newlabels(dum) = perm(l);
  end
  val = sum(benchlabels == newlabels);
  if (val > maxval)
    maxval = val;
    bestlabels = newlabels;
  end
end


%Return
labels = bestlabels;

