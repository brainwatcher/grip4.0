subinfo=p_getsubinfo;  
sub_num=subinfo{1};
trial_num=str2double(subinfo{2});
session=0;
f1NoSound(sub_num,trial_num,session);
function subinfo=p_getsubinfo()
prompt={'subject number','trails'};
dlg_title='info';
num_lines=1;
defaultanswer={'000','4'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
end