function apple_adjustedRandBaseline


%Circular Space
nulldistribution = [];
nRep = 10;
x = sin(linspace(0,2*pi,13));
y = cos(linspace(0,2*pi,13));
x = x(1:end-1);
y = y(1:end-1);
P = repmat([x' y'],nRep,1);
truelabels = repmat([1 1 2 2 3 3 4 4 5 5 5 5],1,nRep);



%Monte Carlo
for i=1:1000
  N = normrnd(0,0.000001,size(P));
  D = P + N;
  classlabels = emgm(D,5);
  nulldistribution(i) = apple_randindex(truelabels,classlabels).^2;
end
hist(nulldistribution,0:0.1:1)
prctile(nulldistribution,95)



%Save
save('apple_randindex_nulldistribution.mat','nulldistribution');

 
