cd preparation
S=load('metro.mat');
cd ..
sound(S.y,S.Fs);
time = labReceive(1);
interval=zeros(time,1);
for i=1:time
    interval(i) = labReceive(1);
    t0=GetSecs;
    soundbeep(t0,interval(i),S.y,S.Fs);
end