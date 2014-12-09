function ds = apple_designmatrices_alternative(ds,algorithms)

if (algorithms.designmatrices == 1)

    
  %Verbose
  ds.designmatrix_filtering = 0;
  ds.param.nBasis = 2;
  disp('Running apple_designmatrices');
    
  
  %Create Filter
  [ds.nVols,dum] = size(ds.ROIs{1}.run{1}.rawdata);
  ds = apple_createfilter(ds);   
  
  
  %Create Basis functions
  basisfunctions = [ds.param.HRF' ds.param.temporalHRF' ds.param.dispersionHRF'];
  filter = repmat(ds.param.hipassfilter',1,2*ds.param.nBasis);
  
  
  %Create Matrices
  for i=1:ds.param.nRuns

    %Init Matrices
    disp(['     Create Design Matrices for Run : ' num2str(i)]);
    [nVols,dum] = size(ds.ROIs{1}.run{i}.rawdata);

    %Trial type specific matrices
    ds.run{i}.combinedmatrix = zeros(nVols*ds.param.supersampling,1);
    for j=1:ds.param.nClasses
      
      %Get the trial starts
      ds.run{i}.classmatrix{j} = zeros(nVols*ds.param.supersampling,2);
      dum1 = (ds.run{i}.trials(:,1) == j);
      dum2 = (ds.run{i}.trials(:,1) ~= j);
      pos1 = (ds.run{i}.trials(dum1,end) / 1000 / ds.param.tr * ds.param.supersampling + 1);
      pos2 = (ds.run{i}.trials(dum2,end) / 1000 / ds.param.tr * ds.param.supersampling + 1);
      
      %Fill Matrix
      for p=1:numel(pos1)
        ds.run{i}.classmatrix{j}(pos1(p):pos1(p)+1,1) = 1;
        ds.run{i}.combinedmatrix(pos1(p):pos1(p)+1,1) = 1;
      end
      for p=1:numel(pos2)
        ds.run{i}.classmatrix{j}(pos2(p):pos2(p)+1,2) = 1;
      end
      
      %Convolve
      matrix = [];
      for b=1:ds.param.nBasis
        matrix = [matrix conv2(ds.run{i}.classmatrix{j},basisfunctions(:,b))];
      end
      matrix = matrix(1:ds.param.supersampling:(nVols*ds.param.supersampling),:);
      ds.run{i}.classmatrix{j} = real(ifft(fft(matrix) .* filter));
      
    end
    
    %Combined Matrices
    matrix = [];
    for b=1:ds.param.nBasis
      matrix = [matrix conv2(ds.run{i}.combinedmatrix,basisfunctions(:,b))];
    end
    matrix = matrix(1:ds.param.supersampling:(nVols*ds.param.supersampling),:);
    ds.run{i}.combinedmatrix = real(ifft(fft(matrix) .* filter(:,1:ds.param.nBasis)));
    
  end


  
  %Plot Sample Design Matrices for visual inspection
  figure('Position',[1500 100 800 800],'Name',ds.session);
  subplot(2,2,1);
  imagesc(ds.run{1}.classmatrix{1});
  subplot(2,2,2);
  imagesc(ds.run{1}.combinedmatrix);
  colormap gray;
  subplot(2,2,[3 4]);
  plot(ds.run{1}.classmatrix{1}(:,1:(2*ds.param.nBasis)));
     
    
  %Save and Return
  save(ds.savename,'ds');
  cd([ds.rootdir]);  
  
end

