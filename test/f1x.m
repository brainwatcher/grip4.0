function [t0] = f1x()
%F1X 此处显示有关此函数的摘要
%   此处显示详细说明
window_screen=whichscreen;
cd preparation
back=imread('back.bmp');
bpm_prepare=imread('bpm_prepare.bmp');
cd ..
[window, rect] = Screen('Openwindow',window_screen,255/2,[100,100,500,400]);
ratio=min(rect(3)/size(back,2),rect(4)/size(back,1)); % the ratio of zoom back image 
% back_img=imresize(back,ratio);
% imageDisplay=Screen('MakeTexture', window, back_img);
bpm_prepare_img=imresize(bpm_prepare,min(rect(3)/size(bpm_prepare,2),rect(4)/size(bpm_prepare,1)));
imageDisplay8=Screen('MakeTexture', window, bpm_prepare_img);
Screen('DrawTexture', window, imageDisplay8, [], [],0);
t0=Screen('Flip',window)
end

