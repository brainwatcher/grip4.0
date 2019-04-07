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
%% get the shoot bin
mark=path>base;
mark1=diff([0,mark']);
shoot_on=find(mark1==1);
shoot_off=find(mark1==-1)-1;
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
    [shoot(5),shoot_idx(5)]=max(pks(k{5}));
    acc(5)=any(shoot(5)>ans_gate(5,1));
end
%% plot
% figure; 
% shoot_color=[237,28,36;46,49,146;0,111,59;91,155,213;0,0,0];
% plot(1:length(time),path,'-',label_index,zeros(1,length(label)),'r*',locs,pks,'k*') ;
% hold on
% for i=1:5
%     if ~isempty(k{i})
%         plot(locs(k{i}(shoot_idx(i))),shoot(i),'y*');
%     end
% end
% for i=1:size(bin,1)
%     line(repmat(bin(i,:),2,1), repmat([0 max(ans_gate(:))],2,1)','Color',shoot_color(i,:)/255,'LineStyle','--');
% end
% for i=1:size(gate,1)-1 
%     line(repmat(bin(i,:),2,1)', repmat(ans_gate(i,:),2,1),'Color',shoot_color(i,:)/255,'LineStyle','--'); 
% end
% line(bin(5,:), repmat(ans_gate(5,1),2,1),'Color','black','LineStyle','--'); 

end

        
