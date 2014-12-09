function apple_algemate_ratio(subject)


%Init
clc;
taskmatrices = [];
rsvpmatrices = [];
load(['apple_clustering_' subject '.mat']);
[nAreas,nMatrices] = size(taskmatrices);
benchlabels = repmat([1 1 2 2 3 3 4 4 5 5 5 5],1,nMatrices);
colors = repmat(param.RGB,nMatrices,1);



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
for i=4:4%nAreas
  
  %Reset Matrices
  disp(['Running on : ' ROInames{i}]);

  %Loop through matrices
  taskMatrices = [];
  rsvpMatrices = [];
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
      scores = scores(:,1:2) * Tr;
    end
    taskMatrices = [taskMatrices ; matrix];
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
      scores = scores(:,1:2) * Tr;
    end
    rsvpMatrices = [rsvpMatrices ; matrix];
    Drsvp = squareform(pdist(matrix));
    within = median(Drsvp(C == 1));
    between = median(Drsvp(C == 0));
    ratios(i,j,1) = between / within;
    
  end

  subplot(2,2,1);
  labels = emgm(rsvpMatrices,5)
  [pc,scores] = princomp(rsvpMatrices);
  scatter(scores(:,1),scores(:,2),50,colors,'filled');
  
  subplot(2,2,2);
  labels = emgm(taskMatrices,5)
  [pc,scores] = princomp(taskMatrices);
  scatter(scores(:,1),scores(:,2),50,colors,'filled');

  
  
end


%bar(squeeze(mean(ratios,2)))

