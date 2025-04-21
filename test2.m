numlayer=5;
wight = [0 1 0 0
    0 0.6 0.2 0
    0 1 0 0
    0 0.9 -1 0
    0 0.2 0 0];
numfeature = 128;
Wfeature = 3*(rand(1,128)-0.5);
StrideL = [2 2 2 2 2];
filter{1,1} = 2*rand(1,8)-1;
filter{2,1} = rand(1,8);
filter{1,2} = 2*rand(1,16)-1;
filter{2,2} = rand(1,16);
filter{1,3} = 2*rand(1,32)-1;
filter{2,3} = rand(1,32);
filter{1,4} = 2*rand(1,64)-1;
filter{2,4} = rand(1,64);
filter{1,5} = 2*rand(1,128)-1;
filter{2,5} = rand(1,128);
numimg = 50;
[outputCNN,outputfeaturemap] = netdefine(I(:,:,:,1:50),numlayer,filter,wight,Wfeature,StrideL,fism,numimg);