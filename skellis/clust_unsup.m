function [clusters,lbl]=clust_unsup(feats)
% [clusters,members]=clust_unsup(feats)
% Performs an unsupervised classification on 2-dimensional feature matrix
% returns the cluster centers and a vector of cluster assignments.

%
% STEP 1: Reduction
% Find the centroid of the cluster of points within 1.5 std dev's of
% each point.  Then, find unique centroids.
%

% find clusters around each point
clusters=zeros(size(feats));
for k=1:size(feats,1)
    dist=sqrt(sum((feats-repmat(feats(k,:),[size(feats,1) 1])).^2,2));
    clusters(k,:)=mean(feats(dist<1.0,:),1);
end
[clusters,i,j]=unique(clusters,'rows');

% find out how many votes for each of the clusters; discard any with
% too few votes
numvotes=zeros(size(clusters,1),1);
for k=1:size(clusters,1)
    numvotes(k)=nnz(j==k);
end
clusters(numvotes<=ceil(0.01*size(feats,1)),:)=[];

%
% STEP 2: Combination
% As long as the minimum separation is below some threshold, compare
% the two closest cluster and delete the one that has the worst
% within-class vs between-class variance
%

% combine clusters until the minimum between-class separation is:
minsep=1.0; % in standard deviations

% find current minimum separation
combs=nchoosek(1:size(clusters,1),2);
bcdist=zeros(size(clusters,1),1);
for k=1:size(combs,1)
    bcdist(k)=sqrt(sum((clusters(combs(k,1),:)-clusters(combs(k,2),:)).^2,2));
end
[currminsep,minidx]=min(bcdist);
currneighbors=combs(minidx,:);

% make cluster assignments (allowing overlap or non-assignment)
wcdist=cell(size(clusters,1),1);
wcmemb=cell(size(clusters,1),1);
for k=1:size(clusters,1)
    wcdist{k}=sqrt(sum((repmat(clusters(k,:),[size(feats,1) 1])-feats).^2,2));
    wcmemb{k}=find(wcdist{k}<1.0);
end

% evaluate and combine until currminsep>=minsep
while(currminsep<minsep)
    
    % calculate within-class std dev
    wcvar=zeros(size(clusters,1),1);
    for k=1:size(clusters,1)
        wcvar(k)=std(wcdist{k}(wcmemb{k}))^2;
    end
    
    % calculate between-class std dev when keeping neigbhor 1
    comb1idx=setdiff(1:size(combs,1),find(combs(:,1)==currneighbors(1)|combs(:,2)==currneighbors(1)));
    bc1var=std(bcdist(comb1idx))^2;
    comb2idx=setdiff(1:size(combs,1),find(combs(:,1)==currneighbors(2)|combs(:,2)==currneighbors(2)));
    bc2var=std(bcdist(comb2idx))^2;
    
    % calculate the ratio of wc/bc variance for each choice
    m1=wcvar(currneighbors(1))/bc1var;
    m2=wcvar(currneighbors(2))/bc2var;
    
    % erase the cluster with the higher ratio
    if(m1>m2)
        clusters(currneighbors(1),:)=[];
    else
        clusters(currneighbors(2),:)=[];
    end
    
    % update current minimum separation
    combs=nchoosek(1:size(clusters,1),2);
    bcdist=zeros(size(clusters,1),1);
    for k=1:size(combs,1)
        bcdist(k)=sqrt(sum((clusters(combs(k,1),:)-clusters(combs(k,2),:)).^2,2));
    end
    [currminsep,minidx]=min(bcdist);
    currneighbors=combs(minidx,:);
    
    % update cluster assignments (allowing overlap or non-assignment)
    wcdist=cell(size(clusters,1),1);
    wcmemb=cell(size(clusters,1),1);
    for k=1:size(clusters,1)
        wcdist{k}=sqrt(sum((repmat(clusters(k,:),[size(feats,1) 1])-feats).^2,2));
        wcmemb{k}=find(wcdist{k}<1.0);
    end
end

%
% Step 3: Assignment
% Make preliminary assignments of each point to its nearest cluster
%
lbl=zeros(size(feats,1),1);
for k=1:size(feats,1)
    dist=sqrt(sum((repmat(feats(k,:),[size(clusters,1) 1])-clusters).^2,2));
    [val,minidx]=min(dist);
    lbl(k)=minidx;
end

%
% Step 4: Weeding
% Remove outliers in each cluster
%
for k=1:size(clusters,1)
    midx=find(lbl==k);
    dist=sqrt(sum((repmat(clusters(k,:),[length(midx) 1])-feats(midx,:)).^2,2));
    oidx=outliers(dist);
    oidx(dist(oidx)<mean(dist))=[]; % keep only outliers that are too far
    lbl( midx(oidx) )=-1; % remove label from remaining outliers
end