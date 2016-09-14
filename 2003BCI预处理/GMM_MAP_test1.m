function [LABELS_TEST]  = GMM_MAP_test1(X,Mu,Sigma,K)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% 同一个人测试10次
%1.将经过处理的测试数据导入,测试数据是混乱的
%2.将每条数据带入4中模型中计算高斯密度
%3.选择最大的那个作为该数据相应的标签
%4.导出标签与正确标签进行比较
    LABELS_TEST=zeros(1,size(X,2));
    for i=1:size(X,2)
        for k=1:K
            prog(k) = Gauss_pdf2(X(:,i),Mu(:,k),Sigma(:,:,k));
        end
        maxnum=max(prog);
        if(size(find(prog==maxnum),2)>1)
            LABELS_TEST(i)=0;
            continue;
        end
        LABELS_TEST(i)=find(prog==maxnum);
    end
end

