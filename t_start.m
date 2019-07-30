subinfo=t_getsubinfo;  
sub_num=subinfo{1};
session=str2double(subinfo{2});
trial_num=20*ones(1,6);
f1NoSound(sub_num,trial_num,session);
function subinfo=t_getsubinfo()
prompt={'subject number','session'};
dlg_title='info';
dims = [1 35;1 10];
defaultanswer={'000','0'};
subinfo=inputdlg(prompt,dlg_title,dims,defaultanswer);
end