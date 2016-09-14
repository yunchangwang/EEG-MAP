function [kapa_k,kapa]=get_kapa(label_real,LABELS_TEST)
%UNTITLED 此处显示有关此函数的摘要
%   每次计算kapa系数
    kapa_k=zeros(4+1,4+1);
    diag_sum=0;
    for i=1:size(label_real,2)
        kapa_k(label_real(i),LABELS_TEST(i))=kapa_k(label_real(i),LABELS_TEST(i))+1;
    end
    for i=1:4
        kapa_k(5,i)=sum(kapa_k(:,i));
        kapa_k(i,5)=sum(kapa_k(i,:));
        diag_sum=diag_sum+kapa_k(i,i);
        kapa_k(5,5)=kapa_k(5,5)+ kapa_k(5,i);
    end
    P0=diag_sum/kapa_k(5,5);
    temp=0;
    for i=1:4
        temp=temp+kapa_k(5,i)*kapa_k(i,5);
    end
    Pe=temp/kapa_k(5,5)^2;
    kapa=(P0-Pe)/(1-Pe);
end

