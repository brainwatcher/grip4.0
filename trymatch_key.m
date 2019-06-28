function key = trymatch_key
%TRYMATCH_KEY Summary of this function goes here
%   Detailed explanation goes here
KbName('UnifyKeyNames')
KbCheckList = [KbName('LeftArrow'),KbName('RightArrow'),KbName('ESCAPE')];
RestrictKeysForKbCheck(KbCheckList);
keyIsDown=0;
keyCode=[];
while ~keyIsDown
    [keyIsDown,~,keyCode] = KbCheck;
end
if keyCode(KbName('ESCAPE'))
    sca;
    error('Quit by Esc.')
elseif keyCode(KbName('LeftArrow'))
    key=0;
    return
elseif keyCode(KbName('RightArrow'))
    key=1;
    return    
end
end

