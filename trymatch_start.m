subinfo=getsubinfo;
subNumStr=subinfo{1};
pmode client2lab subNumStr 1;

function subinfo=getsubinfo()
prompt={'subject number'};
dlg_title='info';
num_lines=1;
defaultanswer={'000'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
end