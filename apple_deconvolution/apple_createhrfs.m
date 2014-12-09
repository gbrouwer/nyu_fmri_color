function ds = apple_createhrfs(ds,algorithms)

if (algorithms.createhrfs == 1)
 
  %Verbose
  disp('Running apple_createhrfs');


  %Run through the HRFS of all ROIs
  ds.param.supersampling = 3;
  ds.param.HRFthreshold = 70;
  figure('Position',[100 100 1200 800],'Name',ds.session);
  for p=1:ds.param.nROIs

    
    %Fit HRFs
    disp(['     Fitting HRF for ROI : ' ds.ROIs{p}.name]);

    
    %Average R-squares
    HRFrsquare = [];
    for r=1:ds.param.nRuns
      HRFrsquare = [HRFrsquare ; ds.ROIs{p}.run{r}.deconv.HRFrsquare];
    end
    HRFrsquare = mean(HRFrsquare);
    startval = 0;
    constrain = 0;
    while (sum(constrain) < 2)
      constrain = HRFrsquare > prctile(HRFrsquare,ds.param.HRFthreshold-startval);
      startval = startval + 1;
    end
    
    
    %Average HRF
    HRFs = [];
    for r=1:ds.param.nRuns
      HRFs(:,:,r) = ds.ROIs{p}.run{r}.deconv.HRF(:,constrain)';
    end
    HRFs = mean(HRFs,3)';
    
    
    %Normalize HRFs
    [s1,s2] = size(HRFs);
    HRFs = HRFs - (repmat(HRFs(1,:),s1,1));
    HRFs = HRFs ./ (repmat(max(HRFs),s1,1));
        
    
    %Remove Large STD voxels
    val = std(HRFs);
    val = (val < prctile(val,80));
    HRFs = HRFs(:,val);
    s2 = size(HRFs,2);
    
    
    %Remove Nan/Inf entries
    [~,y1] = ind2sub(size(HRFs),find(isnan(HRFs)));
    [~,y2] = ind2sub(size(HRFs),find(isinf(HRFs)));
    indices = ones(s2,1);
    indices(y1) = 0;
    indices(y2) = 0;

    
    %Average
    HRFs = HRFs(:,logical(indices));
    HRFs = mean(HRFs,2);
    estHRF = interp(HRFs,ds.param.supersampling)';

    
    %SPM Fit
    maxIter = inf;
    xmin =  [1 4 0.25 0.25 1.5 0];
    x0   =  [6 16 0.5 0.5 6 0.0];
    xmax =  [9 20 1 1 9 0.1];

    optimParams = optimset('MaxIter',maxIter,'Display', 'off');
    fitparam = lsqnonlin(@apple_hrfresidual_spm,x0,xmin,xmax,optimParams,estHRF,ds);

    
    %Informed Basis function
    fitparam(end+1) = 24;
    [hrf,temporal,dispersion] = apple_informedbasis(fitparam,ds.param.tr,ds.param.supersampling);
    
    
    %Same Length
    hrf = hrf(1:numel(estHRF));
    temporal = temporal(1:numel(estHRF));
    dispersion = dispersion(1:numel(estHRF));


    %Zero slope
    hrf = hrf' - hrf(1);
    val = linspace(0,hrf(end),numel(hrf));
    hrf = hrf - val;
    temporal = temporal' - temporal(1);
    val = linspace(0,temporal(end),numel(temporal));
    temporal = temporal - val;
    dispersion = dispersion' - dispersion(1);
    val = linspace(0,dispersion(end),numel(dispersion));
    dispersion = dispersion - val;

    
    %Normalize to 1
    hrf = hrf ./ max(hrf);
    temporal = temporal ./ max(temporal);
    dispersion = dispersion ./ max(dispersion);


    %Store
    ds.ROIs{p}.estHRF = estHRF;
    ds.ROIs{p}.hrf = hrf';
    ds.ROIs{p}.temporal = temporal';
    ds.ROIs{p}.dispersion = dispersion';
 
    
    %Plot
    subplot(5,5,p);
    timeline = 0:(ds.param.tr/ds.param.supersampling):100;
    timeline = timeline(1:numel(estHRF));
    plot(timeline,hrf,'.-','Color',[1 0 0]);
    hold on; box on; grid on;
    plot(timeline,temporal,'.-','Color',[0.5 0 0]);
    plot(timeline,dispersion,'.-','Color',[1 0.5 0]);
    plot(timeline,estHRF,'.-','Color',[0 0 0]);
    title([ds.ROIs{p}.name(1:2) '-' ds.ROIs{p}.name(4:end) ': ' num2str(corr2(hrf,estHRF))]);
    axis([0 18 -1 1.5]);

  end
    
  
  %Create Canonical
  canHRF = [];
  cantemporalHRF = [];
  candispersionHRF = [];
  for p=1:ds.param.nROIs
    canHRF = [canHRF ds.ROIs{p}.hrf];
    cantemporalHRF = [cantemporalHRF ds.ROIs{p}.temporal];
    candispersionHRF = [candispersionHRF ds.ROIs{p}.dispersion];
  end
  canHRF = median(canHRF,2)';
  cantemporalHRF = median(cantemporalHRF,2)';
  candispersionHRF = median(candispersionHRF,2)';

  
  %Set to zero start and finish
  canHRF = canHRF - canHRF(1);
  canHRF = canHRF - linspace(0,canHRF(end),numel(canHRF));
  canHRF = canHRF ./ max(canHRF);
  cantemporalHRF = cantemporalHRF - cantemporalHRF(1);
  cantemporalHRF = cantemporalHRF - linspace(0,canHRF(end),numel(cantemporalHRF));
  cantemporalHRF = cantemporalHRF ./ max(cantemporalHRF);
  candispersionHRF = candispersionHRF - candispersionHRF(1);
  candispersionHRF = candispersionHRF - linspace(0,candispersionHRF(end),numel(candispersionHRF));
  candispersionHRF = candispersionHRF ./ max(candispersionHRF);


  %Store
  ds.param.HRF = canHRF;
  ds.param.temporalHRF = cantemporalHRF;
  ds.param.dispersionHRF = candispersionHRF;
  
  
  %Plot
  subplot(5,5,25);
  plot(timeline,canHRF,'.-','Color',[1 0 0]);
  hold on; box on; grid on;
  plot(timeline,cantemporalHRF,'.-','Color',[0.5 0 0]);
  plot(timeline,candispersionHRF,'.-','Color',[1 0.5 0]);
  title('Canonical HRF');
  axis([0 18 -1 1.5]);
  
    
  %Save and Return
  save(ds.savename,'ds');
  cd([ds.rootdir]);

  
end


