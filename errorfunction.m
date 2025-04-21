function [error] = errorfunction(sample,x,Y,fism,numimg)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%{
numlayer=3;
wight = [0 x(1) 0 0
    0 x(2) 0 0
    0 x(3) 0 0];
Wfeature = x(4:131);
StrideL = [2 4 4];
filter{1,1} = x(132:163);
filter{2,1} = x(164:195);
filter{1,2} = x(196:259);
filter{2,2} = x(260:323);
filter{1,3} = x(324:451);
filter{2,3} = x(452:579);
%}

numlayer=5;
wight = [0 x(1) 0 0
    0 x(2) 0 0
    0 x(3) 0 0
    0 x(4) 0 0
    0 x(5) 0 0];
Wfeature = x(6:133);
StrideL = [2 2 2 2 2];
filter{1,1} = x(134:141);
filter{2,1} = x(142:149);
filter{1,2} = x(150:165);
filter{2,2} = x(166:181);
filter{1,3} = x(182:213);
filter{2,3} = x(214:245);
filter{1,4} = x(246:309);
filter{2,4} = x(310:373);
filter{1,5} = x(374:501);
filter{2,5} = x(502:629);
%}

%fism = readfis('wightfuzzyTS');
C = sample(:,:,:,1:numimg)/255;
[outputCNN,outputfeaturemap] = netdefine(C,numlayer,filter,wight,Wfeature,StrideL,fism,numimg);

Yest = outputCNN;
error = sum((Yest-Y).^2);
end

