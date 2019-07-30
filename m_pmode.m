mpiInit
if labindex==1
    mode=1;
    subNumStr=subinfo{1};
    trial_num_per_block=10;
    bpm=[30 , 100, 38, 90, 60, 24, 75, 45, 110];
    windowmode=0;
    %bpm=[80,100];
    [t0,rect,acc] = f1(subNumStr,trial_num_per_block,bpm,mode,windowmode);
elseif labindex==2
    [t0,result]=f2;
end