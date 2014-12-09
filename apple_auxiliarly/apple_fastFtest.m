function F = apple_fastFtest(X)


%Init
[nMeas,nGroups] = size(X);
fb = nGroups - 1;
fw = nGroups.*(nMeas-1);
 
Ygroupmeans = mean(X);
Ymean = mean(X(:));
BGSS = sum(nMeas.*(Ygroupmeans - Ymean).^2);
MSB = BGSS ./ fb;
WGSS = ((X - repmat(Ygroupmeans,nMeas,1)).^2);
WGSS = sum(WGSS(:));
MSW = WGSS ./ fw;
F = MSB / MSW;
