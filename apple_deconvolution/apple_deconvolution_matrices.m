function ds = apple_deconvolution_matrices(ds,algorithms)


%Create Deconvolution Matrices
if (algorithms.deconvolution_matrices == 1)

    %Verbose
    disp('Running apple_deconvolution_matrices');
    
    %Create matrices for Deconvolution
    ds.param.hrflength = 12;
    ds.param.nClasses = max(ds.run{1}.trials(:,1)) - 1;
    for i=1:ds.param.nRuns
        nVols = size(ds.ROIs{1}.run{i}.rawdata,1);
        ds.run{i}.deconv.X = zeros(ds.param.hrflength,nVols);
        for m=1:ds.param.nClasses
            dum = (ds.run{i}.trials(:,1) == m);
            pos = (ds.run{i}.trials(dum,5) / 1000 / ds.param.tr) + 1;
            for l=1:numel(pos)
                for p=1:ds.param.hrflength
                    ds.run{i}.deconv.X(p,pos(l)+p-1) = 1;
                end
            end
        end
        ds.run{i}.deconv.X = ds.run{i}.deconv.X(:,1:nVols);
    end
    
    
    %Save and Return
    ds.rootdir = '/Local/Users/gbrouwer/Toolboxes/Apple/';
    save(ds.savename,'ds');
    cd([ds.rootdir]);
    
end
