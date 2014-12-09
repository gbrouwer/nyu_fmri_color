function ds = apple_createforwardmodel_2channels(ds)


%Create Channels
ds.channels = [];
ds.idealizedchannel = sin(linspace(0,2*pi,361));
ds.idealizedchannel = ds.idealizedchannel(1:end-1);
ds.idealizedchannel = ds.idealizedchannel .^ (ds.nChannels-1);
ds.channels = zeros(ds.nChannels,360);
for i=1:ds.nChannels
	shift = round((i-1)*180/ds.nChannels);
	ds.channels(i,:) = circshift(ds.idealizedchannel,[0 shift]);
end



%Create Forward Model
angles = linspace(0,360,ds.param.nClasses+1);
angles = angles(1:end-1);
ds.angles = angles;
ds.forwardmodel = repmat(ds.channels(:,round(angles)+1)',ds.param.nRuns,1);
ds.theseangles = repmat((round(angles)+1)',ds.param.nRuns,1);


