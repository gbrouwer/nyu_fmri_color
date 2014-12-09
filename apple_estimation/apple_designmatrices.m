function ds = apple_designmatrices(ds,algorithms)

if (algorithms.designmatrices == 1)

    
  %Verbose
  disp('Running apple_designmatrices');
    
  
  %Create Binary Matrices
  ds.designmatrix_filtering = 0;
  ds.param.nBasis = 2;
  for i=1:ds.param.nRuns

    %Init Matrices
    disp(['     Create Design Matrices for Run : ' num2str(i)]);
    [nVols,dum] = size(ds.ROIs{1}.run{i}.rawdata);
    ds.run{i}.classmatrix = zeros(nVols*ds.param.supersampling,ds.param.nClasses);
    ds.run{i}.combinedmatrix = zeros(nVols*ds.param.supersampling,1);

    %Fill Matrices
    counter = 0;
    for j=1:ds.run{i}.nTrials
      thistrial = ds.run{i}.trials(j,:);
      if (thistrial(1) <= ds.param.nClasses)
        pos = (thistrial(5) / 1000 / ds.param.tr * ds.param.supersampling + 1);
        ds.run{i}.classmatrix(pos:pos+1,thistrial(1)) = 1;
        ds.run{i}.combinedmatrix(pos:pos+1,1) = 1;
        counter = counter + 1;
      end
    end

    %Create Filter
    ds.nVols = nVols;
    ds = apple_createfilter(ds);    
  
  end


  
  %Convolve
  for i=1:ds.param.nRuns
  
    %Loop through ROI
    for p=1:ds.param.nROIs


      %Get HRF
      hrf = ds.ROIs{p}.hrf;
      temporal = ds.ROIs{p}.temporal;
      dispersion = ds.ROIs{p}.dispersion;
      basisfunctions = [hrf temporal dispersion];
      filter = repmat(ds.param.hipassfilter',1,ds.param.nClasses*ds.param.nBasis);

%       %None-area specific
%       hrf = ds.param.HRF;
%       temporal = ds.param.temporalHRF;
%       dispersion = ds.param.dispersionHRF;
%       basisfunctions = [hrf' temporal' dispersion'];
      
      
      %Reset matrices
      ds.ROIs{p}.run{i}.classmatrix = [];
      ds.ROIs{p}.run{i}.combinedmatrix = [];
      
      
      %Class Matrices
      matrix = [];
      for b=1:ds.param.nBasis
        matrix = [matrix conv2(ds.run{i}.classmatrix,basisfunctions(:,b))];
      end
      matrix = matrix(1:ds.param.supersampling:(nVols*ds.param.supersampling),:);
      ds.ROIs{p}.run{i}.classmatrix = real(ifft(fft(matrix) .* filter));
      

      %Combined Matrices
      matrix = [];
      for b=1:ds.param.nBasis
        matrix = [matrix conv2(ds.run{i}.combinedmatrix,basisfunctions(:,b))];
      end
      matrix = matrix(1:ds.param.supersampling:(nVols*ds.param.supersampling),:);
      ds.ROIs{p}.run{i}.combinedmatrix = real(ifft(fft(matrix) .* filter(:,1:ds.param.nBasis)));
      
    end
    
  end
  
  
%   %Plot Sample Design Matrices for visual inspection
%   figure('Position',[1500 100 800 800],'Name',ds.session);
%   subplot(2,2,1);
%   imagesc(ds.ROIs{5}.run{1}.classmatrix);
%   subplot(2,2,2);
%   imagesc(ds.ROIs{5}.run{1}.combinedmatrix);
%   colormap gray;
%   subplot(2,2,[3 4]);
%   plot(ds.ROIs{5}.run{1}.classmatrix(:,1:ds.param.nClasses));
     
    
  %Save and Return
  save(ds.savename,'ds');
  cd([ds.rootdir]);  
  
end

