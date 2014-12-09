function ds = apple_estimate(ds,algorithms)


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
      X = ds.ROIs{m}.run{i}.classmatrix;
      M = ds.run{i}.motion;
      X = [X M];X(:,end+1) = 1;
      nReg = size(X,2);
      R = eye(nReg); R(end,end) = 0;
      ds.ROIs{m}.run{i}.classbetas = inv((X' * X) + R) * X' * Y;
      predY = (ds.ROIs{m}.run{i}.classbetas' * X')';
      SStot = sum((Y - repmat(mean(Y),nVols,1)) .* (Y - repmat(mean(Y),nVols,1)));
      SSerr = sum((Y - predY).*(Y - predY));
      ds.ROIs{m}.run{i}.classR = 1 - (SSerr ./ SStot);

      %Estimation Combined, with estimated HRF
      X = ds.ROIs{m}.run{i}.combinedmatrix;
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
