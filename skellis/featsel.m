function [idx,F]=featsel(X,lbl,varargin)

% default values
PRCTILE_THRESHOLD=90;

% parse user inputs
for k=1:length(varargin)
	if(strcmpi(varargin{k},'prctile'))
        PRCTILE_THRESHOLD=varargin{k+1};
    end
end

% setup
classlist=sort(unique(lbl),'ascend');
C=numel(unique(lbl)); % number of classes
K=size(X,1); % number of observations/trials (rows of X)
N=size(X,2); % number of features/variables (columns of X)

% counts
nc=zeros(C); % number of elements in each class
for c=1:C
    nc(c)=nnz(lbl==classlist(c));
end

% calculate F-scores
xb=zeros(N,1); % avg val of each feature across all observations
xbc=zeros(N,C); % avg val of each feature per each class
F=zeros(N,1);
for n=1:N
    % calculate averages
    xb(n)=mean(X(:,n));
    for c=1:C
        xbc(n,c)=mean(X(lbl==classlist(c),n));
    end
    
    % calculate F-score
    F1=sum( (xbc(n,:)-xb(n)).^2 );
    F2=0;
    for c=1:C
        F2=F2+(1/(nc(c)-1))*sum( (X(lbl==classlist(c),n)-xbc(n,c)).^2 );
    end
    F(n)=F1/F2;
end

% return feature indices with F-scores in the 90th percentile
idx=find(F>prctile(F,PRCTILE_THRESHOLD));