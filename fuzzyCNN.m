function [outlayer] = fuzzyCNN(originalimg,H,code,M,N,W,fism,numimg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Z = numel(H);
Filter = zeros(3,3,Z);
Wout = wightingfunc(H,code,9,1,fism);
for i=1:Z 
    Filter(:,:,i) = reshape(Wout((9*(i-1)+1):9*i),[3,3]);
end
J = Conv(originalimg,Filter,numimg);
X = dlarray(J,'SSCB');
YY = maxpool(X,M,'Stride',N);
y = extractdata(YY);
outlayer = LeakyReLU(y,W(1),W(2),W(3),W(4));

end
