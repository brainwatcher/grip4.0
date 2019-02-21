function [acc_e,acc_a]=examine(subinfo,block,trialnum)% examine evaluate_acc.m and analysis_acc.m is same 
a=block;b=trialnum;% a, blocknum; b, trial_num
cd data
O=load(['outcome' num2str(subinfo) '.mat']);
cd ..
cd preparation
B=load('back.mat');
back=imread('back.bmp');
cd ..
[width, height]=Screen('WindowSize',whichscreen);
rect=[0,0,width,height];
% [window, rect] = Screen('Openwindow',0,255/2);Screen('Closeall');
ratio=min(rect(3)/size(back,2),rect(4)/size(back,1));

base=(2*B.home0(2)-B.home0(1))*ratio;
bpm=O.bpm;
interval=60/bpm(a);

gate=B.gate0*ratio;
cursor_size=25;
gate(:,2)=gate(:,2)-cursor_size;
seq=[4,1,3,5,2];% gate sequence
[~,~,whichgate]=intersect([1,2,3,4,5],seq);
ans_gate=gate(whichgate,:);
[acc_e,path,time,shoot]=evaluate_acc(O.path_all{b,a},O.time_all{b,a},base,ans_gate,O.rt0(b,a),interval);
[acc_a,pks2,locs2,path2,time2,shoot2,ans_gate2,gate2,ratio2]=analysis_acc('000',a,b);
end
