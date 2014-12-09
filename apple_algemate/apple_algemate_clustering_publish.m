function apple_algemate_clustering_publish(subject)


%Init and Load
clc;
os = [];
param = [];
baseval = 2.27;
load('cerulean_LCD at scanner - 10262010');
load(['apple_clustering_' subject '.mat']);
os.ratios = permute(os.ratios,[2 1 3]);
labels = repmat([1 1 2 2 3 3 4 4 5 5 5 5],1,100);



%Get colors
data = textread('apple_colors.txt');
param.RGB = data(1:12,1:3);
colors = repmat(data(1:12,1:3),100,1);
dkl = repmat(data(1:12,4:6),100,1);



%ROI names
ROInames{1} = 'V1';
ROInames{2} = 'V2';
ROInames{3} = 'V3';
ROInames{4} = 'hV4v';
ROInames{5} = 'VO1';
ROInames{6} = 'VO2';
ROInames{7} = 'V3AB';
ROInames{8} = 'LO1';
ROInames{9} = 'LO2';
ROInames{10} = 'hMT+';



%Save Measures for Statistical Testing
load(['apple_statistics/apple_measures_' subject '.mat']);
st.ratios = os.ratios;
st.HubertIndex = os.HubertIndex;
save(['apple_statistics/apple_measures_' subject '.mat'],'st');































%Create Spaces
figure;
for i=1:numel(ROInames)
  
  %Plot RSVP
  subplot(2,10,i); hold on;
  data = os.Xrsvps{i};
  data = reshape(data,12,100,2);
  data = permute(data,[2 1 3]);
  datastd = squeeze(std(data)).*3;
  data = squeeze(mean(data,1));
  for j=1:12
    h = line([data(j,1)-datastd(j,1) data(j,1)+datastd(j,1)],[data(j,2) data(j,2)]);
    set(h,'Color',param.RGB(j,:));
    h = line([data(j,1) data(j,1)],[data(j,2)-datastd(j,2) data(j,2)+datastd(j,2)]);
    set(h,'Color',param.RGB(j,:));
    scatter(data(j,1),data(j,2),50,param.RGB(j,:),'filled');
  end
  axis([-5 5 -5 5]); box on;


  %Plot TASK
  subplot(2,10,i+10); hold on;
  data = os.Xtasks{i};
  data = reshape(data,12,100,2);
  data = permute(data,[2 1 3]);
  datastd = squeeze(std(data)).*3;
  data = squeeze(mean(data,1));
  for j=1:12
    h = line([data(j,1)-datastd(j,1) data(j,1)+datastd(j,1)],[data(j,2) data(j,2)]);
    set(h,'Color',param.RGB(j,:));
    h = line([data(j,1) data(j,1)],[data(j,2)-datastd(j,2) data(j,2)+datastd(j,2)]);
    set(h,'Color',param.RGB(j,:));
    scatter(data(j,1),data(j,2),50,param.RGB(j,:),'filled');
  end
  axis([-5 5 -5 5]); box on;

end



















return





% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % % return
% % for i=5:5%0
% % 
% %   X = squeeze(os.ratios(1:100,i,2))
% %   good(i) = lillietest(X)
% %   Xnew = boxcox(X)
% % 
% %    %0 X = squeeze(os.ratios(1:10,i,1))
% %   [h,p,ci,stats] = ttest(Xnew,2.27,0.001,'right')
% %   hlist(i) = h;
% % 
% %   scatter(X,Xnew);
% %   return
% %   
% %     X = squeeze(os.ratios(1:100,i,2))
% %   good(i) = lillietest(X)
% %   Xnew = boxcox(X) + mean(X)
% % 
% %    %0 X = squeeze(os.ratios(1:10,i,1))
% %   [h,p,ci,stats] = ttest(Xnew,2.27,0.001,'right')
% %   hlist(i) = h;
% % 
% % %   
% % %   
% % %   [h,p,ci,stats] = ttest(X,2.27,0.001,'right')
% % %   hlist(i) = h;
% % %   hlist
% % end
% % hlist
% % % %Ttest of clustering
% % % nRep = 10;
% % % X = [];
% % % for j=1:10
% % %   
% % %   os.ratios(
% % %   
% % % end
% % % %yratio = yratio + rand(size(yratio)).*1;
% % % [p,atab,stats] = anovan(yratio,{grouparea,grouptask},'alpha',0.01,'model','full', 'sstype',2,'varnames',strvcat('Areas', 'Task'))
% % % multcompare(stats,'Dim',[1 2])
% % return
% % 
% %  
% % 
% % 
% % %Anova on Ratios
% % nRep = 10;
% % grouparea = [];
% % grouptask = [];
% % yratio = [];
% % for j=1:10
% %   for l=1:nRep
% %     grouparea = [grouparea {ROInames{j} ROInames{j}}];
% %     grouptask = [grouptask {'rsvp' 'task'}];
% %     for i=1:2
% %       yratio = [yratio os.ratios(l,j,i)];
% %     end
% %   end
% % end
% % %yratio = yratio + rand(size(yratio)).*1;
% % [p,atab,stats] = anovan(yratio,{grouparea,grouptask},'alpha',0.01,'model','full', 'sstype',2,'varnames',strvcat('Areas', 'Task'))
% % multcompare(stats,'Dim',[1 2])
% % return
% % 
% %  
% % 
% % os.yRand = os.yRand + rand(size(os.yRand));
% 
% %[p,atab,stats] = anovan(os.yRand,{os.grouparea,os.grouptask},'model','full', 'sstype',2,'varnames',strvcat('Areas', 'Task'))
% %multcompare(stats)
% % return
% % 
% % %Create Distribution
% % [X,Y] = meshgrid(linspace(-3,3,1000),linspace(-3,3,1000));
% % X = reshape(X,numel(X),1);
% % Y = reshape(Y,numel(Y),1);
% % Xdis = [X Y];
% % 
% % 
% % 
% % 
% 
% % 
% % 
% % 
% %Significance level of permutation test
% for i=1:10
%   theseratios = squeeze(os.ratios(:,i,1));
%   siglevel = prctile(theseratios,5) > baseval;
%   siglevel = siglevel + prctile(theseratios,1) > baseval;
%   siglevel = siglevel + prctile(theseratios,0.1) > baseval;
%   permtest(i,1) = siglevel;
% 
%   theseratios = squeeze(os.ratios(:,i,2));
%   siglevel = prctile(theseratios,5) > baseval;
%   siglevel = siglevel + prctile(theseratios,1) > baseval;
%   siglevel = siglevel + prctile(theseratios,0.1) > baseval;
%   permtest(i,2) = siglevel;
% end
% permtest
% 
% 
% 
% 
%Average
% os
% 
% meanratio = squeeze(mean(os.ratios,1));
% stdratio = squeeze(std(os.ratios));
% meanRandIndex = squeeze(mean(os.HubertIndex,1)).^2;
% stdRandIndex = squeeze(std(os.HubertIndex));
% dunnIndex = os.dunnIndex(:,:,1:2);
% stddunnIndex = squeeze(std(dunnIndex));
% dunnIndex = squeeze(mean(dunnIndex,1));
% 
% daviesIndex = os.daviesIndex(:,:,1:2);
% stddaviesIndex = squeeze(std(daviesIndex));
% daviesIndex = squeeze(mean(daviesIndex,1));
% 
% 
% 
% 
% 
% 
% %Ratios
% figure;
% subplot(2,2,1);
% handles = apple_barweb(meanratio,stdratio,1,ROInames,'Categorization','Visual area','Ratio');
% box on;grid on;axis([0 numel(ROInames)+1 0 5]);
% 
%  
% %Rand Index
% subplot(2,2,2);
% handles = apple_barweb(meanRandIndex(:,1:2),stdRandIndex(:,1:2),1,ROInames,'EM','Visual area','Ratio');
% box on;grid on;axis([0 numel(ROInames)+1 0 1]);
% 
% 
% return


% /
% 
% %Rand Index Kmeans
% subplot(2,2,3);
% handles = apple_barweb(meanRandIndex(:,3:4),stdRandIndex(:,3:4),1,ROInames,'Kmeans','Visual area','Ratio');
% box on;grid on;axis([0 numel(ROInames)+1 0 1]);
% 
% 
% %Dunn Index
% subplot(2,2,4);
% handles = apple_barweb(dunnIndex,stddunnIndex,1,ROInames,'Kmeans','Visual area','Ratio');
% box on;grid on;axis([0 numel(ROInames)+1 0 0.02]);
% 
% 
% 
% 
% 
% 
% figure;
% areastoplot = [1 4 5 10];
% for a=1:numel(areastoplot)
% 
%   subplot(2,numel(areastoplot),a);
%   Z = linkage(os.disRSVP{areastoplot(a)});
%   [H,T] = dendrogram(Z,'colorthreshold','default');
%   hold on;grid on; box on; 
%   for i=1:numel(H)
%     x = get(H(i),'XData');
%     y = get(H(i),'YData');
%     set(H(i),'Color',[0 0 0]);
%     if (Z(i,1) < 13 && Z(i,2) < 13)
%       h = scatter(x(1),0,'filled');
%       set(h,'MarkerEdgeColor',param.RGB(Z(i,1),:),'MarkerFaceColor',param.RGB(Z(i,1),:));
%       h = scatter(x(4),0,'filled');
%       set(h,'MarkerEdgeColor',param.RGB(Z(i,2),:),'MarkerFaceColor',param.RGB(Z(i,2),:));
%     end
%   end
%   axis([0 13 -100 600]);
%   
% 
%   subplot(2,numel(areastoplot),a+numel(areastoplot));
%   Z = linkage(os.disTASK{areastoplot(a)});
%   [H,T] = dendrogram(Z,'colorthreshold','default');
%   hold on;grid on; box on; 
%   for i=1:numel(H)
%     x = get(H(i),'XData');
%     y = get(H(i),'YData');
%     set(H(i),'Color',[0 0 0]);
%     if (Z(i,1) < 13 && Z(i,2) < 13)
%       h = scatter(x(1),0,'filled');
%       set(h,'MarkerEdgeColor',param.RGB(Z(i,1),:),'MarkerFaceColor',param.RGB(Z(i,1),:));
%       h = scatter(x(4),0,'filled');
%       set(h,'MarkerEdgeColor',param.RGB(Z(i,2),:),'MarkerFaceColor',param.RGB(Z(i,2),:));
%     end
%   end
%   axis([0 13 -100 600]);
%   
% end
% % 
% 
% % %Dunn Index
% % for i=1:10
% %   [labelsRSVP] = emgm(os.Xrsvps{i},labels);
% %   DI(i,1) = apple_daviesboudin(os.Xrsvps{i}, labelsRSVP);
% %   [labelsTASK] = emgm(os.Xtasks{i},labels);
% %   DI(i,2) = apple_daviesboudin(os.Xtasks{i}, labelsTASK);
% % end
% % bar(DI);
% % 
% % return
% 
% 
% 
% %return
% figure;
areastoplot = [3];
for a=1:numel(areastoplot)
  
  %Perform EM
  disp(['Drawing area : ' ROInames{areastoplot(a)}]);
  areacode = areastoplot(a);
  dataTASK = os.Xtasks{areacode};
  dataRSVP = os.Xrsvps{areacode};
  [labelsTASK, modelTASK] = emgm(os.Xtasks{areacode},labels);
  [labelsRSVP, modelRSVP] = emgm(os.Xrsvps{areacode},labels);


  
  for i=1:size(modelRSVP.mu,2)
  
    %Get Data Points
    dum = (labelsRSVP == i);
    P = dataRSVP(dum,:);
    C = colors(dum,:);

    %Cluster Median Color
    ds.DKL = mean(dkl(dum,:));
    ds = cerulean_DKL2ALL(ds);

    %Distribution Dependent Size
    mu = modelRSVP.mu(:,i)';
    sigma = modelRSVP.Sigma(:,:,i);
    V = mvnpdf(P,mu,sigma);

    %Plot
    subplot(2,numel(areastoplot),a);
    for p=1:size(P,1)
      h = scatter(P(p,1),P(p,2),V(p)*50,'filled');
      set(h,'MarkerEdgeColor',C(p,:),'MarkerFaceColor',C(p,:));
      hold on;   
    end
    h = scatter(mu(1),mu(2),200,'filled');
    set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',ds.RGB);
    axis([-3 3 -3 3]);
    box on; grid on;

  end

  for i=1:size(modelTASK.mu,2)
    
    %Get Data Points
    dum = (labelsTASK == i);
    P = dataTASK(dum,:);
    C = colors(dum,:);

    %Cluster Median Color
    ds.DKL = mean(dkl(dum,:));
    ds = cerulean_DKL2ALL(ds);

    %Distribution Dependent Size
    mu = modelTASK.mu(:,i)';
    sigma = modelTASK.Sigma(:,:,i);
    V = mvnpdf(P,mu,sigma);

    %Plot
    subplot(2,numel(areastoplot),a+numel(areastoplot));
    for p=1:size(P,1)
      h = scatter(P(p,1),P(p,2),V(p)*50,'filled');
      set(h,'MarkerEdgeColor',C(p,:),'MarkerFaceColor',C(p,:));
      hold on;   
    end
    h = scatter(mu(1),mu(2),200,'filled');
    set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',ds.RGB);
    axis([-3 3 -3 3]);
    box on; grid on;

  end
  
end



%return
figure;
areastoplot = [3];
for a=1:numel(areastoplot)
  
  %Perform EM
  disp(['Drawing area : ' ROInames{areastoplot(a)}]);
  areacode = areastoplot(a);
  dataTASK = os.Xtasks{areacode};
  dataRSVP = os.Xrsvps{areacode};
  [labelsTASK, modelTASK] = emgm(os.Xtasks{areacode},labels);
  [labelsRSVP, modelRSVP] = emgm(os.Xrsvps{areacode},labels);


  
  for i=1:size(modelRSVP.mu,2)
  
    %Get Data Points
    dum = (labelsRSVP == i);
    P = dataRSVP(dum,:);
    C = colors(dum,:);

    %Cluster Median Color
    ds.DKL = mean(dkl(dum,:));
    ds = cerulean_DKL2ALL(ds);

    %Distribution Dependent Size
    mu = modelRSVP.mu(:,i)';
    sigma = modelRSVP.Sigma(:,:,i);
    V = mvnpdf(P,mu,sigma);

    %Plot
    subplot(2,numel(areastoplot),a);
    scatter(P(:,1),P(:,2),V*50,ds.RGB,'filled');
    hold on;   
    h = scatter(mu(1),mu(2),200,'filled');
    set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',ds.RGB);
    axis([-3 3 -3 3]);
    box on; grid on;

  end

  for i=1:size(modelTASK.mu,2)
    
    %Get Data Points
    dum = (labelsTASK == i);
    P = dataTASK(dum,:);
    C = colors(dum,:);

    %Cluster Median Color
    ds.DKL = mean(dkl(dum,:));
    ds = cerulean_DKL2ALL(ds);

    %Distribution Dependent Size
    mu = modelTASK.mu(:,i)';
    sigma = modelTASK.Sigma(:,:,i);
    V = mvnpdf(P,mu,sigma);

    %Plot
    subplot(2,numel(areastoplot),a+numel(areastoplot));
    scatter(P(:,1),P(:,2),V*50,ds.RGB,'filled');
    hold on;   
    h = scatter(mu(1),mu(2),200,'filled');
    set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',ds.RGB);
    axis([-3 3 -3 3]);
    box on; grid on;

  end
  
end
%  
% 
%  
