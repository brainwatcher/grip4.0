function [acc,path,mark,shoot] = evaluate_acc(path,time,rt0,interval,gate,whichgate)
ans_gate=gate(whichgate,:);
time(time==0)=[];
path(time==0)=[];
mark=zeros(size(time));
mark(time-rt0<interval)=1;
mark(time-rt0>=interval&time-rt0<2*interval)=2;
mark(time-rt0>=2*interval&time-rt0<3*interval)=3;
mark(time-rt0>=3*interval&time-rt0<4*interval)=4;
mark(time-rt0>=4*interval&time-rt0<5*interval)=5;
trace=cell(5,1);
acc=nan(5,1);
for i=1:5
    trace{i}=path(mark==i);    
end
shoot=cellfun(@max,trace);
for i=1:5
    if shoot(i)<ans_gate(i,2)&&shoot(i)>ans_gate(i,1)
        acc(i)=1;
    else
        acc(i)=0;
    end
end
end
        
