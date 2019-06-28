subinfo=m_getsubinfo;  
cd data
prefix='trymatch';
filename=[prefix subinfo{1} '.mat'];
S=load(filename);
disp(['lag0=' num2str(S.lag0)])
cd ..
T=table(S.lag,S.key,'VariableNames',{'lag','key'});
T=sortrows(T,2);
%%
f=@(param,xval) param(1)+(param(2)-param(1))./(1+10.^((param(3)-xval)*param(4)));
A0 =[0    1.0000    0.2000    1.0000]; %// Initial values fed into the iterative algorithm
A_fit = nlinfit(T.lag, T.key, f, A0);
%%
figure;plot(T.lag,T.key,'b*')
axis([0,max(S.lag),-0.2,1.2])
yticks([0,1])
hold on
y1=f(A_fit,0:0.01:max(S.lag));
plot(0:0.01:max(S.lag),y1,'--')
lag=A_fit(3);
plot(lag,f(A_fit,lag),'r*');
text(lag+0.03,f(A_fit,lag),['lag=' num2str(lag)])