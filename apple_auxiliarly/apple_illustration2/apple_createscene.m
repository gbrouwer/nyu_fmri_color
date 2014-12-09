function apple_createscene

%Init
fid = fopen('apple.rad','w');
load('cerulean_LCD at scanner - 10262010');
wallspec = 0.00;
floorspec = 0.00;




%Create Light Source 1
lightsource = [0.5 0.5 0.5];
light1_var = [0 0 12 2];
fprintf(fid,'void light this_lightsource\n0\n0\n');
fprintf(fid,'%d\t%d\t%d\t%d\n\n',3,lightsource*40);
fprintf(fid,'this_lightsource sphere fixture\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',4,light1_var);



%Create Light Source 2
lightsource = [0.5 0.5 0.5];
light1_var = [0 0 12 2];
fprintf(fid,'void light this_lightsource\n0\n0\n');
fprintf(fid,'%d\t%d\t%d\t%d\n\n',3,lightsource*40);
fprintf(fid,'this_lightsource sphere fixture\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',4,light1_var);




%Floor 1
floor_color = [0.5 0.5 0.5];
floor_rot = [0 0 0];
floor_size = [800 800 1];
floor_shift = [10 -400 0];
floor_string = sprintf('!genbox thismaterial name %f %f %f | xform  -t %f %f %f -rx %f -ry %f  -rz %f ',floor_size,floor_shift ,floor_rot);
fprintf(fid,'void plastic thismaterial\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,floor_color,floorspec,00);
fprintf(fid,'%s\n\n',floor_string);


%Floor 1
floor_color = [0.5 0.5 0.5];
floor_rot = [0 0 0];
floor_size = [800 80 1];
floor_shift = [-100 11 0];
floor_string = sprintf('!genbox thismaterial name %f %f %f | xform  -t %f %f %f -rx %f -ry %f  -rz %f ',floor_size,floor_shift ,floor_rot);
fprintf(fid,'void plastic thismaterial\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,floor_color,floorspec,00);
fprintf(fid,'%s\n\n',floor_string);


%Floor 1
floor_color = [0.5 0.5 0.5];
floor_rot = [0 0 0];
floor_size = [800 80 1];
floor_shift = [-100 -92 0];
floor_string = sprintf('!genbox thismaterial name %f %f %f | xform  -t %f %f %f -rx %f -ry %f  -rz %f ',floor_size,floor_shift ,floor_rot);
fprintf(fid,'void plastic thismaterial\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,floor_color,floorspec,00);
fprintf(fid,'%s\n\n',floor_string);



%Material
vertices = [];
faces = [];
load('model.mat');
thiscolor = [0.5 0.5 0.5];
fprintf(fid,'void plastic thismaterial\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,floorspec,0);




%Floor
[e1,e2] = size(faces);
for m=1:1:e1

  face_index = faces(m,:);
  pos1 = vertices(face_index(1),:);
  pos2 = vertices(face_index(2),:);
  pos3 = vertices(face_index(3),:);

  pos1 = pos1 * 12;
  pos1(1) = pos1(1) + -1.5;
  pos1(2) = -pos1(2);
  pos1(3) = pos1(3) + 1; 

  pos2 = pos2 * 12;
  pos2(1) = pos2(1) + -1.5;
  pos2(2) = -pos2(2);
  pos2(3) = pos2(3) + 1;

  pos3 = pos3 * 12;
  pos3(1) = pos3(1) + -1.5;
  pos3(2) = -pos3(2);
  pos3(3) = pos3(3) + 1;

  fprintf(fid,'%s\n0\n0\n%d\n','thismaterial polygon thispolygon',9);
  fprintf(fid,'\t%f\t%f\t%f\n\t%f\t%f\t%f\n\t%f\t%f\t%f\n',pos1,pos2,pos3);

end











%Sphere 1
angles = [0 5 10 15 20];


count = 0;
nBalls = 5;
for i=1:5
  
  %Outer Angle
  angle = (i-1) / 5 * 360;
  angle = angle / 180 * pi;
  x = cos(angle)*1.2;
  y = sin(angle)*1.2;
  posx = (x*5)-1.5;
  posy = (y*5)-0.0;
  
  
  
  
  if (i == 1)
    colorangle = 250;
    cs = linspace(colorangle-30,colorangle+30,5);
    cs = cs / 180 * pi;
  end
  if (i == 2)
    colorangle = 310;
    cs = linspace(colorangle-15,colorangle+15,5);
    cs = cs / 180 * pi;
  end
  if (i == 3)
    colorangle = 0;
    cs = linspace(colorangle-20,colorangle+20,5);
    cs = cs / 180 * pi;
  end
  if (i == 4)
    colorangle = 80;
    cs = linspace(colorangle-20,colorangle+20,5);
    cs = cs / 180 * pi;
  end
  if (i == 5)
    colorangle = 140;
    cs = linspace(colorangle-20,colorangle+20,5);
    cs = cs / 180 * pi;
  end
  
  
  
  %Inner outer
  for j=1:nBalls
    x = cos(cs(j))*0.3;
    y = sin(cs(j))*1.0;
    ds.DKL = [0 x y];
    ds = cerulean_DKL2ALL(ds);
    thiscolor = ds.RGB;
    
    angle = (j-1) / nBalls * 360;
    angle = angle / 180 * pi;
    x1 = cos(angle);
    y1 = sin(angle);
    posx1 = posx + (x1*1.05);
    posy1 = posy + (y1*1.05);

    %fprintf(fid,'void glass mat%s\n0\n0\n',num2str(count));
    %fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\n\n',3,thiscolor);
    
    fprintf(fid,'void plastic mat%s\n0\n0\n',num2str(count));
    fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0.001,0);
    s = ['mat' num2str(count) ' sphere s1'];
    fprintf(fid,'%s\n0\n0\n',s);
    fprintf(fid,'%d\t%f\t%f\t%f\t%f\n\n',4,posx1,posy1,-1.53,0.6);

  end
  x = cos(cs(5))*0.3;
  y = sin(cs(5))*1.0;
  ds.DKL = [0 x y];
  ds = cerulean_DKL2ALL(ds);
  thiscolor = ds.RGB;
  fprintf(fid,'void plastic mat%s\n0\n0\n',num2str(count));
  fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0.001,0);
  s = ['mat' num2str(count) ' sphere s1'];
  fprintf(fid,'%s\n0\n0\n',s);
  fprintf(fid,'%d\t%f\t%f\t%f\t%f\n\n',4,posx,posy,-2.1,0.6);
  
  
  
  
end





% %Spheres
% count = 0;
% 
% %angles = [15 35 55 75 120 150 190 210 240 260 300 330]
% %angles = [15 35 55 75 130 150 180 0 0 0 300 330]
% angles = linspace(0,360,13);
% angles
% angles = angles(1:end-1);
% angles = angles ./ 180 * pi
% angles = angles;
% for i=1:numel(angles)
%   angle = angles(i);
%   angle = angles(i);
%   x = sin(angle);
%   y = cos(angle);
%   count = count + 1;
%   posx = x*6;
%   posy = y*6;
% 
%   angle = angles(i) - 0.2;
%   x = sin(angle);
%   y = cos(angle);
%   
%   ds.DKL = [0 x*0.25 y];
%   ds = cerulean_DKL2ALL(ds);
%   thiscolor = ds.RGB;
%   %fprintf(fid,'void plastic mat%s\n0\n0\n',num2str(count));
%   %fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0,0.00);
% 
%   %thiscolor = [0.75 0.75 0.75];
%   fprintf(fid,'void metal mat%s\n0\n0\n',num2str(count));
%   fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0,20);
%   s = ['mat' num2str(count) ' sphere s1'];
%   fprintf(fid,'%s\n0\n0\n',s);
%   fprintf(fid,'%d\t%f\t%f\t%f\t%f\n\n',4,posx,posy,1.75,0.75);
% 
% end
% 
% 
% 
% 
% 
% 
% 
% % 
% % %Inner Sphere
% % posx = 0;
% % posy = 0;
% % thiscolor = [0.75 0.75 0.75];
% % fprintf(fid,'void glass mat%s\n0\n0\n',num2str(count));
% % fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\n\n',3,thiscolor);
% % %fprintf(fid,'void plastic mat%s\n0\n0\n',num2str(count));
% % %fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0.2,0);
% % s = ['mat' num2str(count) ' sphere s1'];
% % fprintf(fid,'%s\n0\n0\n',s);
% % fprintf(fid,'%d\t%f\t%f\t%f\t%f\n\n',4,posx,posy,3,2.0);
% % 
% 
% 
% %fprintf(fid,'void glass thismaterial\n0\n0\n');
% %fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\n\n',3,thiscolor);


%Close
fclose(fid);
