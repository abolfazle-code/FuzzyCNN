%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following code are extracted from the reference below:
% https://authors.elsevier.com/sd/article/S2666-7207(22)00018-2
% Please cite this article as:
%  M. Mirrashid and H. Naderpour, Transit search: An optimization algorithm
%  based on exoplanet exploration; Results in Control and Optimization
%  (2022), doi: https://doi.org/10.1016/j.rico.2022.100127.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all

fism = readfis('wightfuzzyTS');
%%
%sample

load('matlab1.mat');

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
numimg = 300;
[outputfeaturemap] = FCNNfunction(I,Best_Solution,[ones(1,150),-1*ones(1,150)],fism,numimg);
%%
%training
CostFunction = @(x) wfunc(x,outputfeaturemap);          % @ Cost Function
nV = 128;                         % Number of variables;
Vmin =  -1 *ones(1,128);        % Lower bound of variable;
Vmax = 1 *ones(1,128);         % Upper bound of variable;

%% Definition of the Algorithm Parameters
ns = 50;                 % Number of Stars
SN = 30;                % Signal to Noise Ratio
% Note: (ns*SN)=Number of population for the TS algorithm
maxcycle=500;           % max number of iterations

%% Transit Search Optimization Algorithm
disp('Transit Search is runing...')
[Bests] = TransitSearch (CostFunction,Vmin,Vmax,nV,ns,SN,maxcycle);
Best_Cost = Bests(maxcycle).Cost
Best_Solution = Bests(maxcycle).Location

%% Figure
figure = figure('Color',[1 1 1]);
G1=subplot(1,1,1,'Parent',figure);

x=zeros(maxcycle,1);
y=zeros(maxcycle,1);
for i = 1:maxcycle
    y(i,1) = Bests(i).Cost;
    x(i,1) = i;
end

plot(x,y,'r-','LineWidth',2);
xlabel('Iterations','FontWeight','bold','FontName','Times');
ylabel('Costs','FontWeight','bold','FontName','Times');
title (['Best Cost = ',num2str(Bests(maxcycle).Cost)])
box on
xlim ([1 maxcycle]);
ylim ([Bests(maxcycle).Cost Bests(1).Cost]);
set(G1,'FontName','Times','FontSize',20,'FontWeight','bold',...
    'XMinorGrid','on','XMinorTick','on','YMinorGrid','on','YMinorTick','on');
[outestime] = FCLfunction(outputfeaturemap,Best_Solution);
outreal = [ones(1,150) -1*ones(1,150)];
test_accuracy = 100*sum(outestime==outreal)/numel(outreal)
figure;
plotconfusion((outreal+1)/2,(outestime+1)/2)
