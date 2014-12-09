function apple_worph

load('apple_clustering_group_100_lh');
lh = os;
load('apple_clustering_group_100_rh');
rh = os;

rh.ratios = squeeze(mean(rh.ratios,2))
lh.ratios = squeeze(mean(lh.ratios,2))
subplot(2,2,1);
bar(rh.ratios)
subplot(2,2,2);
bar(lh.ratios)