function ds = apple_create_channels(ds)


%Create Channels
ds.channels = [];
ds.idealizedchannel = sin(linspace(0,pi,361));
ds.idealizedchannel = ds.idealizedchannel(1:end-1);
ds.idealizedchannel = ds.idealizedchannel .^ (ds.nChannels-1);
ds.channels = zeros(ds.nChannels,360);
for i=1:ds.nChannels
  shift = round((i-1)*360/ds.nChannels);
  ds.channels(i,:) = circshift(ds.idealizedchannel,[0 shift]);
end