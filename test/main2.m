global gate whichgate
tic
% try
%%
trial_num=3;
% bpm=[30 , 100, 38, 90, 60, 24, 75, 45, 110];
bpm=[100];
err=cell(size(bpm,2),1);
root=pwd;
cd(root);
subinfo=getsubinfo();    
Screen('Preference', 'SkipSyncTests', 1);
window_screen=whichscreen;
KbName('UnifyKeyNames');
KbCheckList = [KbName('space'),KbName('ESCAPE'),KbName('s')];
RestrictKeysForKbCheck(KbCheckList);
% ListenChar(2);
% HideCursor;

%% get min and max grip force
cd data;
loadfilename=['threshold' subinfo{1} '.mat'];
load(loadfilename);
disp(['Your max force is ' num2str(max_grip/16) '...']);
cd ..

%% read background and sound file 
cd preparation
back=imread('back.bmp');
right=imread('right.png');
wrong=imread('wrong.png');
relax=imread('relax.bmp');
bpm_prepare=imread('bpm_prepare.bmp');
load back.mat
load metro.mat; 
loadlibrary('USB_DAQ_DLL_V42','USB_DAQ_DLL_V42');
cd ..
%%
[window, rect] = Screen('Openwindow',window_screen,255/2);
ratio=min(rect(3)/size(back,2),rect(4)/size(back,1)); % the ratio of zoom back image 
back_img=imresize(back,ratio);
imageDisplay=Screen('MakeTexture', window, back_img);
gate=gate0*ratio;% zoomed gate position
start=home0*ratio;% zoomed home position
%% cursor
cursor_size=25;
cursor_img=ones(cursor_size,cursor_size);%cursorsize 
imageDisplay_cursor=Screen('MakeTexture', window, cursor_img);
cursor_height=0.5*(rect(4));
gate(:,2)=gate(:,2)-cursor_size;
seq=[4,1,3,5,2];% gate sequence
[~,~,whichgate]=intersect([1,2,3,4,5],seq);
imageDisplay_result=zeros(1,4);
shoot_img=zeros(cursor_size,cursor_size,3);
shoot_img(:,:,1)=237;
shoot_img(:,:,2)=28;
shoot_img(:,:,3)=36;
imageDisplay_result(1)=Screen('MakeTexture', window, shoot_img);
shoot_img(:,:,1)= 46;
shoot_img(:,:,2)=49;
shoot_img(:,:,3)=146;
imageDisplay_result(2)=Screen('MakeTexture', window, shoot_img);
shoot_img(:,:,1)= 0;
shoot_img(:,:,2)=111;
shoot_img(:,:,3)=59;
imageDisplay_result(3)=Screen('MakeTexture', window, shoot_img);
shoot_img(:,:,1)= 91;
shoot_img(:,:,2)=155;
shoot_img(:,:,3)=213;
imageDisplay_result(4)=Screen('MakeTexture', window, shoot_img);

%% start symbol
symbol_size=30;
symbol_img=zeros(symbol_size,symbol_size,3);%cursorsize
symbol_img(:,:,1)=255 ;
symbol_img(:,:,2)=0;
symbol_img(:,:,3)=0;
imageDisplay_stop=Screen('MakeTexture', window, symbol_img);
symbol_img(:,:,1)=0 ;
symbol_img(:,:,2)=255;
symbol_img(:,:,3)=0;
imageDisplay_go=Screen('MakeTexture', window, symbol_img);
symbol_img(:,:,1)=255 ;
symbol_img(:,:,2)=255;
symbol_img(:,:,3)=0;
imageDisplay_ready=Screen('MakeTexture', window, symbol_img);
symbol_pos=[0.6*rect(3),(rect(4)+size(back_img,1))*0.5-2*symbol_size];
%% feed back
right_img=imresize(right,50/max(size(right)));
wrong_img=imresize(wrong,50/max(size(wrong))); 
imageDisplay_right=Screen('MakeTexture', window, right_img);
imageDisplay_wrong=Screen('MakeTexture', window, wrong_img);
feed_back_height=0.5*(rect(4)-size(back_img,1))-50;
feed_back_pos=mean(gate,2);
%% relax
relax_img=imresize(relax,min(rect(3)/size(relax,2),rect(4)/size(relax,1)));
imageDisplay7=Screen('MakeTexture', window, relax_img);
%% bpm prepare
bpm_prepare_img=imresize(bpm_prepare,min(rect(3)/size(bpm_prepare,2),rect(4)/size(bpm_prepare,1)));
imageDisplay8=Screen('MakeTexture', window, bpm_prepare_img);
%%
low_bound=start(1);
up_bound=0.5*(rect(3)+size(back_img,2));
min_grip=min_grip+150;%% ×îµÍÖµ
getloc=@(grip) (log(grip)-log(min_grip))/(log(double(max_grip*0.4))-log(min_grip))*(up_bound-low_bound)+low_bound;% log
% getloc1=@(grip)((grip)-(min_grip))/((double(max_grip*0.4))-(min_grip))*(up_bound-low_bound)+low_bound;

%% parameter
calllib('USB_DAQ_DLL_V42','OpenUsb_V42');
FrqSamp=100000;
NumSamp=1024;
NumBuf=1.0:NumSamp;

total_beep=size(gate0,1);

current_cursor=start(1);
penwidth=2;
prepare_time=2;
gate5_time=1;
feedback_time=2;

acc_all=cell(trial_num,length(bpm));
rt_all=zeros(trial_num,length(bpm));
path_all=cell(trial_num,length(bpm));
mark_all=cell(trial_num,length(bpm));
lag=0.08;
fwrite(udpA,trial_num)
%%
%% trial start


%% save 
cd data
filename=['outcome' subinfo{1} '.mat'];
save(filename,'acc_all','rt_all','path_all');
disp(['Successfully saved!'])
cd ..         
disp(['All done.']);
toc
ListenChar;
ShowCursor;
sca;
unloadlibrary( 'USB_DAQ_DLL_V42');
Screen('Preference', 'Verbosity', 1);
% catch ErrorInfo
%     disp(ErrorInfo);
%     disp(ErrorInfo.identifier);
%     disp(ErrorInfo.message);
%     disp(ErrorInfo.stack);
%     disp(ErrorInfo.cause);
%     ListenChar;
%     ShowCursor;
%     sca;    
%     disp(['Urgently stoped!'])
%     cd(root)
%     cd data
%     filename=['outcome_emergency.mat'];
%     save(filename,'acc_all','rt_all','path_all');
%     cd ..
%     disp(['Urgently saved!'])  
%     toc
%     unloadlibrary( 'USB_DAQ_DLL_V42');
% end

