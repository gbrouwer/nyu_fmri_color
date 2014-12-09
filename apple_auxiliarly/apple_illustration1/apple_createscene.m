function apple_createscene

%Init
fid = fopen('apple.rad','w');
load('cerulean_LCD at scanner - 10262010');
wallspec = 0.00;
floorspec = 0.5;




%Create Sky
%fprintf(fid,'!gensky 6 7 11.25 -a 39.1 -o 86.3 -m 75 +s\n\n');
%fprintf(fid,'skyfunc glow skyglow\n0\n0\n4\t0.8\t0.8\t1\t0\n');
%fprintf(fid,'skyglow source sky\n0\n0\n4\t0\t0\t1\t210\n\n');
%fprintf(fid,'skyfunc brightfunc winbright\n2 winxmit winxmit.cal\n0\n0\n\n');
%fprintf(fid,'winbright illum sky_illum\n0\n0\n3\t0.48\t0.48\t0.98\n\n');




%Create Light Source
lightsource = [0.5 0.5 0.5];
light1_var = [2 0 12 2];
fprintf(fid,'void light this_lightsource\n0\n0\n');
fprintf(fid,'%d\t%d\t%d\t%d\n\n',3,lightsource*40);
fprintf(fid,'this_lightsource sphere fixture\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',4,light1_var);



%Create Light Source
lightsource = [0.5 0.5 0.5];
light1_var = [-12 0 12 2];
fprintf(fid,'void light this_lightsource\n0\n0\n');
fprintf(fid,'%d\t%d\t%d\t%d\n\n',3,lightsource*40);
fprintf(fid,'this_lightsource sphere fixture\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',4,light1_var);




%Floor 1
floor_color = [0.5 0.5 0.5];
floor_rot = [0 0 0];
floor_size = [220 220 1];
floor_shift = [-60 -60 0];
floor_string = sprintf('!genbox thismaterial name %f %f %f | xform  -t %f %f %f -rx %f -ry %f  -rz %f ',floor_size,floor_shift ,floor_rot);
fprintf(fid,'void plastic thismaterial\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,floor_color,floorspec,00);
fprintf(fid,'%s\n\n',floor_string);


% for i=1:25
%   for j=1:25
%     floor_color = [0.5 0.5 0.5];
%     floor_rot = [0 0 0];
%     floor_size = [0.9 0.9 0.9]; 
%     floor_shift = [-i+12 -j+12 0];
%     floor_string = sprintf('!genbox thismaterial name %f %f %f | xform  -t %f %f %f -rx %f -ry %f  -rz %f ',floor_size,floor_shift ,floor_rot);
%     %fprintf(fid,'void plastic thismaterial\n0\n0\n');
%     %printf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,floor_color,floorspec,00);
%     fprintf(fid,'%s\n\n',floor_string);
%   end
% end
% 

% 
% 
% 
% fprintf(fid,'void glow royal_blue\n0\n0\n');
% fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',4,0.5,0.5,0.5,0);
% 
% 
% fprintf(fid,'royal_blue source background\n0\n0\n');
% fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',4,0,0,1,360);
% %'Sky'
% floor_color = [0.56 0.71 0.98];
% floor_color = [0.5 0.5 0.5];
% floor_rot = [0 0 45];
% floor_size = [1 400 400];
% floor_shift = [50 -100 -225];
% floor_string = sprintf('!genbox thismaterial name %f %f %f | xform  -t %f %f %f -rx %f -ry %f  -rz %f ',floor_size,floor_shift ,floor_rot);
% fprintf(fid,'void plastic thismaterial\n0\n0\n');
% fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,floor_color,0,00);
% fprintf(fid,'%s\n\n',floor_string);
% 
% 
% 
% 
% 
% 
% 
%Material
load('model.mat');
min(faces(:))
thiscolor = [1.0 1.0 1.0];
%fprintf(fid,'void plastic thismaterial\n0\n0\n');
%fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0,20);
fprintf(fid,'void glass thismaterial\n0\n0\n');
fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\n\n',3,thiscolor);


%Polygons
[e1,e2] = size(faces)
for m=1:1:e1

    fprintf(fid,'%s\n0\n0\n%d\n','thismaterial polygon thispolygon',9);
    face_index = faces(m,:);
    pos1 = vertices(face_index(1),:);
    pos2 = vertices(face_index(2),:);
    pos3 = vertices(face_index(3),:);

    pos1 = pos1([1 2 3]);
    pos1 = pos1 * 3.5;
    pos1(1) = pos1(1) + -1.5;
    pos1(2) = -pos1(2) + 0.5;
    pos1(3) = pos1(3) + 3; 

    pos2 = pos2([1 2 3]);
    pos2 = pos2 * 3.5;
    pos2(1) = pos2(1) + -1.5;
    pos2(2) = -pos2(2) + 0.5;
    pos2(3) = pos2(3) + 3;
     
    pos3 = pos3([1 2 3]);
    pos3 = pos3 * 3.5;
    pos3(1) = pos3(1) + -1.5;
    pos3(2) = -pos3(2) + 0.5;
    pos3(3) = pos3(3) + 3;
    
    fprintf(fid,'\t%f\t%f\t%f\n\t%f\t%f\t%f\n\t%f\t%f\t%f\n',pos1,pos2,pos3);
end

% 
% 
% 
% 
% 
%Spheres
count = 0;

%angles = [15 35 55 75 120 150 190 210 240 260 300 330]
%angles = [15 35 55 75 130 150 180 0 0 0 300 330]
angles = linspace(0,360,13);
angles
angles = angles(1:end-1);
angles = angles ./ 180 * pi
angles = angles;
for i=1:numel(angles)
  angle = angles(i);
  angle = angles(i);
  x = sin(angle);
  y = cos(angle);
  count = count + 1;
  posx = x*6;
  posy = y*6;

  angle = angles(i) - 0.2;
  x = sin(angle);
  y = cos(angle);
  
  ds.DKL = [0 x*0.25 y];
  ds = cerulean_DKL2ALL(ds);
  thiscolor = ds.RGB;
  %fprintf(fid,'void plastic mat%s\n0\n0\n',num2str(count));
  %fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0,0.00);

  %thiscolor = [0.75 0.75 0.75];
  fprintf(fid,'void metal mat%s\n0\n0\n',num2str(count));
  fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0,20);
  s = ['mat' num2str(count) ' sphere s1'];
  fprintf(fid,'%s\n0\n0\n',s);
  fprintf(fid,'%d\t%f\t%f\t%f\t%f\n\n',4,posx,posy,1.75,0.75);

end

% 
% %Inner Sphere
% posx = 0;
% posy = 0;
% thiscolor = [0.75 0.75 0.75];
% fprintf(fid,'void glass mat%s\n0\n0\n',num2str(count));
% fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\n\n',3,thiscolor);
% %fprintf(fid,'void plastic mat%s\n0\n0\n',num2str(count));
% %fprintf(fid,'%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%2.2f\n\n',5,thiscolor,0.2,0);
% s = ['mat' num2str(count) ' sphere s1'];
% fprintf(fid,'%s\n0\n0\n',s);
% fprintf(fid,'%d\t%f\t%f\t%f\t%f\n\n',4,posx,posy,3,2.0);
% 




%Close
fclose(fid);
