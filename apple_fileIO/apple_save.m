function ds = apple_save(ds,algorithms)

if (algorithms.save == 1)

  
    %Run for each ROI in project
    disp('Running apple_save');
    for r=1:numel(ds.saveROIs)

      %Clear variables
      os.combinedbetas = [];
      os.combinedR = [];
      os.classbetas = [];
      os.classR = [];
      os.HRF = [];
      os.HRFrsquare = [];
      os.classlabels = [];
      os.runlabels = [];
 
       
      %Selected ROIs
      selectedROI = ds.saveROIs{r};
      ROIindices = [];
      for i=1:ds.param.nROIs
        ROIname = ds.ROIs{i}.name;
        if ~isempty(strfind(selectedROI,' '))
          val = [0 strfind(selectedROI,' ') numel(selectedROI)+1];
          for z=1:numel(val)-1
            str = selectedROI(val(z)+1:val(z+1)-1);
            if ~isempty(strfind(lower(ROIname),lower(str)))
              if strcmpi(str,'v3')
                if (strcmpi(ROIname(end-1:end),'ab'))
                else
                  ROIindices = [ROIindices i];
                  disp(['     ROI selected for saving : ' ROIname]);
                end
              else
                ROIindices = [ROIindices i];
                disp(['     ROI selected for saving : ' ROIname]);
              end
            end
          end
        else
          if ~isempty(strfind(lower(ROIname),lower(selectedROI)))
            if (strcmp(selectedROI,'v3') || strcmp(selectedROI,'mt'))
              if (strcmp(selectedROI,'v3'))
                if (strcmpi(ROIname(end-1:end),'ab'))
                else
                  ROIindices = [ROIindices i];
                  disp(['     ROI selected for saving : ' ROIname]);
                end
              end
              if (strcmp(selectedROI,'mt'))
                if (strcmpi(ROIname(end-1:end),'us'))
                else
                  ROIindices = [ROIindices i];
                  disp(['     ROI selected for saving : ' ROIname]);
                end
              end
            else
              ROIindices = [ROIindices i];
              disp(['     ROI selected for saving : ' ROIname]);
            end
          end
        end
      end
      disp('     ----------------------------------');  
      
      %Combine data
      for b=1:ds.param.nRuns

        %Reset Matrices
        tmp.combinedbetas = [];
        tmp.combinedR = [];
        tmp.classbetas = [];
        tmp.classR = [];
        tmp.HRF = [];
        tmp.HRFrsquare = [];
        thesecoords = [];
        thesescancoords = [];
        theseflatcoords = [];
        thesexform = [];
        theseidentifier = [];
  
 
        %Concatenate
        for m=1:numel(ROIindices)

          %Get ROI information
          
          thesecoords = [thesecoords ds.ROIs{ROIindices(m)}.coords];
          thesescancoords = [thesescancoords ds.ROIs{ROIindices(m)}.scancoords];
          theseflatcoords = [theseflatcoords ds.ROIs{ROIindices(m)}.flatMapCoords'];
          thesexform = ds.ROIs{ROIindices(m)}.xform;
          thesescan2roi = ds.ROIs{ROIindices(m)}.scan2roi;

          %Store
          tmp.HRF = [tmp.HRF ds.ROIs{ROIindices(m)}.run{b}.deconv.HRF];
          tmp.HRFrsquare = [tmp.HRFrsquare ds.ROIs{ROIindices(m)}.run{b}.deconv.HRFrsquare];
          tmp.classbetas = [tmp.classbetas ds.ROIs{ROIindices(m)}.run{b}.classbetas(1:ds.param.nClasses,:)];
          tmp.classR = [tmp.classR ds.ROIs{ROIindices(m)}.run{b}.classR];
          tmp.combinedbetas = [tmp.combinedbetas ds.ROIs{ROIindices(m)}.run{b}.combinedbetas(1,:)];
          tmp.combinedR = [tmp.combinedR ds.ROIs{ROIindices(m)}.run{b}.combinedR];
           
        end
        
        %Stack
        os.run{b}.trials = ds.run{b}.trials;
        os.param.RGB = ds.param.RGB;
        os.param.DKL = ds.param.DKL;
        os.param.coords = thesecoords;
        os.param.flatcoords = theseflatcoords;
        os.param.scancoords = thesescancoords;
        os.param.xform = thesexform;
        os.HRF(b,:,:) = tmp.HRF;
        os.HRFrsquare(b,:) = tmp.HRFrsquare;
        os.classbetas = [os.classbetas ; tmp.classbetas];
        os.classR = [os.classR ; tmp.classR];
        os.combinedbetas = [os.combinedbetas ; tmp.combinedbetas];
        os.combinedR = [os.combinedR ; tmp.combinedR];
        os.classlabels = [os.classlabels 1:ds.param.nClasses];
        os.runlabels = [os.runlabels ones(1, ds.param.nClasses).*b];
      
      end

      %PCA
      [pc,scores,latent] = princomp(os.classbetas);
      os.scorebetas = scores;
      os.latent = latent;
      
      %Save it
      clear tmp;
      os.session = ds.session;
      os.rootdir = ds.rootdir;
      path = cd;
      savedir = [path '/apple_ROIdata/' selectedROI];
      if (exist(savedir) ~= 7)
        mkdir(savedir);
      end
      savename = [path '/apple_ROIdata/' selectedROI '/' ds.session '_' selectedROI '.mat'];
      save(savename,'os');
      
    end
     
end
