function y=grip(duration,window,rect)
close all;
clc;
cd preparation
loadlibrary('USB_DAQ_DLL_V42','USB_DAQ_DLL_V42');
cd ..
calllib('USB_DAQ_DLL_V42','OpenUsb_V42');
%   ADsigle=0;
%   [~,ADsigle]=calllib('USB_DAQ_DLL_V42','AD_single_V42',1,0, ADsigle); %AD_single_V42(int mod_in,int chan, short* adResult);读通道0 单端模式，增益1
%   adv=10.24*ADsigle/32768

%以10K的采样速率连续采集1024个点，增益为0，过采样0
% duration=5;
FrqSamp=100000;
NumSamp=1024;
penwidth=2;
% k=round(duration*FrqSamp/NumSamp);
y=[];
t0=GetSecs;
while GetSecs-t0<duration
    NumBuf=1.0:NumSamp;
    [~,NumBuf]=calllib('USB_DAQ_DLL_V42','AD_continu_V42',1,0, NumSamp,FrqSamp,NumBuf);%AD_continu_V42(int mod_in,int chan, int Num_Sample,int Rate_Sample,short  *databuf);
    y=[y,NumBuf];
    Screen('FrameRect', window,[0 0 0], [0.2*rect(3),0.7*rect(4)-penwidth,0.8*rect(3),0.73*rect(4)+penwidth],2);
    Screen('FillRect', window,[0 0 0], [0.2*rect(3),0.7*rect(4),0.2*rect(3)+0.6*rect(3)*(GetSecs-t0)/duration,0.73*rect(4)]);
    Screen('Flip',window,[],2);
end
    Screen('FrameRect', window,[0 0 0], [0.2*rect(3),0.7*rect(4)-penwidth,0.8*rect(3),0.73*rect(4)+penwidth],2);
    Screen('FillRect', window,[0 0 0], [0.2*rect(3),0.7*rect(4),0.8*rect(3),0.73*rect(4)]);
    Screen('Flip',window,[],0);
calllib('USB_DAQ_DLL_V42','CloseUsb_V42');
unloadlibrary( 'USB_DAQ_DLL_V42');
end