function os = apple_algemate_clustering(os,level)


%Init
clc;
taskmatrices = [];
rsvpmatrices = [];
load(['apple_clustering_' os.subject '_' num2str(level) '.mat']);
[nAreas,nMatrices] = size(taskmatrices);
benchlabels = repmat([1 1 2 2 3 3 4 4 5 5 5 5],1,nMatrices);
colors = repmat(param.RGB,nMatrices,1);
grouparea = [];
grouptask = [];
grouparearatio = [];
grouptaskratio = [];
yRand = [];
yDavies = [];
yRandK = [];
yDaviesK = [];
yratio = [];
yDunn = [];
yDunnK = [];
nPermutations = 100;



%Category Matrix
C = (1-squareform(pdist([1 1 2 2 3 3 4 4 5 5 5 5]')));
C = (C == 1);
C = C + eye(12);



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




%Loop through areas
for i=1:nAreas
  
  %Reset Matrices
  disp(['Running on : ' ROInames{i}]);
  conmatrixTASK{i} = zeros(5,5);
  conmatrixRSVP{i} = zeros(5,5);
  Xtask = [];
  Xrsvp = [];
  disTASK{i} = zeros(12,12);
  disRSVP{i} = zeros(12,12);

  %Loop through matrices
  for j=1:nMatrices

    %Create Task List
    matrix = taskmatrices{i,j};
    [~,scores] = princomp(matrix);
    scores = scores(:,1:2);
    if (j==1)
      basetask = scores(:,1:2);
      scores = scores(:,1:2);
    else
      Tr = basetask \ scores(:,1:2);
      %Tr = apple_cgrscho(Tr);
      scores = scores(:,1:2) * Tr;
    end
    Xtask = [Xtask ; scores];
    disTASK{i} = disTASK{i} + squareform(pdist(scores));
    Dtask = squareform(pdist(matrix));
    within = median(Dtask(C == 1));
    between = median(Dtask(C == 0));
    ratios(i,j,2) = between / within;
  
    
    %Create RSVP List
    matrix = rsvpmatrices{i,j};
    [~,scores] = princomp(matrix);
    scores = scores(:,1:2);
    if (j==1)
      basersvp= scores(:,1:2);
      scores = scores(:,1:2);
    else
      Tr = basersvp \ scores(:,1:2);
      %Tr = apple_cgrscho(Tr);
      scores = scores(:,1:2) * Tr;
    end
    Xrsvp = [Xrsvp ; scores];
    disRSVP{i} = disRSVP{i} + squareform(pdist(scores));
    Drsvp = squareform(pdist(matrix));
    within = median(Drsvp(C == 1));
    between = median(Drsvp(C == 0));
    ratios(i,j,1) = between / within;
    
  end
  

  
  Xtasks{i} = Xtask;
  Xrsvps{i} = Xrsvp;
  
  %Loop through permutations
  for c=1:nPermutations
     
    
    %Compute Clustering EM
    labelTASK = emgm(Xtask,5);
    labelRSVP = emgm(Xrsvp,5);

    %Compute External Measures RSVP
    dunnIndex(c,i,1) = dunns(5,squareform(pdist(Xrsvp)),labelRSVP);
    daviesIndex(c,i,1) = apple_daviesboudin(Xrsvp, labelRSVP);
    [AR,RI,MI,HI] = apple_randindex(labelRSVP,benchlabels);
    adjustedRandIndex(c,i,1) = AR;
    RandIndex(c,i,1) = RI;
    MirkinIndex(c,i,1) = MI;
    HubertIndex(c,i,1) = HI;
    
    %Compute External Measures TASK
    dunnIndex(c,i,2) = dunns(5,squareform(pdist(Xtask)),labelTASK);
    daviesIndex(c,i,2) = apple_daviesboudin(Xtask, labelTASK);
    [AR,RI,MI,HI] = apple_randindex(labelTASK,benchlabels);
    adjustedRandIndex(c,i,2) = AR;
    RandIndex(c,i,2) = RI;
    MirkinIndex(c,i,2) = MI;
    HubertIndex(c,i,2) = HI;
    

    %Compute Clustering Kmeans
    labelTASK = kmeans(Xtask,5,'EmptyAction','singleton');
    labelRSVP = kmeans(Xrsvp,5,'EmptyAction','singleton');

    %Compute External Measures RSVP
    daviesIndex(c,i,3) = apple_daviesboudin(Xrsvp, labelRSVP);
    dunnIndex(c,i,3) = dunns(5,squareform(pdist(Xrsvp)),labelRSVP);
    [AR,RI,MI,HI] = apple_randindex(labelRSVP,benchlabels);
    adjustedRandIndex(c,i,3) = AR;
    RandIndex(c,i,3) = RI;
    MirkinIndex(c,i,3) = MI;
    HubertIndex(c,i,3) = HI;
    
    %Compute External Measures TASK
    daviesIndex(c,i,4) = apple_daviesboudin(Xtask, labelTASK);
    dunnIndex(c,i,4) = dunns(5,squareform(pdist(Xtask)),labelTASK);
    [AR,RI,MI,HI] = apple_randindex(labelTASK,benchlabels);
    adjustedRandIndex(c,i,4) = AR;
    RandIndex(c,i,4) = RI;
    MirkinIndex(c,i,4) = MI;
    HubertIndex(c,i,4) = HI;
    

  end


end





%Store and Save
os.dunnIndex = dunnIndex;
os.daviesIndex = daviesIndex;
os.Xtasks = Xtasks;
os.Xrsvps = Xrsvps;
os.adjustedRandIndex = adjustedRandIndex;
os.RandIndex = RandIndex;
os.MirkinIndex = MirkinIndex;
os.HubertIndex = HubertIndex;
os.yDavies = yDavies;
os.yDaviesK = yDaviesK;
os.yDaviesK = yDaviesK;
os.yRandK = yRandK;
os.yDunn = yDunn;
os.yDunnK = yDunn;
os.yRand = yRand;
os.grouparea = grouparea;
os.grouptask = grouptask;
os.disTASK = disTASK;
os.disRSVP = disRSVP;
os.yratio = yratio;
os.ratios = ratios;

 

%Store
load(['apple_clustering/apple_clustering_' os.subject '_' num2str(level) '_rh.mat'],'taskmatrices','rsvpmatrices','param');
save(['apple_clustering/apple_clustering_' os.subject '_' num2str(level) '_rh.mat'],'taskmatrices','rsvpmatrices','param','os');



