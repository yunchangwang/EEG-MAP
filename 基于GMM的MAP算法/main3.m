clear
clc
P=9; %人的个数
K = 4; %运动想象的个数
Fs = 250; %采样频率
channelnum=8; %8通道的测试,可以修改通道数
tic
for p=1:P
%-----------------------这里先导入第一个人的数据测试一下--------------------%
    str_k = num2str(p);
    filename=strcat('D:\基于GMM的EM算法\2008BCI数据\A0XT_V2\subject',str_k,'_V2.mat');
    signal_filter_data=load (filename);%导入预处理后的数据signalF
    %将结构体变成元胞数组
    trials=struct2cell(signal_filter_data.trials);
    %得到所有数据的标签
    Classlabel=signal_filter_data.trials.Classlabel;
    %从当中挑选一半的数据作为训练数据
    [Data_length,~]=size(Classlabel);
    for k=1:K
        %找到标签是k的所有trial
        idtmp = find(Classlabel==k);
        %找出一半的标签用于训练
        index=idtmp(1:size(idtmp,1));
        for i=1:size(index,1)
            data_temp((i-1)*750+1:i*750,:)=trials{index(i)+3,1};
        end
        %从中选取特定的通道
        signal_filter=zeros(size(data_temp,1),channelnum);
        signal_filter(:,1)=data_temp(:,8);
        signal_filter(:,2)=data_temp(:,10);
        signal_filter(:,3)=data_temp(:,12);
        signal_filter(:,4)=data_temp(:,15);
        signal_filter(:,5)=data_temp(:,17);
        signal_filter(:,6)=data_temp(:,19);
        signal_filter(:,7)=data_temp(:,20);
        signal_filter(:,8)=data_temp(:,21);
        
        size_idtmp=size(idtmp,1);
        T=size_idtmp/2; %样本个数
        len=3; %3秒钟一个平均
        PLVM = zeros(channelnum,channelnum,T);
        for j=1:T
            for i = len*(j-1)+1:len*j
                allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %一秒钟数据计算一个PLV值
                [samples,channels] = size(allCH);
                for ch1 = 1:channels
                    for ch2 = ch1:channels
                        tmpCh1 = allCH(:,ch1);
                        tmpCh2 = allCH(:,ch2);
                        PLVch(ch1,ch2) = plv_hilbert(tmpCh1,tmpCh2); %plv_hilbert函数计算两通道间的相同步指数
                    end
                end
                PLVM(:,:,j) = PLVM(:,:,j) + PLVch(:,:); %3s的PLV值叠加
            end
        end
        for j = 1:T
            PLVMavg(:,:,j) = PLVM(:,:,j)/len; %3s求平均
        end
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
end
%---------------------------每个人得到的数据进行10次测试---------------------%
