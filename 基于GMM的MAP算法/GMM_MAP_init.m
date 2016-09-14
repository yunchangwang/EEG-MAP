function [Priors, Mu, Sigma] = GMM_MAP_init(Data, K)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%   Data测试数据
%   K被试人数
    [D,T]=size(Data);
    T=T/K;
    Tr=1;
    nk = 0;
    %随机选择其中的Tr条作为聚类
    for i=1:K
        temp = randperm(T);
        for j = 1:Tr
            b = Data(:,(i-1)*T+temp(j));
            nk = nk + 1;
            test(:,nk) = b;
        end
    end
    Priors = zeros(K, K); %k类GMM所占权重（influence factor）  
    Sigma=zeros(D,D,K);
    Mu=test;
    for i=1:K
        Priors(i,:)=ones(1,K)*0.25;
        for j=1:D       
            Sigma(j,j,i)=0.5;
        end
    end
end

