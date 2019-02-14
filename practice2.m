global gate whichgate
root=pwd;
tic
try
%% preparation 
cd(root);
subinfo=getsubinfo();    
Screen('Preference', 'SkipSyncTests', 1);
window_screen=whichscreen;
KbName('UnifyKeyNames');
KbCheckList = [KbName('space'),KbName('ESCAPE'),KbName('s')];
RestrictKeysForKbCheck(KbCheckList);
ListenChar(2);
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
%% start symbol
symbol_size=30;
symbol_img=zeros(cursor_size,symbol_size,3);%cursorsize
symbol_img(:,:,1)=255 ;
symbol_img(:,:,2)=0;
symbol_img(:,:,3)=0;
imageDisplay_stop=Screen('MakeTexture', window, symbol_img);
symbol_img(:,:,1)=0 ;
symbol_img(:,:,2)=255;
symbol_img(:,:,3)=0;
imageDisplay_go=Screen('MakeTexture', window, symbol_img);
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
getloc=@(grip) (log(grip)-log(min_grip))/(log(double(max_grip*0.4))-log(min_grip))*(up_bound-low_bound)+low_bound;% log
% getloc1=@(grip)((grip)-(min_grip))/((double(max_grip*0.4))-(min_grip))*(up_bound-low_bound)+low_bound;

