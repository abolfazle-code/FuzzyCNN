clear;
clc;

D = dir('dataset\train\yes\*.jpg');
image = cell(1,numel(D));
	for i = 1:length(D)
        Filename = strcat('dataset\train\yes\',D(i).name)
        image{i} = imread(Filename); %%: reading image
    end
figure(1);
imshow(image{1,1})
I = zeros(128,128,3,length(D));
for i = 1:150 %length(D)
    A = image{1,i};
    s = size(A);
    AA = zeros(s(1),s(2),3);
    if numel(s)==3
        B = imresize(A,[128,128]);
    else
        AA(:,:,1) = A; 
        AA(:,:,2) = A;
        AA(:,:,3) = A;
        B = uint8(imresize(AA,[128,128]));
    end
    I(:,:,:,i) = B;
end
G = dir('dataset\train\no\*.jpg');
image1 = cell(1,numel(G));
	for i = 1:length(G)
        Filename = strcat('dataset\train\no\',G(i).name)
        image1{i} = imread(Filename); %%: reading image
    end
figure(1);
imshow(image1{1,1})
for i = 151:300 %length(D)
    A = image1{1,i};
    B = imresize(A,[128,128]);
    I(:,:,:,i) = B;
end
fism = readfis('wightfuzzyTS');

numlayer=5;
wight = [0 1 0 0
    0 0.6 0.2 0
    0 1 0 0
    0 0.9 -1 0
    0 0.2 0 0];
numfeature = 128;
Wfeature = rand(1,128)-0.5;
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
numimg = 300;
tic
    C = I(:,:,:,1:300)/255;
    [outputCNN,outputfeaturemap] = netdefine(C,numlayer,filter,wight,Wfeature,StrideL,fism,300);
toc
tic
[error] = errorfunction(I,rand(1,629),[ones(1,150),-1*ones(1,150)],fism,numimg)
toc