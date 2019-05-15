function [acc,path,time,shoot] = evaluate_acc_train(path,time,ans_gate)
%%
% Screen('Closeall')
path(time==0)=[];
time(time==0)=[];
%% find local maxima in path
[pks,locs] = findpeaks(path);

%% judge there is any maxima exactly in the gate
acc=zeros(1,5);
shoot=zeros(1,5);
shoot_idx=zeros(1,5);
for i=1:4
        acc(i)=pks(i)>ans_gate(i,1)&pks(i)<ans_gate(i,2);
        shoot(i)=pks(i);
        shoot_idx(i)=locs(i);
end
lastpart0=path(locs(4)+1:end);
start_lastpart=find(lastpart0==min(path));
lastpart=lastpart0(start_lastpart(end):end);
[shoot(5),shoot_idx(5)]=max(lastpart);
shoot_idx(5)=shoot_idx(5)+locs(4)+start_lastpart(end);
acc(5)=shoot(5)>ans_gate(5,1);
%% plot
figure; 
shoot_color=[237,28,36;46,49,146;0,111,59;91,155,213;0,0,0];
pre_line=length(path)/(length(pks)+1);
plot(1:length(time),path,'-',shoot_idx,shoot,'k*') ;
hold on
for i=1:5
    line_color=shoot_color(i,:)/256;
    if i<5
        L=locs(i)-pre_line:locs(i)+pre_line;
    else
        L=length(path)-pre_line:length(path)+pre_line;
    end
    if i<5
    plot(L,ones(1,length(L))*ans_gate(i,1),'-','color',line_color);
    plot(L,ones(1,length(L))*ans_gate(i,2),'-','color',line_color);
    else
    plot(L,ones(1,length(L))*ans_gate(i,1),'-','color',line_color);
    end
    
end

end

        


