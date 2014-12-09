function apple_tomat

[vertices,faces] = read_ply('test4.ply');
scatter3(vertices(:,1),vertices(:,2),vertices(:,3),'filled');
save('model','vertices','faces');