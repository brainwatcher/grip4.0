%% key parameter
time=20;
lag=linspace(0,1,time)*0.3;
a=randperm(time);
lag=lag(a)';
interval=0.5;
%% window preparation
Screen('Preference', 'SkipSyncTests', 1);
[window, rect] = Screen('Openwindow',whichscreen,255);
cd preparation
var_list={'trymatch0','trymatch_left','trymatch_right'};
imageDisplay_key=zeros(length(var_list),1);
for i=1:length(var_list)
    eval([var_list{i} '=imread(''' var_list{i} '.bmp'');']);
    eval(['ratio=min(rect(3)/size(' var_list{i} ',2),rect(4)/size(' var_list{i} ',1));'])
    eval([var_list{i} '_img=imresize(' var_list{i} ',ratio);']);
    eval(['imageDisplay_key(i)=Screen(''MakeTexture'', window,' var_list{i} '_img);']);
end
cd ..
symbol_size=30;
symbol_pos=0.5*rect([3,4])-0.5*symbol_size;
symbol_img=zeros(symbol_size,symbol_size,3);%cursorsize
symbol_img(:,:,1)=255 ;
symbol_img(:,:,2)=0;
symbol_img(:,:,3)=0;
imageDisplay_stop=Screen('MakeTexture', window, symbol_img);
symbol_img(:,:,1)=0 ;
symbol_img(:,:,2)=255;
symbol_img(:,:,3)=0;
imageDisplay_go=Screen('MakeTexture', window, symbol_img);
%%
t0=zeros(time,1);
t1=zeros(time,1);
key=zeros(time,1);
labSend(time, 2);
for i=1:time
    Screen('DrawTexture', window, imageDisplay_stop, [], [symbol_pos,symbol_pos+symbol_size],0);
    t0(i)=Screen('Flip',window);
    WaitSecs(1);
    labSend(interval, 2);
    Screen('DrawTexture', window, imageDisplay_go, [], [symbol_pos,symbol_pos+symbol_size],0);
    t1(i)=Screen('Flip',window,t0(i)+interval+lag(i)+1);
    WaitSecs(1);
    Screen('DrawTexture', window, imageDisplay_key(1), [], [],0);
    Screen('Flip',window);
    key(i)=trymatch_key;
    switch key(i)
        case 0
            Screen('DrawTexture', window, imageDisplay_key(2), [], [],0);
            Screen('Flip',window);
        case 1
            Screen('DrawTexture', window, imageDisplay_key(3), [], [],0);
            Screen('Flip',window);
    end
    WaitSecs(1.5+rand(1)*0.5);
end
%%
T=table(lag,key,'VariableNames',{'lag','key'});
T=sortrows(T,2);
f1=@(param,xval) param(1)+(param(2)-param(1))./(1+10.^((param(3)-xval)*param(4)));
A0 =[0    1.0000    0.2000    1.0000]; %// Initial values fed into the iterative algorithm
A_fit = nlinfit(T.lag, T.key, f1, A0);
lag0=A_fit(3);
%%
cd data
prefix='trymatch';
filename=[prefix subinfo{1} '.mat'];
save(filename,'key','lag','f1','A_fit','A0','lag0')
disp([prefix 'Successfully saved!'])
cd ..
disp('Over');
Screen('Closeall');
% figure;plot(sort(lag),key,'b*')


