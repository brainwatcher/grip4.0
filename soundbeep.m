function [t1,err] = soundbeep(t0,interval,y,Fs)
%SOUNDBEEP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
WaitSecs(interval+t0-GetSecs);  
sound(y,Fs);
t1=GetSecs;
err=t1-t0-interval;
end

