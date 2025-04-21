datatest;
%% Training Side
Xin = datafeatureimag(:,[1 2]);
Xout = datafeatureimag(:,end);
Yin = datafeatureimag(:,[1 2]);
Yout = datafeatureimag(:,end);
[C,S] = subclust([Xin Xout],[0.4     0.4         0.6])
fistot1 = genfis2(Xin,Xout,[0.4     0.4         0.6])
outfis = anfis([Xin Xout],fistot1,[5000 0 0.9]);
%[fistot3,error1,ss,fistot4,error2]=anfis([Xin Xout],outfis,[500 0 0.1],[],[Yin Yout])
%[fistot5,error1,ss,fistot6,error2]=anfis([Xin Xout],fistot4,[1000 0 0.1],[],[Yin Yout])

g=evalfis(Xin,outfis)
e=abs((g-Xout)./(Xout+0.1))*100
m2=mean(e)
a2=min(e)
b2=max(e)

figure(1)
t=0:0.01:1;
plot(t,t);
hold on
plot(g,Xout,'+');
