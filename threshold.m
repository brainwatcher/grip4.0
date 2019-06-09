% try
root=pwd;
cd(root);
Screen('Preference', 'SkipSyncTests', 1);
subinfo=m_getsubinfo;
window_screen=whichscreen;
[window, rect] = Screen('Openwindow',window_screen,255);
image_num=4;
imageDisplay=zeros(image_num,1);
cd preparation
for i=1:image_num
task_intr=imread(['threshold' num2str(i-1) '.bmp']);
img=imresize(task_intr,1);
imageDisplay(i)=Screen('MakeTexture', window, img);
end
cd ..
ListenChar(2);
% HideCursor;
KbName('UnifyKeyNames');
KbCheckList = [KbName('space'),KbName('ESCAPE'),KbName('s')];
RestrictKeysForKbCheck(KbCheckList);
duration=5;
%% preparation
Screen('DrawTexture', window, imageDisplay(1), [], [],0);
Screen('Flip',window);
wait4space;
repeatnum=2;
relax_grip=cell(repeatnum,1);
maxgrip=cell(repeatnum,1);
for i=1:repeatnum
Screen('DrawTexture', window, imageDisplay(2), [], [],0);
Screen('Flip',window,[],1);
relax_grip{i}=grip(duration,window,rect);
Screen('DrawTexture', window, imageDisplay(3), [], [],0);
Screen('Flip',window,[],1);
maxgrip{i}=grip(duration,window,rect);
end
relax_mean_grip=cellfun(@mean,relax_grip);
min_grip=mean(relax_mean_grip);
max_grip=double(max(cellfun(@max,maxgrip)));    
cd data
filename=['threshold' subinfo{1} '.mat'];
save(filename,'min_grip','max_grip');
cd ..
Screen('DrawTexture', window, imageDisplay(4), [], [],0);
Screen('Flip',window);
WaitSecs(3);
disp(['Your relax grip force is ' num2str(min_grip/8000*500) 'N.']);
disp(['Your max grip force is ' num2str(max_grip/8000*500) 'N.']);
Screen('Closeall');
ListenChar;
ShowCursor;
if max(relax_mean_grip)-min(relax_mean_grip)>min(relax_mean_grip)*0.5
    warning(['Relax grip may not measured correctly!']);
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