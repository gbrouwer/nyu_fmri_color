function apple_pcaspace

%Init
clc;
load('apple_betas.mat');


a = Ctask{10};
[s1,s2] = size(a);
a = zscore(a);
scores = apple_divisionPCA(a,10,20)

c = repmat(param.RGB,3,1)


%scores = reshape(scores(:,1:2),12,3,2);
%scores = squeeze(mean(scores,2));



scatter(scores(:,1),scores(:,2),100,c,'filled');