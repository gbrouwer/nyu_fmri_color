function apple_6to2dimension

%Init
clc;
os = [];
load('apple_clustering_group_100.mat');
os = apple_algemate_areas(os);




for i=1:10
  for j=1:100
    M = rsvpmatrices{i,j};
    [pc,scores] = princomp(M);
    scores = scores(:,1:2);
    X = scores;
    X(:,end+1) = 1;
    Y = M;
    W = inv(X'*X)*X'*Y;
    P = X * W;
    field(j,i,1) = corr2(P,M).^2;

    M = taskmatrices{i,j};
    [pc,scores] = princomp(M);
    scores = scores(:,1:2);
    X = scores;
    X(:,end+1) = 1;
    Y = M;
    W = inv(X'*X)*X'*Y;
    P = X * W;
    field(j,i,2) = corr2(P,M).^2;
  end
end




apple_nonparametric('MODEL -> PCA',field,1000,os.ROInames);



modelfitstd = squeeze(std(field,[],1))
modelfitmean = squeeze(mean(field,1))
handles = apple_barweb(modelfitmean,modelfitstd,1,os.ROInames,'Model -> PCA','Visual area','R-square');
box on;grid on;axis([0 numel(os.ROInames)+1 0 1.00]);
