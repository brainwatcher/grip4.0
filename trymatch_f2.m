cd preparation
S=load('metro.mat');
cd ..
[time,interval] = labReceive(1);
t0=GetSecs;
for i=1:time
    [t0,~] = soundbeep(t0,interval,S.y,S.Fs);
end