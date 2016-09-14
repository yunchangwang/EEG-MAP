clear
clc
Fs = 250;
channelnum = 8; %通道个数
K=4;
%设置指定的通道
channel=[8,10,12,15,17,19,20,21];
%导入测试的数据
load('2003BCI数据/l1b.mat');
test_data=s(:,channel);
%导入人物的想象标签
load('2003BCI数据/truelabell1.mat');
true_labell1=truelabell1;
Classlabel=HDR.Classlabel;
%导入每次想象开始时的数据行数
TRIG=HDR.TRIG;
%导入trail是否被抛弃的标签
ArtifactSelection=HDR.ArtifactSelection;
%用来存储4中不同想象的数据,并且测试数据和验证数据分开
trainData_left=[];testData_left=[];
trainData_right=[];testData_right=[];
trainData_foot=[];testData_foot=[];
trainData_word=[];testData_word=[];
train_p1=1;test_p1=1;
train_p2=1;test_p2=1;
train_p3=1;test_p3=1;
train_p4=1;test_p4=1;
%将4类的运动想象数据分开
for i=1:length(true_labell1)
    %得到标签号
    label=true_labell1(i);
    %得到真实class
    class=Classlabel(i);
    if ArtifactSelection(i)==1
        continue;
    end
    %得到实验的起始行
    line_num=TRIG(i);
    %从test_data中取相应的行数
    temp=test_data(line_num+Fs*4+1:line_num+Fs*7,:);
    %temp=test_data(line_num:line_num+Fs*3-1,:);
    if isnan(class)==0
        %说明是训练数据
         if label==1
            trainData_left(train_p1:train_p1+Fs*3-1,:)=temp;
            train_p1=train_p1+Fs*3;
        end
         if label==2
            trainData_right(train_p2:train_p2+Fs*3-1,:)=temp;
            train_p2=train_p2+Fs*3;
         end
         if label==3
            trainData_foot(train_p3:train_p3+Fs*3-1,:)=temp;
            train_p3=train_p3+Fs*3;
         end
         if label==4
            trainData_word(train_p4:train_p4+Fs*3-1,:)=temp;
            train_p4=train_p4+Fs*3;
         end
    else
        %说明是测试数据
        if label==1
            testData_left(test_p1:test_p1+Fs*3-1,:)=temp;
            test_p1=test_p1+Fs*3;
        end
         if label==2
            testData_right(test_p2:test_p2+Fs*3-1,:)=temp;
            test_p2=test_p2+Fs*3;
         end
         if label==3
            testData_foot(test_p3:test_p3+Fs*3-1,:)=temp;
            test_p3=test_p3+Fs*3;
         end
         if label==4
            testData_word(test_p4:test_p4+Fs*3-1,:)=temp;
            test_p4=test_p4+Fs*3;
         end
    end
end

for k=1:K
    if k==1
        signal_filter=trainData_left;
    end
     if k==2
        signal_filter=trainData_right;
     end
     if k==3
        signal_filter=trainData_foot;
     end
     if k==4
        signal_filter=trainData_word;
     end
 %-----------------------计算两两通道的PLV值----------------------%
    T=30;%样本个数
    len=3;%3s平均
    PLVM=zeros(size(signal_filter,2),size(signal_filter,2),T);
    for j = 1:T
        for i = len*(j-1)+1:len*j
            allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %3s钟数据计算一个PLV值
            [samples,channels] = size(allCH);
            for ch1 = 1:channels
                for ch2 = ch1:channels
                    tmpCh1 = allCH(:,ch1);
                    tmpCh2 = allCH(:,ch2);
                    PLVch(ch1,ch2) = plv_hilbert(tmpCh1,tmpCh2); %plv_hilbert函数计算两通道间的相同步指数
                end
            end
            PLVM(:,:,j) = PLVM(:,:,j) + PLVch(:,:); %1s的PLV值叠加
        end
    end
    for j = 1:T
        PLVMavg(:,:,j) = PLVM(:,:,j)/len; %3s求平均
    end
    %---------------------数据拉直整合成一个矩阵--------------------%
    [m,n,c] = size(PLVMavg);
    for i = 1:m
        for j = i+1:n
            PLVstr((i-1)*channelnum+j,:) = PLVMavg(i,j,:); %一个被试的数据整合成一列
        end
    end
    [a,b] = find(PLVstr==0);
    PLVstr(a,:) = []; %去掉重复数据
    PLVall(:,(k-1)*T+1:k*T) = PLVstr; %所有被试的数据放在一个矩阵
    PLVstr = []; %初始化 
end
 %-----------------------得到训练数据----------------------%
trainData=PLVall;

for k=1:K
    if k==1
        signal_filter=testData_left;
    end
     if k==2
        signal_filter=testData_right;
     end
     if k==3
        signal_filter=testData_foot;
     end
     if k==4
        signal_filter=testData_word;
     end
 %-----------------------计算两两通道的PLV值----------------------%
    T=30;%样本个数
    len=3;%2s平均
    PLVM=zeros(size(signal_filter,2),size(signal_filter,2),T);
    for j = 1:T
        for i = len*(j-1)+1:len*j
            allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %两秒钟数据计算一个PLV值
            [samples,channels] = size(allCH);
            for ch1 = 1:channels
                for ch2 = ch1:channels
                    tmpCh1 = allCH(:,ch1);
                    tmpCh2 = allCH(:,ch2);
                    PLVch(ch1,ch2) = plv_hilbert(tmpCh1,tmpCh2); %plv_hilbert函数计算两通道间的相同步指数
                end
            end
            PLVM(:,:,j) = PLVM(:,:,j) + PLVch(:,:); %1s的PLV值叠加
        end
    end
    for j = 1:T
        PLVMavg(:,:,j) = PLVM(:,:,j)/len; %3s求平均
    end
    %---------------------数据拉直整合成一个矩阵--------------------%
    [m,n,c] = size(PLVMavg);
    for i = 1:m
        for j = i+1:n
            PLVstr((i-1)*channelnum+j,:) = PLVMavg(i,j,:); %一个被试的数据整合成一列
        end
    end
    [a,b] = find(PLVstr==0);
    PLVstr(a,:) = []; %去掉重复数据
    PLVall(:,(k-1)*T+1:k*T) = PLVstr; %所有被试的数据放在一个矩阵
    PLVstr = []; %初始化 
end
 %-----------------------得到测试数据----------------------%
testData=PLVall;

for a=1:10
    %得到训练和测试数据
    Tr = T/2; %训练样本
    Te = T - Tr; %测试样本
    %[ trainData,testData ] = getsource( PLVall,K,T,Tr);
    %真实标记
    label_real = [];
    for i = 1:K
        label_real = [label_real i*ones(1,Te)];
    end
    %训练
    [loglik,W,Mu,Sigma ] = MAP_train(trainData,K,0.22);
    all_W{a}=W;
    all_loglik{a}=loglik;
    %测试
    [kapa,LABELS_TEST] = GMM_MAP_test3( testData,W,Mu,Sigma,K );
    %计算kapa值
    Pa=(sum(diag(kapa))-kapa(K+2,K+2))/kapa(K+2,K+2);
    Pe=0;
    for j=2:K+1
        Pe=Pe+kapa(K+2,j)*kapa(j,K+2)/kapa(K+2,K+2)^2;
    end
    kapa_k(a)=(Pa-Pe)/(1-Pe);
    %计算正确率
    compare = (label_real == LABELS_TEST);
    MAP_accuracy2(a) = sum(compare)/size(label_real,2);
end