mpiInit
if labindex==1
    mode=1;
    trial_num_per_block=2;
    %  bpm=[30 , 100, 38, 90, 60, 24, 75, 45, 110];
    bpm=[60];
    [t0,rect,acc] = f1(subinfo,trial_num_per_block,bpm,mode);
elseif labindex==2
    [t0,result]=f2;
end