function[acc,pks,locs]=analysis_acc1(subinfonum,block,trial_num)
cd data
S=load(['outcome' num2str(subinfonum) '.mat']);
cd ..
rt0=S.rt0(trial_num,block);
path=S.path_all{trial_num,block};
time=S.time_all{trial_num,block};
interval=60/100;
cd preparation
back=imread('back.bmp');
B=load('back.mat');
cd ..
rect=[ 0           0        1440         900];
ratio=min(rect(3)/size(back,2),rect(4)/size(back,1));
gate=B.gate0*ratio;
seq=[4,1,3,5,2];% gate sequence
[~,~,whichgate]=intersect([1,2,3,4,5],seq);
% [acc,path,mark,shoot] = evaluate_acc(path,time,rt0,interval,gate,whichgate)
ans_gate=gate(whichgate,:);
path(time==0)=[];
time(time==0)=[];
%% exactly time marker
label=rt0+(0:5)*interval;
label_index=zeros(size(label));
for i=1:numel(label)   
[~, label_index(i)] = min(abs(time-label(i)));
end
%% define time_bin for check acc

% a=[0:4]';
% bin_eff=[a-0.5,a+1.5];
% bin_eff(bin_eff<0)=0;
% bin_eff(bin_eff>5)=5;
adjust=0.05;
bin_eff=[0,1.5;0.5,2.5;1.5,3.5;2.5,4.5;3.5,5];
bin_eff(2:end,1)=bin_eff(2:end,1)+adjust;
bin_eff(1:end-1,2)=bin_eff(1:end-1,2)-adjust;
time_bound=rt0+bin_eff*interval;
bin=zeros(size(time_bound));
for i=1:numel(bin)   
[~, bin(i)] = min(abs(time-time_bound(i)));
end

%% find local maxima in path
[pks,locs] = findpeaks(path);
%% allocate the maxima into bins
k=cell(1,5);
for i=1:5
    k{i}=find(locs>bin(i,1)&locs<bin(i,2));
end
%% judge there is any maxima exactly in the gate
acc=nan(1,5);
for i=1:4
    acc(i)=any(pks(k{i})>ans_gate(i,1)&pks(k{i})<ans_gate(i,2));   
end
acc(5)=any(pks(k{i})>ans_gate(5,1));
%% plot
figure; 
shoot_color=[237,28,36;46,49,146;0,111,59;91,155,213;0,0,0];
plot(1:length(time),path,'-',label_index,zeros(1,length(label)),'r*',locs,pks,'k*') 
for i=1:size(bin,1)
    line(repmat(bin(i,:),2,1), repmat([0 max(ans_gate(:))],2,1)','Color',shoot_color(i,:)/255,'LineStyle','--');
end
for i=1:size(gate,1)-1 
    line(repmat(bin(i,:),2,1)', repmat(ans_gate(i,:),2,1),'Color',shoot_color(i,:)/255,'LineStyle','--'); 
end
line(bin(5,:), repmat(ans_gate(5,1),2,1),'Color','black','LineStyle','--'); 

end
