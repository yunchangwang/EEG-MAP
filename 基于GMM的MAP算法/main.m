%-----------------------用于进行二分类，测试该脑电数据是否属于这个人------------------------%
clear
clc
K = 20; %测试人员的数量
Fs = 256; %采样频率
channelnum = 4; %通道个数

tic
for k=1:K
    %------------------数据预处理：滤波并去公共平均------------------%
    
    str_k = num2str(k);
    filename = strcat('D:\ADdata\signalF',str_k,'.mat');
    load (filename); %导入预处理后的数据signalF
    
    [B,A] = butter(2,[30/(Fs/2) 40/(Fs/2)]); %滤波到gamma频段
    signal_filter_temp= filter(B,A,signalF(:,1:15));
    %-----------------------从特定的通道中获取数据-------------------%
   signal_filter=zeros(size(signal_filter_temp,1),channelnum);
   signal_filter(:,1)=signal_filter_temp(:,8);
   signal_filter(:,2)=signal_filter_temp(:,10);
   signal_filter(:,3)=signal_filter_temp(:,12);
   signal_filter(:,4)=signal_filter_temp(:,15);
    
    %-----------------------计算两两通道的PLV值----------------------%
    T=16;%样本个数
    len=30;%30s平均
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
        PLVMavg(:,:,j) = PLVM(:,:,j)/len; %4s求平均
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
toc
%--------------------得到训练数据和测试数据------------------------%
%真实标记
 for a=1:10
        Tr = T/2; %训练样本
        Te = T - Tr; %测试样本
        [ trainData,testData ] = getsource( PLVall,K,T,Tr);
        %真实标记
        label_real = [];
        for i = 1:K
            label_real = [label_real i*ones(1,Te)];
        end
        [Pix_all,W,Mu,Sigma ] = MAP_train3(trainData,K,0.22);
        all_W{a}=W;
        %all_W{p,z}=W;
        all_loglik{a}=Pix_all;
        %all_loglik{p,z}=loglik;
        [LABELS_TEST] = GMM_MAP_test2( testData,W,Mu,Sigma,K );
        compare = (label_real == LABELS_TEST);
        MAP_accuracy2(a) = sum(compare)/size(label_real,2); %分类正确率,这是同一个人的10次
 end
accuracy=sum(MAP_accuracy2,2)/10;
figure;
plot(accuracy);
title('10次的平均正确效');