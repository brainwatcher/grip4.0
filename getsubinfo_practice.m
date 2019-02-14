function subinfo=getsubinfo_practice()
prompt={'subject number','trails'};
dlg_title='info';
num_lines=1;
defaultanswer={'000','4'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
end