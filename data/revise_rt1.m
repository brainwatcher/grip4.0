function [new_rt1,new_rt_all]=revise_rt1(subnum) 
% subnum is string format
S=load(['outcomet' subnum]);
new_rt1=S.rt1;
interval=60./S.bpm;
maxtime=5*interval;
for i=1:size(S.rt1,2)
    k=S.rt1(:,i)==0;
    new_rt1(k,i)=maxtime(i);
end
new_rt_all=new_rt1-rt0;
end