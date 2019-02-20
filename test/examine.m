% examine evaluate_acc.m and analysis_acc.m is same 
a=1;b=3;% a, blocknum; b, trial_num
cd data
load outcome000.mat
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
bpm=100;
interval=60/bpm;

gate=B.gate0*ratio;
cursor_size=25;
gate(:,2)=gate(:,2)-cursor_size;
seq=[4,1,3,5,2];% gate sequence
[~,~,whichgate]=intersect([1,2,3,4,5],seq);
ans_gate=gate(whichgate,:);
[acc,path,time,shoot]=evaluate_acc(path_all{b,a},time_all{b,a},base,ans_gate,rt0(b,a),interval);
[acc2,pks2,locs2,path2,time2,shoot2]=analysis_acc('000',a,b);
disp(acc)
disp(acc2)