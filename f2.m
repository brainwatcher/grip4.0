function [t0,result] = f2
%F2 此处显示有关此函数的摘要
%   此处显示详细说明
cd preparation
S=load('metro.mat');
cd ..
% the first time receive to define the trial_num and bpm block
result = labReceive(1);
bpm=result{1};
trial_num=result{2};
% trial_num=result(2);
t0=GetSecs;
disp(['The block number is ' num2str(length(bpm))]);
disp(['The trial_num is ' num2str(trial_num)]);
for w=1:length(bpm)
    interval=60/bpm(w);
    result = labReceive(1);
    t0=GetSecs;
    for i=1:result(2)
        [t0,~] = soundbeep(t0,interval,S.y,S.Fs);
    end
    for j=1:trial_num(w)
        result = labReceive(1);
        t0=GetSecs;
        for i=1:result(2)
        [t0,~] = soundbeep(t0,interval,S.y,S.Fs);
        end
    end
end
            
        

