function ds = apple_estimate_alternative(ds,algorithms)


if (algorithms.estimate == 1)

  
  %Estimate
  for i=1:ds.param.nRuns
     
    %Matrices
    disp(['     Estimating betas from Run : ' num2str(i)]);
 
    %Inner loop
    for m=1:ds.param.nROIs
       
      %Get data
      Y = ds.ROIs{m}.run{i}.rawdata - 1;
      [nVols,nVoxels] = size(Y);
      
      %Estimation Classes, with estimated HRF
      M = ds.run{i}.motion;
      for j=1:ds.param.nClasses
        X = ds.run{i}.classmatrix{j};
        X = [X M];X(:,end+1) = 1;
        nReg = size(X,2);
        R = eye(nReg); R(end,end) = 0;
        classbetas = inv((X' * X) + R) * X' * Y;
        predY = (classbetas' * X')';
        SStot = sum((Y - repmat(mean(Y),nVols,1)) .* (Y - repmat(mean(Y),nVols,1)));
        SSerr = sum((Y - predY).*(Y - predY));
        ds.ROIs{m}.run{i}.classR(j,:) = 1 - (SSerr ./ SStot);
        ds.ROIs{m}.run{i}.classbetas(j,:) = classbetas(1,:);
      end
      ds.ROIs{m}.run{i}.classR = mean(ds.ROIs{m}.run{i}.classR);
      
      %Estimation Combined, with estimated HRF
      X = ds.run{i}.combinedmatrix;
      M = ds.run{i}.motion;
      X = [X M];X(:,end+1) = 1;
      nReg = size(X,2);
      R = eye(nReg); R(end,end) = 0;
      ds.ROIs{m}.run{i}.combinedbetas = inv((X' * X) + R) * X' * Y;
      predY = (ds.ROIs{m}.run{i}.combinedbetas' * X')';
      SStot = sum((Y - repmat(mean(Y),nVols,1)) .* (Y - repmat(mean(Y),nVols,1)));
      SSerr = sum((Y - predY).*(Y - predY));
      ds.ROIs{m}.run{i}.combinedR = 1 - (SSerr ./ SStot);
         
    end
  end
 
  %Save and Return
  save(ds.savename,'ds');
  cd([ds.rootdir]);
    
end
