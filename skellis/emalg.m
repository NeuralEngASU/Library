function [z,u,E]=emalg(x)
%
% to test: 
%{
N=50;
tmp1=5+3*randn(N/2,1);
tmp2=-3+1*randn(N/2,1);
ind=randperm(N);
answers=zeros(N,1);
answers(ind(1:N/2))=1;
answers(ind(N/2+1:end))=2;
x=zeros(N,1);
x(ind(1:N/2))=tmp1;
x(ind(N/2+1:end))=tmp2;
plot(x(ind(1:N/2)),0,'r.'); hold on
plot(x(ind(N/2+1:end)),0,'b.');
%}

% dimension of the features (rows) in x
d=size(x,2);
N=size(x,1);

% init K
K=2;

% init assignments
z=randi(K,size(x,1),1);

% initial guesses on means of K distributions
u=zeros(K,d);
for k=1:K
    u(k,:)=mean(x(z==k,:),1);
end

% initial guesses on covariances of K distributions
E=zeros(K,d,d);
for k=1:K
    tmpx=x(z==k,:);
    E(k,:,:)=(tmpx-repmat(u(k,:),size(tmpx,1),1))'*(tmpx-repmat(u(k,:),size(tmpx,1),1))/(size(tmpx,1)-1);
end

% set phi (mixing ratios) values equal (multinomial distribution)
phi=(1/K)*ones(K,1);

% track the probability excess
excess=N;
err=N;

while(err>1e-6)
    % e-step
    % estimate probability p(n,k) that sample x_n came from the kth Guassian
    w=zeros(size(x,1),K);
    for n=1:N
        
        % pre-compute posterior probability P(x_n|z_n==k)P(z_n==j) for this n and all k
        pp=zeros(K,1);
        for k=1:K
            pp(k)=(((2*pi)^(-d/2))*...
                (det(E(k,:,:))^(-1/2))*...
                exp((-1/2)*(x(n,:)-u(k,:))*(E(k,:,:)^(-1))*(x(n,:)-u(k,:))'))*...
                phi(k);
        end
        
        % now compute probabilities P(z_n==k|x_n,phi,u,E)
        for k=1:K
            w(n,k)=pp(k)/sum(pp);
        end
    end
    
    % m-step
    % recompute parameters
    phi=(1/N)*sum(w,1);
    den=sum(w,1);
    for k=1:K
        u(k,:)=sum(repmat(w(:,k),1,size(x,2)).*x)/den(k);
    end
    for k=1:K
        E(k,:,:)=zeros(d);
        for n=1:N
            E(k,:,:)=E(k,:,:)+w(n,k)*(x(n,:)-u(k,:))'*(x(n,:)-u(k,:));
        end
        E(k,:,:)=E(k,:,:)/den(k);
    end
    
    [~,z]=max(w,[],2);
    err=abs(excess-sum(min(abs(1-w),[],2).^2));
    excess=sum(min(abs(1-w),[],2).^2);
end