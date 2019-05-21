function mark=check_end(path0,time)
% check the end of train grip input
path0(time==0)=[];
%% filter to eliminate awag points
if length(path0)>10
    path=smoothdata(path0,'movmean',3);
    %% find local maxima in path
    [pks,~] = findpeaks(path);
    if length(pks)>4
        mark=1;
    else
        mark=0;
    end
else
    mark=0;
end
end