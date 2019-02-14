function  wait4press
%WAITESC Summary of this function goes here
%   Detailed explanation goes here
KbName('UnifyKeyNames')
KbCheckList = [KbName('space'),KbName('ESCAPE'),KbName('s')];
RestrictKeysForKbCheck(KbCheckList);
keyIsDown=0;
keyCode=[];
while ~keyIsDown
    [keyIsDown,~,keyCode] = KbCheck;
end
if keyCode(KbName('ESCAPE'))
sca;
error('Quit by Esc.')

end
end

