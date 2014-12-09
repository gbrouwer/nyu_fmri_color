function ds = apple_logfiles(ds,algorithms)

%Read the logfiles
if (algorithms.logfiles == 1)

        %Verbose
        disp(['Running apple_logfiles']);

    
        %Access directory
        cd([ds.projectdir '/' ds.session]);
        cd('Etc');

        
        %Read Logfiles
        categorization = [];
        for i=1:ds.param.nRuns

          
            %Trials
            path = cd;
            loadname = [path '/Saffron-Logfile' num2str(i) '.txt'];
            disp(['     Reading from : ' loadname]);
            fid = fopen(loadname,'r');
            if (fid == -1)
              disp(['   ' loadname ' not found! Check directory']);
            else
              tline = fgetl(fid);
              ds.run{i}.logfilename = loadname;
              ds.run{i}.nTrials = str2num(tline);
              for j=1:ds.run{i}.nTrials
                  tline = fgetl(fid);
                  ds.run{i}.trials(j,:) = sscanf(tline,'%f %f %f %f %f %f %f');
              end
              fclose(fid);

            end

            %Number of Trials
            max(ds.run{1}.trials(:,1)) - 1;
            ds.param.nClasses = max(ds.run{1}.trials(:,1)) - 1;
            
        end

        
        %Get Colors
        ds.param.colors = textread('apple_colors.txt');
        ds.param.RGB = ds.param.colors(:,1:3);
        ds.param.DKL = ds.param.colors(:,4:6);
        
        
        %Get Full Path to runs
        cd ..
        if (exist('Filtered','dir') == 7)
          cd('Filtered');
        end
        if (exist('Concatenation','dir') == 7)
          cd('Concatenation');
        end
        cd('TSeries');
        fdir = dir;
        [r1,r2] = size(fdir);
        path = cd;
        count = 0;
        for i=3:r1
            fname = fdir(i).name;
            ext = fname(end-2:end);
            if (strcmp(ext,'img'))
                count = count + 1;
                ds.run{count}.filename = [path '/' fname];
            end
        end
        

        %Save and Return
        save(ds.savename,'ds');
        save(ds.initialname,'ds');
        cd([ds.rootdir]);

        
end
