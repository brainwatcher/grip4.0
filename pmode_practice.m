mpiInit
if labindex==1
    mode=0;
    trial_num_per_block=str2double(subinfo{2});
    bpm = [30,40,60,80];
    [t0,rect,acc] = f1(subinfo,trial_num_per_block,bpm,mode);
elseif labindex==2
    [t0,result]=f2;
end