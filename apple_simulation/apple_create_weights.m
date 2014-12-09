function ds = apple_create_weights(ds)


%Create simulated weights
for i=1:ds.nVoxels
  ds.weights(i,:) = rand(ds.nChannels,1);
  ds.weights(i,:) = ds.weights(i,:) ./ sum(ds.weights(i,:));
end


