function wait4space
while 1
    [press,~,keycode]=KbCheck;
    if press&&strcmpi(KbName(keycode),'space')
        break;      
    end
end
end

