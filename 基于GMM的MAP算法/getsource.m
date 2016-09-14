function [label_real,trainData,testData ] = getsource( PLVall,K,T,Tr,Te)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%   K被测试的人数
%   S每个人样本的个数
%   PLVall预处理之后的总数据
    nk = 0;
    nd = 0;
    for i = 1:K
        temp = randperm(T);
        %获取训练数据
        for j = 1:Tr
            b = PLVall(:,(i-1)*T+temp(j));
            nk = nk + 1;
            trainData(:,nk) = b;
        end
    end
    %获取测试数据
    temp = randperm(Te*K);
    for i=1:Te*K
        j=temp(i);
        if j>=1&&j<=Te
            b=PLVall(:,Tr+j);
            label_real(i)=1;
        elseif j>=Te+1&&j<=Te*2
            b=PLVall(:,Tr*2+j);
            label_real(i)=2;
        elseif j>=2*Te+1&&j<=3*Te
            b=PLVall(:,Tr*3+j);
            label_real(i)=3;
        else
            b=PLVall(:,Tr*4+j);
            label_real(i)=4;
        end
        nd=nd+1;
        testData(:,nd)=b;
    end
end

