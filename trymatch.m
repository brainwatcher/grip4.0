pmode start local 2 % 

%% setting
% cd preparation
% back=imread('back.bmp');
% cd ..
% [window, rect] = Screen('Openwindow',window_screen,255/2);
% ratio=min(rect(3)/size(back,2),rect(4)/size(back,1)); % the ratio of zoom back image
% back_img=imresize(back,ratio);
% symbol_size=30;
% symbol_img=zeros(symbol_size,symbol_size,3);%cursorsize
% symbol_img(:,:,1)=255 ;
% symbol_img(:,:,2)=0;
% symbol_img(:,:,3)=0;
% imageDisplay_stop=Screen('MakeTexture', window, symbol_img);
% symbol_img(:,:,1)=0 ;
% symbol_img(:,:,2)=255;
% symbol_img(:,:,3)=0;
% imageDisplay_go=Screen('MakeTexture', window, symbol_img);
% symbol_img(:,:,1)=255 ;
% symbol_img(:,:,2)=255;
% symbol_img(:,:,3)=0;
% imageDisplay_ready=Screen('MakeTexture', window, symbol_img);
% symbol_pos=[0.6*rect(3),(rect(4)+size(back_img,1))*0.5-2*symbol_size];
% %% display
% Screen('DrawTexture', window, imageDisplay, [], [],0);
% Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
% Screen('DrawTexture', window, imageDisplay_go, [], [symbol_pos,symbol_pos+symbol_size],0);
% Screen('Flip',window,t0+i*interval);