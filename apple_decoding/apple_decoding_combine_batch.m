function apple_decoding_combine_batch


%Run Decoding
clc;
areas{1} = 'lh_v1';
areas{2} = 'lh_v2';
areas{3} = 'lh_v3';
areas{4} = 'lh_v3ab';
areas{5} = 'lh_v4v';
areas{6} = 'lh_vo1';
areas{7} = 'lh_vo2';
areas{8} = 'lh_lo1';
areas{9} = 'lh_lo2';
areas{10} = 'lh_mtplus';




%Run Decoding Batch
threshold = 0.75;
j = 100;
for i=1:numel(areas)

%   	%AB
%     session = zeros(12*5,1);
%     session(1:12) = 1;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'ab');
%    
%     %AW
%     session = zeros(12*5,1);
%     session(13:24) = 1;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'aw');
%      
%     %CS
%     session = zeros(12*5,1);
%     session(25:36) = 1;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'cs');
%   
%     %GB
%     session = zeros(12*5,1);
%     session(37:48) = 1;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'gb');
%   
%     %SJ
%     session = zeros(12*5,1);
%     session(49:60) = 1;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'sj');
%    
    %All
    session = ones(12*5,1);
    session = repmat([1 1 1 1],1,15);
    apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'group');

%     %Exclude AB
%     session = ones(12*5,1);
%     session(1:12) = 0;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'group-ab');
%    
%     %Exclude AW
%     session = ones(12*5,1);
%     session(13:24) = 0;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'group-aw');
%      
%     %Exclude CS
%     session = ones(12*5,1);
%     session(25:36) = 0;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'group-cs');
%   
%     %Exclude GB
%     session = ones(12*5,1);
%     session(37:48) = 0;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'group-gb');
%   
%     %Exclude SJ
%     session = ones(12*5,1);
%     session(49:60) = 0;
%     apple_decoding_combine(session,3,1,areas{i},threshold,0,j,'group-sj');  
  
  end
  
end

