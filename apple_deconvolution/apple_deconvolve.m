function ds = apple_deconvolve(ds,algorithms)


if (algorithms.deconvolve == 1)

  %Verbose
  disp('Running apple_deconvolve');

  %Deconvolve
  for m=1:ds.param.nROIs

    %Verbose
    ds.ROIs{m}.deconv.HRF = [];
    disp(['     Deconvolving ROI : ' ds.ROIs{m}.name]);
    for p=1:ds.param.nRuns

      %Get Data
      Y = ds.ROIs{m}.run{p}.rawdata - 1;
      [nVols,nVoxels] = size(Y);
      X = ds.run{p}.deconv.X';
      M = ds.run{p}.motion;
      X = [X M];
      X(:,end+1) = 1;
      
      %Regularization
      R = eye(size(X,2));
      R(end,end) = 0;
      
      %Deconvolution
      ds.ROIs{m}.run{p}.deconv.HRF = inv((X' * X) + R) * X' * Y;
      
      %Calculate Rsquare
      predY = X * ds.ROIs{m}.run{p}.deconv.HRF;    
      SStot = sum((Y - repmat(mean(Y),nVols,1)).^2);
      SSerr = sum((Y - predY).^2);
      ds.ROIs{m}.run{p}.deconv.HRFrsquare = 1 - (SSerr ./ SStot);
      
      %Remove Motion Estimates
      ds.ROIs{m}.run{p}.deconv.HRF = ds.ROIs{m}.run{p}.deconv.HRF(1:ds.param.hrflength,:);

    end

  end

  %Save and Return
  save(ds.savename,'ds');
  cd([ds.rootdir]);
    
end

