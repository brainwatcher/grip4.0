clear all
cd preparation
load metro.mat
cd ..
% y=5*y;
for i=1:5
sound(y,Fs);

WaitSecs(0.3);
end