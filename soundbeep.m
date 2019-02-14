function [t1,err] = soundbeep(t0,interval,y,Fs)
%SOUNDBEEP 此处显示有关此函数的摘要
%   此处显示详细说明
WaitSecs(interval+t0-GetSecs);  
sound(y,Fs);
t1=GetSecs;
err=t1-t0-interval;
end

