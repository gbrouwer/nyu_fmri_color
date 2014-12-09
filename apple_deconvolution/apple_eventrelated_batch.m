function apple_eventrelated_batch

%Init
clc;
ds = [];
clear all;
close all;
os.count = 0;
os.totalHRF = [];



%Categorization
os = apple_eventrelated('ab_07312012',os);
os = apple_eventrelated('ab_07182012',os);
os = apple_eventrelated('ab_08102012',os);
os = apple_eventrelated('aw_04262011',os);
os = apple_eventrelated('aw_08012011',os);
os = apple_eventrelated('aw_03302012',os);
os = apple_eventrelated('cs_08092012',os);
os = apple_eventrelated('cs_03282012',os);
os = apple_eventrelated('gb_04282011',os);
os = apple_eventrelated('gb_04192011',os);
os = apple_eventrelated('gb_07072011',os);
os = apple_eventrelated('sj_08182011',os);
os = apple_eventrelated('sj_09122011',os);
os = apple_eventrelated('sj_04162012',os);



%Save
save('apple_eventrelated.mat','os');


