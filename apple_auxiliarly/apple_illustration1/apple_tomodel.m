function apple_tomodel


%Load
load('gb_right_GM.mat');
vertices1 = (base.coordMap.innerVtcs + base.coordMap.outerVtcs)/2;
faces1 = base.coordMap.tris;
load('gb_left_GM.mat');
vertices2 = (base.coordMap.innerVtcs + base.coordMap.outerVtcs)/2;
faces2 = base.coordMap.tris;


%Concatenate
index = size(vertices1,1);
faces2 = faces2 + index;
vertices = [vertices1; vertices2];
faces = [faces1 ; faces2];



%Normalize
mv = mean(vertices);
vertices(:,1) = vertices(:,1) - mv(1);
vertices(:,2) = vertices(:,2) - mv(2);
vertices(:,3) = vertices(:,3) - mv(3);
mv = max(vertices(:));
vertices(:,1) = vertices(:,1) / mv;
vertices(:,2) = vertices(:,2) / mv;
vertices(:,3) = vertices(:,3) / mv;



%Save and Write
save('model','vertices','faces');
write_ply(vertices,faces,'test.ply');