% pmode start local 2 % 
subinfo=m_getsubinfo;  
pmode client2lab subinfo 1;

function subinfo=m_getsubinfo()
prompt={'subject number'};
dlg_title='main';
num_lines=1;
defaultanswer={'000'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
end