%% parameter
calllib('USB_DAQ_DLL_V42','OpenUsb_V42');
FrqSamp=100000;
NumSamp=1024;
NumBuf=1.0:NumSamp;
trial_num=3;
total_beep=size(gate0,1);
% bpm=[30 , 100, 38, 110, 60, 24, 80,45, 120];
bpm=[40];
current_cursor=start(1);
penwidth=2;
prepare_time=2;
gate5_time=1;
feedback_time=2;
beep_time=0;
acc_all=cell(trial_num,length(bpm));
rt_all=zeros(trial_num,length(bpm));
path_all=cell(trial_num,length(bpm));
%% trial start
for w=1:length(bpm)
    interval=60/bpm(w);%beep interval   
    t0=GetSecs;
    beep_time = soundbeep(beep_time,t0,interval,y,Fs); %beeps for famillar the pace
    Screen('DrawTexture', window, imageDisplay8, [], [],0);
    Screen('FrameRect', window,[0 0 0], [0.2*rect(3),0.7*rect(4)-penwidth,0.8*rect(3),0.73*rect(4)+penwidth],2);
    Screen('Flip',window);
    prepare_beep_num=fix(prepare_time/interval)+1;
    for i=1: prepare_beep_num
        beep_time = soundbeep(beep_time,t0,interval,y,Fs);
        Screen('DrawTexture', window, imageDisplay8, [], [],0);
        Screen('FrameRect', window,[0 0 0], [0.2*rect(3),0.7*rect(4)-penwidth,0.8*rect(3),0.73*rect(4)+penwidth],2);
        Screen('FillRect', window,[0 0 0], [0.2*rect(3),0.7*rect(4),0.2*rect(3)+0.6*rect(3)*i/prepare_beep_num,0.73*rect(4)]);
        Screen('Flip',window,[],0);   
    end
      disp(['Prepare epoch finished.'])

    for j=1:trial_num
        % trial parameter
        rt=nan;
        end_mark=0;
        path=zeros(10000,1);
        mark=zeros(10000,1);
        time=zeros(10000,1);
        current_cursor=start(1);
        last_cursor=start(1);
        Screen('DrawTexture', window, imageDisplay, [], [],0);
        Screen('DrawTexture', window, imageDisplay_cursor, [], [start(1),cursor_height,start(1)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
        Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
        % beep 3 times before every trial starts
        beep_time = soundbeep(beep_time,t0,interval,y,Fs);
        Screen('Flip',window);
        for i=1:3
            beep_time = soundbeep(beep_time,t0,interval,y,Fs);
        end
        % i==3 the first beep starts the trial
        Screen('DrawTexture', window, imageDisplay, [], [],0);
        Screen('DrawTexture', window, imageDisplay_cursor, [], [start(1),cursor_height,start(1)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
        Screen('DrawTexture', window, imageDisplay_go, [], [symbol_pos,symbol_pos+symbol_size],0);
        Screen('Flip',window,0,0);
        rt0=GetSecs;
        for t=1:total_beep
            while GetSecs-rt0<interval*t
                [~,NumBuf]=calllib('USB_DAQ_DLL_V42','AD_continu_V42',1,0, NumSamp,FrqSamp,NumBuf);%AD_continu_V42(int mod_in,int chan, int Num_Sample,int Rate_Sample,short  *databuf);
                force=mean(NumBuf);
                current_cursor=getloc(force);
                if current_cursor<low_bound
                    current_cursor=low_bound;
                elseif current_cursor>up_bound
                    current_cursor=up_bound;
                end
                Screen('DrawTexture', window, imageDisplay, [], [],0);
                Screen('DrawTexture', window, imageDisplay_go, [], [symbol_pos,symbol_pos+symbol_size],0);
                Screen('DrawTexture', window, imageDisplay_cursor, [], [current_cursor,cursor_height, current_cursor+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
                Screen('Flip',window,0,0);
                path(i)=current_cursor;
                mark(i)=t;
                i=i+1;
                 if t==5&&current_cursor>gate(4,1)% end of the trial
                    rt=GetSecs-rt0;
                    Screen('DrawTexture', window, imageDisplay, [], [],0);
                    Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
                    Screen('DrawTexture', window, imageDisplay_cursor, [], [ gate(4,1),cursor_height, gate(4,1)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
                    Screen('Flip',window,0,0)
                    break
                 end
            end
           beep_time = soundbeep(beep_time,t0,interval,y,Fs);% give the metronome sound during grip
        end
        gate5_beep_num=fix(gate5_time/interval)+1;
        for i=1:gate5_beep_num
            beep_time = soundbeep(beep_time,t0,interval,y,Fs);
        end
        acc=evaluate_acc(path,mark);
        acc_all{j,w}=acc;
        rt_all(j,w)=rt;
        path_all{j,w}=path;
        for i=1:4
            if acc(i)==1
                Screen('DrawTexture', window, imageDisplay_right, [], [feed_back_pos(whichgate(i)),feed_back_height,feed_back_pos(whichgate(i))+size(right_img,1),feed_back_height+size(right_img,2)],0);
            else
                Screen('DrawTexture', window, imageDisplay_wrong, [], [feed_back_pos(whichgate(i)),feed_back_height,feed_back_pos(whichgate(i))+size(wrong_img,1),feed_back_height+size(wrong_img,2)],0);
            end
        end
        Screen('DrawTexture', window, imageDisplay, [], [],0);
        Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
        Screen('Flip',window);
        feedback_beep_num=fix(feedback_time/interval);
          for i=1:feedback_beep_num
            beep_time = soundbeep(beep_time,t0,interval,y,Fs);
          end
    end
    if w<length(bpm)
    Screen('DrawTexture', window, imageDisplay7, [], [],0);
    Screen('Flip',window);
    wait4space;
    end
end
%% save 
cd data
filename=['practice' subinfo{1} '.mat'];
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
catch ErrorInfo
    disp(ErrorInfo);
    disp(ErrorInfo.identifier);
    disp(ErrorInfo.message);
    disp(ErrorInfo.stack);
    disp(ErrorInfo.cause);
    ListenChar;
    ShowCursor;
    sca;
    disp(['Urgently stoped!'])
    cd(root)
    cd data
    filename=['practice_emergency.mat'];
    save(filename,'acc_all','rt_all','path_all');
    cd ..
    disp(['Urgently saved!'])  
    toc
    unloadlibrary( 'USB_DAQ_DLL_V42');
end
