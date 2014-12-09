function os = apple_algemate_storematrices(os,level)


%Create Forward Model
os.nChannels = 6;
os = apple_createforwardmodel(os);
os.newlabels = sort(repmat(1:3,1,12));



%Loop throug the available areas
for i=1:numel(os.ROInames)
 
  
  %Get data
  os.scoresRSVPfull{i} = [];
  os.scoresTASKfull{i} = [];  
  matrixRSVP = os.reconMatrix_rsvp{i};
  matrixTASK = os.reconMatrix_task{i};
   
  
  %Reshape
  [s1,s2] = size(matrixTASK);
  matrixRSVP = reshape(matrixRSVP,s1,6,s2/6);
  matrixTASK = reshape(matrixTASK,s1,6,s2/6);
  nMatrices = size(matrixTASK,3);
 
  
  %Loop through different sessions
  for j=1:nMatrices
    
    %Random Matrices
    randval = randperm(nMatrices);
    randval = randval(1:floor(0.04*nMatrices));

    %RSVP section
    thismatrices = (matrixRSVP(:,:,randval));
    thismatrices = median(thismatrices,3);
    thismatrices = squeeze(thismatrices);
    rsvpmatrices{i,j} = thismatrices;
   
    %TASK section
    thismatrices = (matrixTASK(:,:,randval));
    thismatrices = median(thismatrices,3);
    thismatrices = squeeze(thismatrices);
    taskmatrices{i,j} = thismatrices;
    
  end

end


%Store and save
param = os.param;
save(['apple_clustering/apple_clustering_' os.subject '_' num2str(level) '_rh.mat'],'taskmatrices','rsvpmatrices','param');


















