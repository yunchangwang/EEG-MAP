function my_imagesc( trainData,K)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%**********************************************
% for k=1:K
%     subplot(3,3,k);
%     temp=trainData(:,(k-1)*36+1:k*36);
%     imagesc(temp);
%     str_k=num2str(k);
%     title_str=strcat('第',str_k,'个人的样本');
%     title(title_str);
%     xlabel('样本的个数为36');
%     ylabel('样本的维度为28');
% end

% Data=zeros(7,4);
% for k=1:K
%     temp=trainData(:,(k-1)*36+1);
%     for i=1:4
%         Data(:,i)=temp((i-1)*7+1:i*7);
%     end
%     subplot(3,3,k);
%     imagesc(Data);
%     str_k=num2str(k);
%     title_str=strcat('第',str_k,'个人的样本');
%     title(title_str);
%     xlabel('样本是第一个样本');
%     ylabel('将一个样本变成7*4的矩阵');
% end

Data=zeros(8,8);
for k=1:K
    temp=trainData(:,(k-1)*36+1);
    for i=1:8
        for j=i:8
            if(i==j)
                Data(i,j)=1;
            else
                Data(i,j)=temp(-0.5*i*i+7.5*i-8+j);
                Data(j,i)=temp(-0.5*i*i+7.5*i-8+j);
            end
        end
    end
    subplot(3,3,k);
    imagesc(Data);
    str_k=num2str(k);
    title_str=strcat('第',str_k,'个人的样本');
    title(title_str);
    xlabel('8个通道');
    ylabel('8个通道');
end

%**********************************************
%for k=1:K
%    temp=trainData(:,(k-1)*36+1:k*36);
%    plot(temp);
%end
% w=1:1:28;
% h=0.4:0.01:1;
% h=h*100-50;
% figure
% for k=1:K
%    temp=trainData(:,(k-1)*36+1:k*36);
%    temp=temp*100-50;
%    if(k==1)
%        plot(temp','r.')
%    elseif(k==2)
%        plot(temp','b.')
%    elseif(k==3)
%        plot(temp','g.')
%    elseif(k==4)
%        plot(temp','k.')
%    elseif(k==5)
%        plot(temp','y.')
%    elseif(k==6)
%        plot(temp','r*')
%    elseif(k==7)
%        plot(temp','m.')
%    elseif(k==8)
%        plot(temp','c.')
%    elseif(k==9)
%        plot(temp','g+')
%    end
%    hold on
%    axis([1 28 0.4*100-50 1*100-50]);
%    set(gca,'xtick',w);
%    set(gca,'ytick',h);
% end

%************************************************


end

