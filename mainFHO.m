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
for i = 1:80 %length(D)
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
for i = 81:180 %length(D)
    A = image1{1,i};
    B = imresize(A,[128,128]);
    I(:,:,:,i) = B;
end
fism = readfis('wightfuzzyTS');
%%
%sample
numimg = 180
tic
[error] = errorfunction(I,rand(1,629),[ones(1,80),-1*ones(1,100)],fism,numimg)
toc
%%
%training
CostFunction = @(x) errorfunction(I,x,[ones(1,80),-1*ones(1,100)],fism,numimg);          % @ Cost Function
VarNumber = 629;                         % Number of variables;
VarMin = [zeros(1,5), -10 *ones(1,128),-1 *ones(1,8),zeros(1,8),-1 *ones(1,16),zeros(1,16),-1 *ones(1,32),zeros(1,32),-1 *ones(1,64),zeros(1,64),-1 *ones(1,128),zeros(1,128)];        % Lower bound of variable;
VarMax = [ones(1,5),10 *ones(1,128),1 *ones(1,8),ones(1,8),1 *ones(1,16),ones(1,16),1 *ones(1,32),ones(1,32),1 *ones(1,64),ones(1,64),1 *ones(1,128),ones(1,128)];         % Upper bound of variable;

%% General Parameters of the Algorithm
MaxFes = 50 ;                       % Maximum number of generations
nPop = 10 ;                             % Maximum number of initial candidates
HN = randi([1 ceil(nPop/5)],1,1) ;      % Maximum number of FireHawks

% Counters
Iter=0;
FEs=0;

%% Initialization
Pop=[]; Cost=[];
for i=1:nPop
    % Initialize Positions
    Pop(i,:)=unifrnd(VarMin,VarMax,[1 VarNumber]);
    % Cost Function Evaluations
    Cost(i,1)=CostFunction(Pop(i,:));
    FEs=FEs+1;
end

% Sort Population
[Cost, SortOrder]=sort(Cost);
Pop=Pop(SortOrder,:);
BestPop=Pop(1,:);
SP=mean(Pop);

% Fire Hawks
FHPops=Pop(1:HN,:);

% Prey
Pop2=Pop(HN+1:end,:);

% Distance between  Fire Hawks and Prey
for i=1:HN
    nPop2=size(Pop2,1);
    if nPop2<HN
        break
    end
    Dist=[];
    for q=1:nPop2
        Dist(q,1)=distance(FHPops(i,:), Pop2(q,:));
    end
    [ ~, b]=sort(Dist);
    alfa=randi(nPop2);
    PopNew{i,:}=Pop2(b(1:alfa),:);
    Pop2(b(1:alfa),:)=[];
    if isempty(Pop2)==1
        break
    end
end
if isempty(Pop2)==0
    PopNew{end,:}=[PopNew{end,:} ;Pop2];
end

% Update Bests
GB=Cost(1);
BestPos=BestPop;

%% Main Loop
while FEs<MaxFes
    Iter=Iter+1;
    PopTot=[];
    Cost=[];
    for i=1:size(PopNew,1)
        PR=cell2mat(PopNew(i));
        FHl=FHPops(i,:);
        SPl=mean(PR);
        
        Ir=unifrnd(0,1,1,2);
        FHnear=FHPops(randi(HN),:);
        FHl_new=FHl+(Ir(1)*GB-Ir(2)*FHnear);
        FHl_new = max(FHl_new,VarMin);
        FHl_new = min(FHl_new,VarMax);
        PopTot=[PopTot ;FHl_new];
        
        for q=1:size(PR,1)
            
            Ir=unifrnd(0,1,1,2);
            PRq_new1=PR(q,:)+((Ir(1)*FHl-Ir(2)*SPl));
            PRq_new1 = max(PRq_new1,VarMin);
            PRq_new1 = min(PRq_new1,VarMax);
            PopTot=[PopTot ;PRq_new1];
            
            Ir=unifrnd(0,1,1,2);
            FHAlter=FHPops(randi(HN),:);
            PRq_new2=PR(q,:)+((Ir(1)*FHAlter-Ir(2)*SP));
            PRq_new2 = max(PRq_new2,VarMin);
            PRq_new2 = min(PRq_new2,VarMax);
            PopTot=[PopTot ;PRq_new2];
        end
    end
    for i=1:size(PopTot,1)
        Cost(i,1)=CostFunction(PopTot(i,:));
        FEs=FEs+1;
    end
    % Sort Population
    [Cost, SortOrder]=sort(Cost);
    PopTot=PopTot(SortOrder,:);
    Pop=PopTot(1:nPop,:);
    HN = randi([1 ceil(nPop/5)],1,1);
    BestPop=Pop(1,:);
    SP=mean(Pop);
    FHPops=Pop(1:HN,:);
    Pop2=Pop(HN+1:end,:);
    clear PopNew
    
    % Distance between  Fire Hawks and Prey
    for i=1:HN
        nPop2=size(Pop2,1);
        if nPop2<HN
            break
        end
        Dist=[];
        for q=1:nPop2
            Dist(q,1)=distance(FHPops(i,:), Pop2(q,:));
        end
        [ ~, b]=sort(Dist);
        alfa=randi(nPop2);
        PopNew{i,:}=Pop2(b(1:alfa),:);
        Pop2(b(1:alfa),:)=[];
        if isempty(Pop2)==1
            break
        end
    end
    if isempty(Pop2)==0
        PopNew{end,:}=[PopNew{end,:} ;Pop2];
    end
    % Update Bests
    if Cost(1)<GB
        BestPos=BestPop;
    end
    GB=min(GB,Cost(1));
    % Store Best Cost Ever Found
    BestCosts(Iter,1)=GB;
    % Show Iteration Information
    disp(['Iteration ' num2str(Iter) ': Best Cost = ' num2str(BestCosts(Iter))]);
end

Eval_Number=FEs;
Conv_History=BestCosts;
Best_Pos=BestPop;

BestCost = BestCosts(end);
%% Figure
figure = figure('Color',[1 1 1]);
G1=subplot(1,1,1,'Parent',figure);
maxcycle = numel(Conv_History);
x=zeros(maxcycle,1);
y=zeros(maxcycle,1);
for i = 1:maxcycle
    y(i,1) = Conv_History(i);
    x(i,1) = i;
end

plot(x,y,'r-','LineWidth',2);
xlabel('Iterations','FontWeight','bold','FontName','Times');
ylabel('Costs','FontWeight','bold','FontName','Times');
title (['Best Cost = ',num2str(BestCost)])
box on
xlim ([1 maxcycle]);
ylim ([0 Conv_History(1)]);
set(G1,'FontName','Times','FontSize',20,'FontWeight','bold',...
    'XMinorGrid','on','XMinorTick','on','YMinorGrid','on','YMinorTick','on');

%% Calculate the Euclidean Distance
function o = distance(a,b)
for i=1:size(a,1)
    o(1,i)=sqrt((a(i)-b(i))^2);
end
end



