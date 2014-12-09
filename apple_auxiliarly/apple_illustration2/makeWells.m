function makeWells


%Init
sigma = 0.15;
res = 300;



%Create Meshgrid
[X,Y] = meshgrid(linspace(-1,1,res),linspace(-1,1,res));
Z = X;
Z(:) = 0;

%Create 5 Wells
W = Z;
angles = linspace(0,360,6);
for i=1:5
  angle = angles(i) / 180 * pi;
  x = sin(angle) * 0.5;
  y = cos(angle) * 0.5;
  
  xval = normpdf(linspace(-1,1,res),x,sigma);
  yval = normpdf(linspace(-1,1,res),y,sigma);
  W = W - xval'*yval;
  
end
W = W ./ min(W(:));
W = -W ./ 3;


%Write to File
fvc = surf2patch(X,Y,W,'triangles');
faces = fvc.faces;
vertices = fvc.vertices;
save('model.mat','faces','vertices');


