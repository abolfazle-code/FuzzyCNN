function [outputCNN,outputfeaturemap] = netdefine(originalimg,numlayer,filter,wight,Wfeature,StrideL,fism,numimg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
inlayer = originalimg;
%fism = readfis('wightfuzzyTS');
for j=1:numlayer
    %tic
    [outlayer] = fuzzyCNN(inlayer,filter{1,j},filter{2,j},3,StrideL(j),wight(j,:),fism,numimg);
    %toc
    %[outlayer] = simpleCNN(inlayer,filter{1,j},3,StrideL(j),wight(j,:));
    inlayer = outlayer;
end

numfeature = size(outlayer);
X = dlarray(outlayer,'SSCB');
YY = avgpool(X,numfeature(1));
y = extractdata(YY);
outputfeaturemap = reshape(y,numfeature(3),numfeature(4));
outputfeaturemap = (outputfeaturemap-min(outputfeaturemap(:)))/(max(outputfeaturemap(:))-min(outputfeaturemap(:)));
%%
% Fully Conected Layer

outputCNN = FCLfunction(outputfeaturemap,Wfeature);

end

