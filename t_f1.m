%%
 try
    %% important parameter
    trial_num=[3,2];
    block=length(trial_num);
    wait_time=2;
    %     session= str2double(subinfo{2});
    %% prepare for screen
    root=pwd;
    cd(root);
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
    G=load(loadfilename);
    disp(['Your max force is ' num2str(G.max_grip/16) '...']);
    cd ..
    %% read background and sound file
    cd preparation
    back=imread('back.bmp');
    right=imread('right.png');
    wrong=imread('wrong.png');
    relax=imread('relax.bmp');
    train0=imread('train0.bmp');
    train1=imread('train1.bmp');
    B=load('back.mat');
    loadlibrary('USB_DAQ_DLL_V42','USB_DAQ_DLL_V42');
    cd ..
    %% open window
    [window, rect] = Screen('Openwindow',window_screen,255/2);%,[100,100,500,400]
    ratio=min(rect(3)/size(back,2),rect(4)/size(back,1)); % the ratio of zoom back image
    back_img=imresize(back,ratio);
    imageDisplay=Screen('MakeTexture', window, back_img);
    gate=B.gate0*ratio;% zoomed gate position
    base=(2*B.home0(2)-B.home0(1))*ratio;% shoot base threshold
    start=B.home0*ratio;% zoomed home position
    %% cursor
    cursor_size=25;
    cursor_img=ones(cursor_size,cursor_size);%cursorsize
    imageDisplay_cursor=Screen('MakeTexture', window, cursor_img);
    cursor_height=0.5*(rect(4));
    gate(:,2)=gate(:,2)-cursor_size;%%%%
    seq=[4,1,3,5,2];% gate sequence
    [~,~,whichgate]=intersect([1,2,3,4,5],seq);
    ans_gate=gate(whichgate,:);
    imageDisplay_result=zeros(1,4);
    shoot_color=[237,28,36;46,49,146;0,111,59;91,155,213;140,198,63];
    shoot_img=zeros(cursor_size,cursor_size,3);
    for i=1:5
        for j=1:3
            shoot_img(:,:,j)=shoot_color(i,j);
        end
        imageDisplay_result(i)=Screen('MakeTexture', window, shoot_img);
    end
    
    
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
    right_img=imresize(right,50/rect(3)*size(back_img,2)/max(size(right)));
    wrong_img=imresize(wrong,50/rect(3)*size(back_img,2)/max(size(wrong)));
    imageDisplay_right=Screen('MakeTexture', window, right_img);
    imageDisplay_wrong=Screen('MakeTexture', window, wrong_img);
    feed_back_height=0.5*(rect(4)-size(back_img,1))-50/rect(3)*size(back_img,2);
    feed_back_pos=mean(gate,2)+cursor_size/2-size(right_img,2)/2;
    
    %% relax
    relax_img=imresize(relax,min(rect(3)/size(relax,2),rect(4)/size(relax,1)));
    imageDisplay7=Screen('MakeTexture', window, relax_img);
    %% train begin
    train_begin_img=imresize(train0,min(rect(3)/size(train0,2),rect(4)/size(train0,1)));
    imageDisplay8=Screen('MakeTexture', window, train_begin_img);
    %% train end
    train_end_img=imresize(train1,min(rect(3)/size(train1,2),rect(4)/size(train1,1)));
    imageDisplay9=Screen('MakeTexture', window,train_end_img);
    %%
    low_bound=start(1);
    up_bound=0.5*(rect(3)+size(back_img,2));
    G.min_grip=G.min_grip+150;%% ×îµÍÖµ
    getloc=@(grip) (log(grip)-log(G.min_grip))/(log(double(G.max_grip*0.4))-log(G.min_grip))*(up_bound-low_bound)+low_bound;% log
    % getloc1=@(grip)((grip)-(min_grip))/((double(max_grip*0.4))-(min_grip))*(up_bound-low_bound)+low_bound;
    
    %% parameter
    calllib('USB_DAQ_DLL_V42','OpenUsb_V42');
    FrqSamp=100000;
    NumSamp=1024;
    NumBuf=1.0:NumSamp;
    penwidth=2;
    prepare_time=2;
    Screen('DrawTexture', window, imageDisplay8, [], [],0);
    Screen('Flip',window)
    acc_all=cell(1,block);
    rt_all=cell(1,block);
    rt0=cell(1,block);
    rt1=cell(1,block);
    path_all=cell(1,block);
    time_all=cell(1,block);
    loop_num=cell(1,block);
    max_time=15;
    for w=1:block
        acc_all{w}=cell(1,trial_num(w));
        rt_all{w}=nan(1,trial_num(w));
        rt0{w}=nan(1,trial_num(w));
        rt1{w}=nan(1,trial_num(w));
        path_all{w}=cell(1,trial_num(w));
        time_all{w}=cell(1,trial_num(w));
        loop_num{w}=zeros(1,trial_num(w));
        disp(['train ' num2str(w) ' begin']);
        wait4press;
        for j=1:trial_num(w)
            disp(['trial ' num2str(j) ' begin']);
            % trial parameter
            path=zeros(10000,1);
            time=zeros(10000,1);
            t0=GetSecs;
            Screen('DrawTexture', window, imageDisplay, [], [],0);
            Screen('DrawTexture', window, imageDisplay_cursor, [], [start(1),cursor_height,start(1)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
            Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
            Screen('Flip',window);
            WaitSecs(1.5+0.5*rand(1));
            %  red
            Screen('DrawTexture', window, imageDisplay, [], [],0);
            Screen('DrawTexture', window, imageDisplay_cursor, [], [start(1),cursor_height,start(1)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
            Screen('DrawTexture', window, imageDisplay_ready, [], [symbol_pos,symbol_pos+symbol_size],0);
            Screen('Flip',window);
            WaitSecs(1);
            % peep one times for yellow
            Screen('DrawTexture', window, imageDisplay, [], [],0);
            Screen('DrawTexture', window, imageDisplay_cursor, [], [start(1),cursor_height,start(1)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
            Screen('DrawTexture', window, imageDisplay_go, [], [symbol_pos,symbol_pos+symbol_size],0);
            rt0{w}(j)=Screen('Flip',window);
            ii=0;
            while GetSecs-rt0{w}(j)<max_time % the duration of no-response trial
                ii=ii+1;
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
                Screen('Flip',window);
                path(ii)=current_cursor;
                time(ii)=GetSecs;
                shoot_time=gate_count(path,time,base);% the time of shoot
                if  current_cursor>gate(4,1)&& shoot_time==5% end of the trial ;% note the 4 to 4.5
                    rt1{w}(j)=GetSecs;
                    Screen('DrawTexture', window, imageDisplay, [], [],0);
                    Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
                    Screen('DrawTexture', window, imageDisplay_cursor, [], [ gate(4,1),cursor_height, gate(4,1)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
                    Screen('Flip',window)
                    break
                elseif shoot_time>5
                    rt1{w}(j)=GetSecs;
                    Screen('DrawTexture', window, imageDisplay, [], [],0);
                    Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0)
                    Screen('Flip',window)
                    break
                end
            end
            loop_num{w}(j)=ii;
            if isnan(rt1{w}(j))
                rt1{w}(j)=max_time+rt0{w}(j);
            end
            disp(['trial ' num2str(j) ' acc evaluation begin']);
            [acc,path,time,shoot] = t_evaluate_acc(path,time,ans_gate,base);
            time_all{w}{j}=time;
            acc_all{w}{j}=acc;
            rt_all{w}(j)=rt1{w}(j)-rt0{w}(j);
            path_all{w}{j}=path;
            WaitSecs(1.5-GetSecs+rt1{w}(j));
            Screen('DrawTexture', window, imageDisplay, [], [],0);
            %%
            for i=1:5 %% note: change 1:4 to 1:5
                if acc(i)==1
                    Screen('DrawTexture', window, imageDisplay_right, [], [feed_back_pos(whichgate(i)),feed_back_height,feed_back_pos(whichgate(i))+size(right_img,2),feed_back_height+size(right_img,1)],0);
                else
                    Screen('DrawTexture', window, imageDisplay_wrong, [], [feed_back_pos(whichgate(i)),feed_back_height,feed_back_pos(whichgate(i))+size(wrong_img,2),feed_back_height+size(wrong_img,1)],0);
                end
                if i<5
                    Screen('DrawTexture', window, imageDisplay_result(i), [], [shoot(i),cursor_height, shoot(i)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
                else
                    if acc(i)==0
                        Screen('DrawTexture', window, imageDisplay_result(i), [], [shoot(i),cursor_height, shoot(i)+size(cursor_img,1),cursor_height+size(cursor_img,2)],0);
                    end
                end
            end
            Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
            Screen('Flip',window);
            WaitSecs(wait_time);
        end
        if w<block
            Screen('DrawTexture', window, imageDisplay7, [], [],0);
        else
            Screen('DrawTexture', window, imageDisplay9, [], [],0);
        end
        Screen('Flip',window);
        WaitSecs(1);
    end
    wait4press;
    cd data
    filename=['t_' subinfo{1} '_' subinfo{2} '.mat'];
    save(filename,'acc_all','rt_all','path_all','time_all','rt0','rt1','cursor_size','ans_gate','base','loop_num');
    disp(['Successfully saved train data!'])
    cd ..
    Screen('Closeall')
    ListenChar;
    ShowCursor;
    sca;
    unloadlibrary( 'USB_DAQ_DLL_V42');
catch ErrorInfo
    disp(ErrorInfo);
    disp(ErrorInfo.identifier);
    disp(ErrorInfo.message);
    disp(ErrorInfo.stack);
    disp(ErrorInfo.cause);
    cd data
    filename=['t_' subinfo{1} '_' subinfo{2} 'EM.mat'];
    save(filename);
    disp('Emergency saved during Training!');
    cd ..
    Screen('Closeall')
    ListenChar;
    ShowCursor;
    sca;
    unloadlibrary( 'USB_DAQ_DLL_V42');
end



