time=10;
bpm=50;
interval=60/bpm;
t0=zeros(1,time);
t1=zeros(1,time);
labSend([time,interval], 2);
t0=GetSecs;
for i=1:time
    t1(i)=wait4press;
%     WaitSecs(0.5+rand(1));
    WaitSecs(0.2);
    t1(i)-t0-i*interval
end
lag=t1-t0-interval*[1:time];
mean(lag(3:end-1));
% disp(['lag is ' num2str(lag([3:end]))])
% pmode lab2client subinfo 1