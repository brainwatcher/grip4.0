mpiInit
if labindex==1
    mode=0;
    subNumStr=subinfo{1};
    trial_num_per_block=str2double(subinfo{2});
    bpm = [30,40,60,80];
    windowmode=0;% 0, full;1,small window
    [t0,rect,acc] = f1(subNumStr,trial_num_per_block,bpm,mode,windowmode);
elseif labindex==2
    [t0,result]=f2;
end

