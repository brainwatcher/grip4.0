% try
root=pwd;
cd(root);
Screen('Preference', 'SkipSyncTests', 1);
subinfo=getsubinfo;
window_screen=whichscreen;
[window, rect] = Screen('Openwindow',window_screen,255);
%%
cd preparation
var_list={'threshold0','threshold1','threshold2','threshold3'};
image_num=length(var_list);
imageDisplay=zeros(image_num,1);
for i=1:length(var_list)
    eval([var_list{i} '=imread(''' var_list{i} '.bmp'');']);
    eval(['ratio=min(rect(3)/size(' var_list{i} ',2),rect(4)/size(' var_list{i} ',1));'])
    eval([var_list{i} '_img=imresize(' var_list{i} ',ratio);']);
    eval(['imageDisplay(i)=Screen(''MakeTexture'', window,' var_list{i} '_img);']);
end
cd ..
%%
ListenChar(2);
HideCursor;
KbName('UnifyKeyNames');
KbCheckList = [KbName('space'),KbName('ESCAPE'),KbName('s')];
RestrictKeysForKbCheck(KbCheckList);
duration=5;
%% preparation
Screen('DrawTexture', window, imageDisplay(1), [], [],0);
Screen('Flip',window);
wait4press;
repeatnum=2;
relax_grip=cell(repeatnum,1);
force_grip=cell(repeatnum,1);
for i=1:repeatnum
Screen('DrawTexture', window, imageDisplay(2), [], [],0);
Screen('Flip',window,[],1);
relax_grip{i}=grip(duration,window,rect);
Screen('DrawTexture', window, imageDisplay(3), [], [],0);
Screen('Flip',window,[],1);
force_grip{i}=grip(duration,window,rect);
end
relax_mean_grip=double(cellfun(@mean,relax_grip));
min_grip=mean(relax_mean_grip);
force_mean_grip=double(cellfun(@max,force_grip));   
max_grip=max(force_mean_grip);
cd data
filename=['threshold' subinfo{1} '.mat'];
save(filename,'min_grip','max_grip');
cd ..
Screen('DrawTexture', window, imageDisplay(4), [], [],0);
Screen('Flip',window);
WaitSecs(3);
disp(['Your relax grip force is ' num2str(min_grip/8000*500) 'N.']);
disp(['Your max grip force is ' num2str(max_grip/8000*500) 'N.']);
disp(relax_mean_grip'./8000*500);
disp(force_mean_grip'./8000*500);
Screen('Closeall');
ListenChar;
ShowCursor;
if max(relax_mean_grip)-min(relax_mean_grip)>min(relax_mean_grip)*0.5
    warning('Relax grip may not measured correctly!');
end
% catch ErrorInfo
%     disp(ErrorInfo);
%     disp(ErrorInfo.identifier);
%     disp(ErrorInfo.message);
%     disp(ErrorInfo.stack);
%     disp(ErrorInfo.cause);
%     ListenChar;
%     ShowCursor;
%     sca;
%     unloadlibrary( 'USB_DAQ_DLL_V42');
% end
function subinfo=getsubinfo()
prompt={'subject number'};
dlg_title='Threshold';
num_lines=1;
defaultanswer={'000'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
end