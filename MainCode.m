%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following code are extracted from the reference below:
% https://authors.elsevier.com/sd/article/S2666-7207(22)00018-2
% Please cite this article as:
%  M. Mirrashid and H. Naderpour, Transit search: An optimization algorithm
%  based on exoplanet exploration; Results in Control and Optimization
%  (2022), doi: https://doi.org/10.1016/j.rico.2022.100127.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all

%% Definition of the Cost Function and its variables

D = dir('dataset\train\yes\*.jpg');
image = cell(1,numel(D));
	for i = 1:length(D)
        Filename = strcat('dataset\train\yes\',D(i).name)
        image{i} = imread(Filename); %%: reading image
    end
figure(1);
imshow(image{1,1})
I = zeros(128,128,3,length(D));
for i = 1:20 %length(D)
    A = image{1,i};
    B = imresize(A,[128,128]);
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
for i = 21:40 %length(D)
    A = image1{1,i};
    B = imresize(A,[128,128]);
    I(:,:,:,i) = B;
end

fism = readfis('wightfuzzyTS');
%%
%sample
numimg = 40
tic
[error] = errorfunction(I,rand(1,629),[ones(1,20),-1*ones(1,20)],fism,numimg)
toc
%%
%training
CostFunction = @(x) errorfunction(I,x,[ones(1,20),-1*ones(1,20)],fism,numimg);          % @ Cost Function
nV = 629;                         % Number of variables;
Vmin = [zeros(1,5), -10 *ones(1,128),0 *ones(1,8),zeros(1,8),0 *ones(1,16),zeros(1,16),0 *ones(1,32),zeros(1,32),0 *ones(1,64),zeros(1,64),0 *ones(1,128),zeros(1,128)];        % Lower bound of variable;
Vmax = [ones(1,5),10 *ones(1,128),1 *ones(1,8),ones(1,8),1 *ones(1,16),ones(1,16),1 *ones(1,32),ones(1,32),1 *ones(1,64),ones(1,64),1 *ones(1,128),ones(1,128)];         % Upper bound of variable;

%% Definition of the Algorithm Parameters
ns = 5;                 % Number of Stars
SN = 3;                % Signal to Noise Ratio
% Note: (ns*SN)=Number of population for the TS algorithm
maxcycle=50;           % max number of iterations

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
