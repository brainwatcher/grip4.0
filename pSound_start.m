subinfo=getsubinfo;  
sub_num=subinfo{1};
trial_num=subinfo{2};
pmode client2lab subinfo 1
function subinfo=getsubinfo()
prompt={'subject number','trials per block'};
dlg_title='practice';
dims = [1 35;1 35];
defaultanswer={'000','4'};
subinfo=inputdlg(prompt,dlg_title,dims,defaultanswer);
end