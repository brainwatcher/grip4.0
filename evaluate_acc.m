function[acc,path,time,shoot]=evaluate_acc(path,time,base,ans_gate,rt0,interval)
%%
path(time==0)=[];
time(time==0)=[];
%% exactly time marker
label=rt0+(0:5)*interval;
label_index=zeros(size(label));
for i=1:numel(label)
    [~, label_index(i)] = min(abs(time-label(i)));
end
%% define time_bin for check acc
ratio=0.2;
bin=zeros(5,2);
for i=1:5
    bin(i,1)=ratio*label_index(i+1)+(1-ratio)*label_index(i);
    if i<5
        bin(i,2)=ratio*label_index(i+1)+(1-ratio)*label_index(i+2);
    else
        bin(i,2)=length(path);% gate 5 error
    end
end
%% find local maxima in path
[pks,locs] = findpeaks(path);
%% get the shoot bin
mark=path>base;
k=find(mark==0);
if isempty(k)
    disp('Not initial correctly!');
    acc=zeros(1,5);
    shoot=zeros(1,5);
    return;
end
initial=k(1);

clear k
mark1=diff([0,mark']);
shoot_on=find(mark1==1);
shoot_on(shoot_on<initial)=[];
shoot_off=find(mark1==-1)-1;
shoot_off(shoot_off<initial)=[];
if length(shoot_on)-length(shoot_off)==1
    shoot_off=[shoot_off,length(mark)];
    pks=[pks;path(end)];
    locs=[locs;length(mark)];
end
bin_shoot=[shoot_on;shoot_off]';
%% allocate the maxima into bins
k=cell(1,5);
bin_inter=cell(1,5);
for i=1:5
    if i<=size(bin_shoot,1)
        bin_inter{i}=[max(bin(i,1),bin_shoot(i,1)),min(bin(i,2),bin_shoot(i,2))];
        if bin_inter{i}(1)>bin_inter{i}(2)
            bin_inter{i}=[];
            k{i}=[];
        else
            k{i}=find(locs>bin_inter{i}(1)&locs<=bin_inter{i}(2));
        end
    else
        bin_inter{i}=[];
        k{i}=[];
    end
end
%% judge there is any maxima exactly in the gate
acc=zeros(1,5);
shoot=zeros(1,5);
shoot_idx=zeros(1,5);
for i=1:4
    if ~isempty(k{i})
        [shoot(i),shoot_idx(i)]=max(pks(k{i}));
        acc(i)=shoot(i)>ans_gate(i,1)&shoot(i)<ans_gate(i,2);
    end
end
if ~isempty(k{5})
    shoot(5)=max(pks(k{5}));
    acc(5)=any(shoot(5)>ans_gate(5,1));
    if shoot(5)>=ans_gate(5,1)
        shoot(5)=ans_gate(5,1);
    end
end
end


