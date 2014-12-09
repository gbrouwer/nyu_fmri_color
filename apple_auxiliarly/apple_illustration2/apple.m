function apple

%Init
clc;
load('cerulean_LCD at scanner - 10262010');
system('rm -f apple.tiff');
system('rm -f apple.pic');


%Render Stimulus
target_loc = [];
lightsources(1,:) = [0.3 0.3 0.3];
system('rm -f apple.oct');
radfile = 'apple.rad';
apple_createscene;
command = ['oconv ' radfile ' > ' radfile(1:end-4) '.oct'];
system(command);


command = ['rpict -x 1400 -y 1400 -pa 0.75 -vh 100 -vv 80 -ds 0 -ab 0 -aa 0.1 -ad 2048 -as 1 -ps 8 -vp -10.00 0.00 10 -vd 1 0 -1.1 -av ' num2str(lightsources(1,:)) ' ' radfile(1:end-4) '.oct > ' radfile(1:end-4) '.pic'];
system(command);
pname = 'apple.pic';
tname = 'apple.tiff';
command = ['ra_tiff -g 1 ' pname ' ' tname];
system(command);

!open apple.tiff
