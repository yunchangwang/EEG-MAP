function [label_real,trainData,testData ] = getsource2( PLVall,K,T,Tr,Te)
    %获得训练数据
    nk = 0;
    for i = 1:K
        temp = randperm(T);
        %获取训练数据
        for j = 1:Tr
            b = PLVall(:,(i-1)*T+temp(j));
            nk = nk + 1;
            trainData(:,nk) = b;
        end
    end
    %得到测试数据和真实标签
    
end

