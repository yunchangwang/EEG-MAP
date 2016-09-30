clear
clc
P=1; %人的个数
K = 4; %运动想象的个数
Fs = 250; %采样频率
channelnum=8; %8通道的测试,可以修改通道数
tic
for p=1:P
%-----------------------这里先导入第一个人的数据测试一下--------------------%
    %str_k = num2str(p);
    %filename = strcat('E:\深度学习课题\GMM-EEG\20120530BCI竞赛2008数据提取\20120530BCI竞赛2008数据提取\data_V1\A0XT_V1\subject',str_k,'_V1.mat');
    filename=strcat('D:\基于GMM的EM算法\2003BCI预处理\trials.mat');
    signal_filter_data=load (filename);%导入预处理后的数据signalF
    temp_data=[];
    PLVall=[];
    length=zeros(1,K);
    subject_T=zeros(1,K);
    for k=1:K
         %-------------由于这里的数据是各种想象运动混合在一起，所以要再次提取，标签1是想象左手----------------%
         idtmp = find(signal_filter_data.trials.data(:,61)==k);
         size_idtmp=size(idtmp,1);
         idtmp(size(idtmp,1)+1)=NaN;
         begin_num=idtmp(1);
         num=1;
         for i=1:size_idtmp
             if(idtmp(i)~=idtmp(i+1)-1||i==size(idtmp,1))
                 end_num=idtmp(i);
                 for j=1:end_num-begin_num+1
                    temp_data(k).trials(num).data(j,:)= signal_filter_data.trials.data(idtmp(j),:);
                 end
                 num=num+1;
                 begin_num=idtmp(i+1);
             end
         end
         %-------------------------取出每一个subject的数据总长--------------------%
         for i=1:size(temp_data(k).trials,2)
             length(k)=length(k)+size(temp_data(k).trials(i).data,1);
         end

        len=3; %3秒钟一个平均
        T=length(k)/Fs/len; %样本个数
        PLVM = zeros(channelnum,channelnum,T);
        t=1;
        for w=1:size(temp_data(k).trials,2)
             %signal_filter=temp_data(k).trials(w).data(:,1:22);
            signal_filter=zeros(size(temp_data(k).trials(w).data,1),channelnum);
            signal_filter(:,1)=temp_data(k).trials(w).data(:,8);
            signal_filter(:,2)=temp_data(k).trials(w).data(:,10);
            signal_filter(:,3)=temp_data(k).trials(w).data(:,12);
            signal_filter(:,4)=temp_data(k).trials(w).data(:,15);
            signal_filter(:,5)=temp_data(k).trials(w).data(:,17);
            signal_filter(:,6)=temp_data(k).trials(w).data(:,19);
            signal_filter(:,7)=temp_data(k).trials(w).data(:,20);
            signal_filter(:,8)=temp_data(k).trials(w).data(:,21);
            for a=1:size(signal_filter,1)/Fs/len
                for i=(a-1)*len+1:len*a
                    allCH = signal_filter((i-1)*Fs+1:i*Fs,1:channelnum); %3秒钟数据计算一个PLV值
                    [samples,channels] = size(allCH);
                     for ch1 = 1:channels
                        for ch2 = ch1:channels
                            tmpCh1 = allCH(:,ch1);
                            tmpCh2 = allCH(:,ch2);
                            PLVch(ch1,ch2) = plv_hilbert(tmpCh1,tmpCh2); %plv_hilbert函数计算两通道间的相同步指数
                        end
                     end
                     PLVM(:,:,t) = PLVM(:,:,t) + PLVch(:,:); %3s的PLV值叠加
                end
                t=t+1;
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
    toc
    %-----------------------------对同一个人进行10次测试-----------------------%
    for a=1:10
        if mod(T,2)==0
            Tr = T*0.5; 
        else
            Tr=ceil(T/2);
        end
        Te = T - Tr; 
        %得到训练样本，测试样本和真实标签
        [label_real,trainData,testData ] = getsource( PLVall,K,T,Tr,Te);
        %训练
        [loglik_all,Pix_all,W,Mu,Sigma ] = MAP_train(trainData,K,0.35);
        %记录权重
        all_W{p,a}=W;
        all_loglik{p,a}=loglik_all;
        all_Pix{p,a}=Pix_all;
        %测试
        [LABELS_TEST] = GMM_MAP_test3( testData,Mu,Sigma,K );
        %计算kapa系数
        [kapa_k,kapa]=get_kapa(label_real,LABELS_TEST);
        all_kapa{p,a}=kapa_k;
        kapa_P(p,a)=kapa;
        compare = (label_real == LABELS_TEST);
        MAP_accuracy2(p,a) = sum(compare)/size(label_real,2); %分类正确率,这是同一个人的10次
    end
    %end
end

accuracy=sum(MAP_accuracy2,2)/10;
figure;
plot(accuracy);
title('每个人的平均正确效');
figure;
plot(sum(kapa_P,2)/10);
title('每个人的平均kapa系数');