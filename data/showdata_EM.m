list={'Practice','Train','Main Test'};
[indx,tf] = listdlg('PromptString','Select a session:',...
    'SelectionMode','single',...
    'ListString',list,'ListSize',[150,80]);
if isempty(indx)
    return
end
if indx==2
    prompt={'subject number','time'};
    dlg_title='sub_info';
    num_lines=1;
    defaultanswer={'000','1'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    filename=['t_' subinfo{1} '_' subinfo{2} '_EM.mat'];
elseif indx==1 || indx==3
    prompt={'subject number',};
    dlg_title='sub_info';
    num_lines=1;
    defaultanswer={'000'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    if indx==1
        filename=['p_' subinfo{1} '_EM.mat'];
    else
        filename=['m_' subinfo{1} '_EM.mat'];
    end
end
disp(['The data being evaluated is ' filename ' ...']);
%%
if exist(filename,'file') 
S=load(filename);
else 
    error('No file record!')
end
acc_all=S.acc_all;
rt0=S.rt0;
rt1=S.rt1;
rt_all=S.rt_all;
% a=cellfun(@(x) ~isempty(x),rt0) & cellfun(@(x) ~isempty(x),rt1)
error_rate=cell(length(acc_all),1);
rt=cell(length(rt1),1);
rt_mean=zeros(length(rt1),1);
rt_sd=zeros(length(rt1),1);
error_rate_mean=zeros(length(rt1),1);
error_rate_sd=zeros(length(rt1),1);
for i=1:length(rt1)
rt{i}=rt1{i}-rt0{i};
if rt{i}~=rt_all{i}
    error('sth wrong with rt...')
end
rt{i}(isnan(rt{i}))=[];
error_rate{i}=cellfun(@(x) 1-sum(x)/5,acc_all{i});
rt_mean(i)=mean(rt{i});
rt_sd(i)=std(rt{i});
error_rate_mean(i)=mean(error_rate{i});
error_rate_sd(i)=std(acc{i});
end
%%
figure;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2 0.55 0.6 0.45]);
subplot(121) % error rate VS block
errorbar(1:length(error_rate_mean),error_rate_mean,error_rate_sd,'o','MarkerFaceColor',[0.5,0.5,0.5])
axis([0 length(error_rate_mean)+1 0 max(error_rate_mean+error_rate_sd)*1.1])
xlabel('Block')
ylabel('Error rate (%)')
set(gca,'XTick',1:length(error_rate_mean))
set(gca,'YTick',0:0.2:1)

subplot(122) % Movetime VS block
errorbar(1:length(rt_mean),rt_mean,rt_sd,'o','MarkerFaceColor',[0.5,0.5,0.5]) ;
axis([0 length(rt_mean)+1 0 max(rt_mean+rt_sd)*1.1])
xlabel('Block')
ylabel('Movement time (s)')
set(gca,'XTick',1:length(rt_mean))

figure; % error rate VS movetime
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.3 0.08 0.4 0.45]);
plot(rt_mean,error_rate_mean,'o','MarkerFaceColor',[0.5,0.5,0.5])
axis([min(rt_mean)/1.1 max(rt_mean)*1.1 0 1])
xlabel('Movement time (s)')
ylabel('Error rate (%)')
set(gca,'XTick',round(min(rt_mean)/1.1):1:round(max(rt_mean)))
set(gca,'YTick',0:0.2:1)
