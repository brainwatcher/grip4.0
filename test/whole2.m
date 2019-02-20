
mpiInit
if labindex==1     
  labSend(333, 2);
elseif labindex==2
    result = labReceive(1);
end