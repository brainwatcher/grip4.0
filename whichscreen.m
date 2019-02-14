function [window_screen] = whichscreen
%WHICHSCREEN Summary of this function goes here
%   Detailed explanation goes here
Screen_num=Screen('Screens');
if length(Screen_num)>1
    window_screen=1;
else
    window_screen=0;
end
end

