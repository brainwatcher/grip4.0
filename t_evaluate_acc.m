function [acc,path,time,shoot] = t_evaluate_acc(path,time,ans_gate,base)
%%
% Screen('Closeall')
path(time==0)=[];
time(time==0)=[];
%% find bin in path
path(time==0)=[];
out=[path>base]';% logical class of path >base 
shoot_initial=strfind(out, [0 1]);
shoot_end=strfind(out, [1,0]);
if length(shoot_end)<length(shoot_initial)
    shoot_end(end+1)=length(out);
end
%% judge there is any maxima exactly in the bin of the corresponding gate
acc=zeros(1,5);
shoot=zeros(1,5);
shoot_idx=zeros(1,5);
for i=1:5
        path0=path(shoot_initial(i):shoot_end(i));
        [shoot(i),shoot_idx(i)]=max(path0);
        shoot_idx(i)=shoot_idx(i)+shoot_initial(i)-1;
        acc(i)=shoot(i)>ans_gate(i,1)&shoot(i)<ans_gate(i,2);
        if i==5
            acc(i)=shoot(i)>ans_gate(i,1);
        end
        %% in case for hand tremble
        path0=smoothdata(path0,'movmean',5);
        [pks,~] = findpeaks(path0);
        if length(pks)>2 
            acc(i)=0;
        end
        
end
%% plot
% figure; 
% shoot_color=[237,28,36;46,49,146;0,111,59;91,155,213;0,0,0];
% pre_line=length(path)/(length(pks)+1);
% plot(1:length(time),path,'-',shoot_idx,shoot,'k*') ;
% hold on
% for i=1:5
%     line_color=shoot_color(i,:)/256;
%     if i<5
%         L=locs(i)-pre_line:locs(i)+pre_line;
%     else
%         L=length(path)-pre_line:length(path)+pre_line;
%     end
%     if i<5
%     plot(L,ones(1,length(L))*ans_gate(i,1),'-','color',line_color);
%     plot(L,ones(1,length(L))*ans_gate(i,2),'-','color',line_color);
%     else
%     plot(L,ones(1,length(L))*ans_gate(i,1),'-','color',line_color);
%     end
%     
% end

end

        


