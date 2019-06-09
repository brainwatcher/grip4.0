function subinfo=m_getsubinfo()
prompt={'subject number'};
dlg_title='info';
num_lines=1;
defaultanswer={'000'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
end