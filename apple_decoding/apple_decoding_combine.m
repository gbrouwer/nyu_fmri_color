function ds = apple_decoding_combine(sessions,corrected,combined,selectedROI,constrain,visible,level,subject)


%Init
load('cerulean_LCD at scanner - 10262010');
disp(['Running decoding combined on : ' selectedROI]);
cs = ds;ds = [];
ds.constrainlevel = constrain;
ds.sessions = sessions;
ds.selectedROI = selectedROI;
ds.combined = combined;
ds.corrected = corrected;
ds.nChannels = 6;
ds.visible = visible;
ds.nRandomizations = 100;




%Gather data
ds = apple_decoding_gatherdata(ds);




%Create Forward Model
ds = apple_createforwardmodel(ds);




%Forward Model
ds = apple_forwardmodel(ds,level);




%Save
savename = ['apple_results/' subject '_' selectedROI '_' num2str(level) '.mat'];
save(savename,'ds');
