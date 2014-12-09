function ds = apple_deconvolve_classes(ds,algorithms)


if (algorithms.deconvolve_classes == 1)

    %Verbose
    disp('Running apple_deconvolve');
    
    %Deconvolve
    for m=1:ds.param.nROIs
 
        %Verbose
        ds.ROIs{m}.deconv.HRFc = [];
        disp(['     Deconvolving ROI : ' ds.ROIs{m}.name]);
        for p=1:ds.param.nRuns
          
            %Get Data
            Y = ds.ROIs{m}.run{p}.rawdata - 1;
            [nVols,nVoxels] = size(Y);

            %Actual Deconvolution
            X = ds.run{p}.deconv.Xc;
            ds.ROIs{m}.run{p}.deconv.HRFc = X' \ Y;

            %Calculate Rsquare
            predY = X' * ds.ROIs{m}.run{p}.deconv.HRFc;    
            SStot = sum((Y - repmat(mean(Y),nVols,1)).^2);
            SSerr = sum((Y - predY).^2);
            ds.ROIs{m}.run{p}.deconv.HRFrsquarec = 1 - (SSerr ./ SStot);
            
        end

    end
    
    %Save and Return
    save(ds.savename,'ds');
    cd([ds.rootdir]);
    
end

