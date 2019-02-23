function tryforce
try
cd preparation
loadlibrary('USB_DAQ_DLL_V42','USB_DAQ_DLL_V42');
calllib('USB_DAQ_DLL_V42','OpenUsb_V42');
% [~,NumBuf]=calllib('USB_DAQ_DLL_V42','AD_continu_V42',1,0, NumSamp,FrqSamp,NumBuf);
cd ..
duration=5;
FrqSamp=100000;
NumSamp=1024;
NumBuf=1.0:NumSamp; 


% x0=linspace(0,1,FrqSamp+1);
% x0=x0(1:end-1);
% x=x0;
% y=zeros(1,length(x));

h=figure;
y=zeros(1,duration*FrqSamp);
x=linspace(0,duration,duration*FrqSamp+1);
x=x(1:end-1);
x0=[];
y0=[];

plot(x0,y0,'b');
hold on
xlim([0 duration])
ylim([-10,800])
drawnow;
% linkdata on

t0=GetSecs;
while GetSecs-t0<(duration-2*NumSamp/FrqSamp)
        [~,NumBuf]=calllib('USB_DAQ_DLL_V42','AD_continu_V42',1,0, NumSamp,FrqSamp,NumBuf);%AD_continu_V42(int mod_in,int chan, int Num_Sample,int Rate_Sample,short  *databuf);
        k=round(FrqSamp*(GetSecs-t0))+(1:NumSamp);
        x0=x(k);
        y0=NumBuf;
        plot(x0,y0,'b')
%         refreshdata;
        drawnow;
end 

calllib('USB_DAQ_DLL_V42','CloseUsb_V42');
unloadlibrary( 'USB_DAQ_DLL_V42');
WaitSecs(2);
close(h)
catch ErrorInfo
    disp(ErrorInfo);
    disp(ErrorInfo.identifier);
    disp(ErrorInfo.message);
    disp(ErrorInfo.stack);
    disp(ErrorInfo.cause); 
    calllib('USB_DAQ_DLL_V42','CloseUsb_V42');
unloadlibrary( 'USB_DAQ_DLL_V42');
close(h)
end

%     x = [1 2];
% y = [4 4];
% plot(x,y);
% xlim([0 ntimes])
% ylim([2.5 4])
% xlabel('Iteration')
% ylabel('Approximation for \pi')
% 
% 
% 
% denom = 1;
% k = -1;
% for t = 3:100
%     denom = denom + 2;
%     x(t) = t;
%     y(t) = 4*(y(t-1)/4 + k/denom);
%     k = -k;
% end