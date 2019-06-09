mpiInit
mode=0;
trial_num_per_block=2;
bpm = [40,60];
if labindex==1
    [t0,rect,acc] = f1(subinfo,trial_num_per_block,bpm,mode);
elseif labindex==2
    [t0,result]=f2;
end