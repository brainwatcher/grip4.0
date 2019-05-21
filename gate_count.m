function count_time=gate_count(path,time,base)
path(time==0)=[];
b=strfind([path>base]', [0 1]);
count_time=length(b);
