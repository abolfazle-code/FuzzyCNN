clear;
clc;
I = imread('cameraman.tif');
figure(1);
imshow(I)
originalRGB = imread('peppers.png');
figure(2);
imshow(originalRGB)
h = [1 0 1
    0 0 0
    1 0 1];
J=imfilter(I,h,'conv');
figure(3);
imshow(J)
[outimg] = stridefunc(J,2);
figure(4);
imshow(outimg)


w = uint8(convn(I,h,'same'));
figure(5);
imshow(w)

H(:,:,1) = h;
H(:,:,2) = h;
H(:,:,3) = h;
H(:,:,4) = h;
%tic
Jrgb=imfilter(originalRGB,H,'conv');
%toc
figure(6);
imshow(Jrgb)
tic
Jrgb = uint8(convn(originalRGB,H,'same'));
%Jrgb = Conv(rgb2gray(originalRGB),H)
toc
figure(7);
imshow(Jrgb)
JJ = Jrgb(:,:,1)+Jrgb(:,:,2)+Jrgb(:,:,3);
X = dlarray(double(JJ),'SSCB');
YY1 = maxpool(X,3,'Stride',2);
y1 = extractdata(YY1);
YY2 = avgpool(X,3,'Stride',2);
y2 = extractdata(YY2);
y3 = Pool(double(JJ),3,2);
[outimg] = stridefunc(Jrgb,3);
figure(8);
imshow(outimg)
fism = readfis('wightfuzzyTS');
Wout = wightingfunc(0.5,0.7,9,1,fism)
[outlayer] = simpleCNN(originalRGB,H,3,4,[0,0.3,-1,1]);
[outlayernew] = fuzzyCNN(originalRGB,[-0.3,0.1,0.6,0.4],[0.1 0.3 0.7 1],3,2,[0,0.3,-1,1],fism);
