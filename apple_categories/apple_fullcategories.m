function apple_fullcategories


%Load data
clc;
load('cerulean_LCD at scanner - 10262010');
data = textread('data64/apple_aw5.txt');
store = data;
data = textread('data64/apple_ab5.txt');
store(:,end+1) = data(:,end);
data = textread('data64/apple_cs5.txt');
store(:,end+1) = data(:,end);
data = textread('data64/apple_gb5.txt');
store(:,end+1) = data(:,end);
data = textread('data64/apple_sj5.txt');
store(:,end+1) = data(:,end);
colors = textread('data64/apple_colors.txt');
colors = colors(:,1:3);




for i=1:64
  scatter(i,1,100,store(i,4:6),'filled');
  hold on;
end
for s=1:5
  cats = store(:,end-s+1);
  for c=1:5
    dum = (cats == c);
    indices = find(cats == c);
    meanc = mean(store(dum,4:6));
    for l=1:numel(indices)
      scatter(indices(l),s+1,100,meanc,'filled');
    end
  end
end





%Find closest Psychophysical neighbor
for i=1:12
  thiscolor = colors(i,1:3);
  differ = sum(abs(store(:,4:6) - repmat(thiscolor,64,1))');
  [minval,minindex(i)] = min(differ);
end
%store = store(minindex,4:end);
for i=1:numel(minindex)
  minindex(i)
  scatter(minindex(i),1,200,store(minindex(i),4:6),'filled');
  hold on;
end

% scatter(1:12,1:12,100,store(:,1:3),'filled');
% 
% 
% 
% 
% HW = squareform(pdist(store(:,end-5)));
% SJ = squareform(pdist(store(:,end-4)));
% GB = squareform(pdist(store(:,end-3)));
% CS = squareform(pdist(store(:,end-2)));
% AB = squareform(pdist(store(:,end-1)));
% AW = squareform(pdist(store(:,end-0)));
% AVERAGE = SJ + GB + CS + AB + AW + HW;
% 
% Z=linkage(AVERAGE)
% [H, T] = dendrogram(Z);
% %store
% 
% 
% 
% 
% hold on;grid on; box on; 
% for i=1:numel(H)
%   x = get(H(i),'XData');
%   y = get(H(i),'YData');
%   set(H(i),'Color',[0 0 0]);
%   if (Z(i,1) < 13 && Z(i,2) < 13)
%     colors(Z(i,1),:)
%     h = scatter(x(1),0,'filled');
%     set(h,'MarkerEdgeColor',colors(Z(i,1),:),'MarkerFaceColor',colors(Z(i,1),:));
%     h = scatter(x(4),0,'filled');
%     set(h,'MarkerEdgeColor',colors(Z(i,2),:),'MarkerFaceColor',colors(Z(i,2),:));
%   end
% end
% axis([0 13 -1 25]);
% 
% 
% 
% % for i=1:64
% %   for j=1:64
% %     val1 = store(i,end-4:end);
% %     val2 = store(j,end-4:end);
% %     dis(i,j) = sum(val1 == val2) ./ numel(val1);
% %   end
% % end
% % dis = 1 - dis;
% % 
% % dis = circshift(dis,[4 4]);
% % imagesc(dis);
% % 
% % 
% % 
% % % %Distance Matrix
% % % SJ = squareform(pdist(store(:,end-4)));
% % % AW = squareform(pdist(store(:,end-3)));
% % % CS = squareform(pdist(store(:,end-2)));
% % % GB = squareform(pdist(store(:,end-1)));
% % % HW = squareform(pdist(store(:,end-0)));
% % % AVERAGE = SJ + AW + CS + GB + HW;
% % % 
% % % 
% % % 
% % % %Categories
% % % categories = [ones(1,10) repmat(2,1,9) repmat(3,1,10) repmat(4,1,11) repmat(5,1,20) ones(1,4)];
% % % 
% % 
% % % 
% % % %Plot
% % % catColors(1,:) = [1 0 1];
% % % catColors(2,:) = [1 0 0];
% % % catColors(3,:) = [1 1 0];
% % % catColors(4,:) = [0 1 0];
% % % catColors(5,:) = [0 0 1];
% % % 
% % %
% % ds
% % a = linspace(0,2*pi,65);
% % a = a(1:end-1);
% % x = sin(linspace(0,2*pi,13));
% % y = cos(linspace(0,2*pi,13));
% % x = x(1:end-1);
% % y = y(1:end-1);
% % ds.DKL(:,2) = x * 0.33;
% % ds.DKL(:,3) = y * 1.25;
% % ds = cerulean_DKL2ALL(ds);
% % scatter(x*0.75*0.33,y*0.75*1.25,50,ds.RGB,'filled');
% % hold on;
% % % 
% % % % 
% % % % scatter(store(:,2),store(:,3),50,store(:,4:6),'filled');
% % % % box on; grid on; hold on;
% % % % hold on;
% % % % for j=1:5
% % % %   for i=1:5
% % % %     dum = (store(:,end-j+1) == i);
% % % %     xmean = cos(circ_mean(a(dum)))
% % % %     ymean = sin(circ_mean(a(dum)))
% % % %     ds.DKL = [0 xmean*0.25 ymean*1.25];
% % % %     ds = cerulean_DKL2ALL(ds);
% % % %     scatter(store(dum,2)*(1+j/5),store(dum,3)*(1+j/5),50,ds.RGB,'filled');
% % % %   end
% % % % end
% % % % 
% % % % 
% % figure;hold on;
% % val = store(:,4:6);
% % val = circshift(val,[14 0])
% % for i=1:64
% %   h = scatter(i,7,'filled');
% %   set(h,'MarkerEdgeColor',val(i,:),'MarkerFaceColor',val(i,:));
% % end
% % 
% % round(mean(val) .* 255)
% % 
% % 
% % % box on; grid on; hold on;
% % % hold on;
% % % for j=1:5
% % %   for i=1:5
% % %     dum = (store(:,end-j+1) == i);
% % %     xmean = cos(circ_mean(a(dum)));
% % %     ymean = sin(circ_mean(a(dum)));
% % %     ds.DKL = [0 xmean*0.25 ymean*1.25];
% % %     ds = cerulean_DKL2ALL(ds);
% % %     val = find(dum == 1);
% % %     for l=1:numel(val)
% % %       h = scatter(val(l),j,'filled');
% % %       set(h,'MarkerEdgeColor',ds.RGB,'MarkerFaceColor',ds.RGB);
% % %     end
% % %   end
% % %  end
% % % 
% % % 
% % % 
% % % 
% % % 
% % % 
