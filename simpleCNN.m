function [outlayer] = simpleCNN(originalimg,Filter,M,N,W)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

J = Conv(originalimg,Filter);
X = dlarray(J,'SSCB');
YY = maxpool(X,M,'Stride',N);
y = extractdata(YY);
outlayer = LeakyReLU(y,W(1),W(2),W(3),W(4));
end

