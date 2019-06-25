function secs=wait4f
while 1
    [press,secs,keycode]=KbCheck;
    if press&&strcmpi(KbName(keycode),'f')
        break;      
    end
end
end

