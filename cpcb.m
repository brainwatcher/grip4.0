function cpcb
 myCluster = parcluster('local');
 delete(myCluster.Jobs);
 
% delete(gcp('nocreate'));
end

