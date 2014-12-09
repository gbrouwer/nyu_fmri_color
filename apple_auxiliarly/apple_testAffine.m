function apple_testAffine


%Init
clc;


%Create points
x = normrnd(0,2,20,2);


%Transformation Matrix
angle = 5/180*pi;
T = [cos(angle) -sin(angle) ;  sin(angle) cos(angle)];



%Add Noise to T
n = normrnd(0,0.1,2,2);
T = T + n;



%Orthogonalize and normalize
N = cgrscho(T);
T = N;



%Inner product
innerprod = T(:,1)' * T(:,2);
norm(T(:,1))
norm(T(:,2))







a = rand(10,100);
[pc,scores] = princomp(a);


%Create New Data
y = x * T;



scatter(x(:,1),x(:,2),50,[1 0 0],'filled');
hold on;
grid on;
box on;
scatter(y(:,1),y(:,2),50,[0 1 0],'filled');
