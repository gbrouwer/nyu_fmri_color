function saffron_categories

clc;
load('cerulean_LCD at scanner - 10262010');


load('saffron_categories_sj.mat');

for i=1:1
  for j=1:1
    val1 = totmatrix(i,:)
    val2 = totmatrix(j,:)
  end
end





% matrix = matrix + totmatrix;
% load('saffron_categories_gb.mat');
% [maxval,maxindex] = max(totmatrix');
% totmatrix = totmatrix ./ max(totmatrix(:));
% matrix = matrix + totmatrix;
% load('saffron_categories_sj.mat');
% [maxval,maxindex] = max(totmatrix');
% totmatrix = totmatrix ./ max(totmatrix(:));
% matrix = matrix + totmatrix;
% load('saffron_categories_cs.mat');
% [maxval,maxindex] = max(totmatrix');
% totmatrix = totmatrix ./ max(totmatrix(:));
% matrix = matrix + totmatrix;
% load('saffron_categories_ab.mat');
% totmatrix = totmatrix ./ max(totmatrix(:));
% [maxval,maxindex] = max(totmatrix');
% matrix = matrix + totmatrix;




% colors = textread('saffron_colors_logfile.txt');
% ds.DKL = [];
% ds.DKL(:,2) = colors(:,2) * 0.33;
% ds.DKL(:,3) = colors(:,3) * 1.25;
% angles = atan2(colors(:,2),colors(:,3));
% angles(angles < 0) = angles(angles < 0) + 2*pi;
% ds = cerulean_DKL2ALL(ds);
% stim = ds.RGB;
% 
% 
% 
% Cat(1) = mean(angles(1:4));
% Cat(2) = angles(5);
% Cat(3) = angles(6);
% Cat(4) = mean(angles(7:10));
% Cat(5) = mean(angles(10:12));
% 
% ds.DKL = [];
% ds.DKL(:,2) = sin(Cat) * 0.33;
% ds.DKL(:,3) = cos(Cat) * 1.25;
% ds = cerulean_DKL2ALL(ds);
% cat = ds.RGB;
% 
% 
% 
% %Line
% hold on;
% plot([sin(Cat(1))*0.5 sin(angles(1))],[cos(Cat(1))*0.5 cos(angles(1))],'k');
% plot([sin(Cat(1))*0.5 sin(angles(2))],[cos(Cat(1))*0.5 cos(angles(2))],'k');
% plot([sin(Cat(1))*0.5 sin(angles(3))],[cos(Cat(1))*0.5 cos(angles(3))],'k');
% plot([sin(Cat(1))*0.5 sin(angles(4))],[cos(Cat(1))*0.5 cos(angles(4))],'k');
% plot([sin(Cat(2))*0.5 sin(angles(5))],[cos(Cat(2))*0.5 cos(angles(5))],'k');
% plot([sin(Cat(3))*0.5 sin(angles(6))],[cos(Cat(3))*0.5 cos(angles(6))],'k');
% plot([sin(Cat(4))*0.5 sin(angles(7))],[cos(Cat(4))*0.5 cos(angles(7))],'k');
% plot([sin(Cat(4))*0.5 sin(angles(8))],[cos(Cat(4))*0.5 cos(angles(8))],'k');
% plot([sin(Cat(4))*0.5 sin(angles(9))],[cos(Cat(4))*0.5 cos(angles(9))],'k');
% plot([sin(Cat(4))*0.5 sin(angles(10))],[cos(Cat(4))*0.5 cos(angles(10))],'k');
% plot([sin(Cat(5))*0.5 sin(angles(10))],[cos(Cat(5))*0.5 cos(angles(10))],'k');
% plot([sin(Cat(5))*0.5 sin(angles(11))],[cos(Cat(5))*0.5 cos(angles(11))],'k');
% plot([sin(Cat(5))*0.5 sin(angles(12))],[cos(Cat(5))*0.5 cos(angles(12))],'k');
% 
% 
% 
% 
% S = ones(12,1).*50;
% h = scatter(sin(angles),cos(angles),S,stim,'filled');
% h = get(h,'Children');set(h,'MarkerSize',10);
% axis([-1.5 1.5 -1.5 1.5]);
% grid on; box on; hold on;
% 
% 
% for i=1:5
%   h = scatter(sin(Cat(i))*0.5,cos(Cat(i))*0.5,'filled');
%   set(h,'MarkerEdgeColor',cat(i,:),'MarkerFaceColor',cat(i,:));
%   h = get(h,'Children');set(h,'MarkerSize',15);
% end
% 
% 
