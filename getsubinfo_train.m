function subinfo=getsubinfo_train()
prompt={'subject number','session'};
dlg_title='info';
dims = [1 35;1 10];
defaultanswer={'000','0'};
subinfo=inputdlg(prompt,dlg_title,dims,defaultanswer);
end