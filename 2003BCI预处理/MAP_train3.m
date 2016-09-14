function [loglik_all,Pix_all,W,Mu,Sigma ] = MAP_train3( X,K,a)
    [~,T]=size(X);
    T=T/K;
    threshold = 0.001;%迭代的终止信号
    [W,Mu,Sigma]=EM_init_kmeans1(X,K);%初始化W,Mu,Sigma
    N1=zeros(T,K);
    N2=zeros(T,K);
    loglik=zeros(1,K);
    for k=1:K
        loglik_old = -realmax;
        i=1;
        while(true)
            for k1=1:K
                 N1(:,k1)=Gauss_pdf(X(:,(k-1)*T+1:k*T),Mu(:,k1),Sigma(:,:,k1));
            end
            Pix_tem=repmat(W(k,:),T,1).*N1;
            %Pix_tem=repmat(W,T,1).*N1;
            Pix=Pix_tem./repmat(sum(Pix_tem,2),1,K);
            Pix_all{k,i}=Pix;
            %i=i+1;
            E=sum(Pix,1);
            %更新W
            W(k,:)=E./sum(E);
            %这里只更新Mu
            Mu(:,k)=Mu(:,k)*a+(1-a)*X(:,(k-1)*T+1:k*T)*Pix(:,k) / E(k);%这里a属于[0，1]
            for k2=1:K
                 N2(:,k2) = Gauss_pdf(X(:,(k-1)*T+1:k*T), Mu(:,k2), Sigma(:,:,k2));
            end
            %Compute the log likelihood
            F = repmat(W(k,:),T,1).*N2;
            %F = repmat(W,T,1).*N2;
            for t=1:T
                if(F(t)<realmin)
                   F(t) = realmin;
                end
            end
            loglik(k)=sum(log(sum(F,2)));
            %记录最大后验概率的变化
            loglik_all{k,i}=loglik(k);
            if abs(loglik(k)-loglik_old)<threshold
                break;
            else
                loglik_old=loglik(k);
            end
            i=i+1;
        end
    end
end

