clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');
use('parfor',8);

% define grids
grids=defgrids;
movingwin=[30 30];
maxlag=20;

% option: NOREF (0) or CAR (1) or WAR (2) or PAIRREF (3)
REF=0;
append='_NOREF';
if(REF==1)
    append='_CAR';
elseif(REF==2)
    append='_WAR';
elseif(REF==3)
    append='_PAIRREF';
end

% loop over grids
for g=5%1:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);
    
    layout=grids(g).layout;
    spacing=grids(g).spacing;

    % load data
    disp('  loading data');
    dt=cell(1,length(grids(g).sources));
    for s=1:3%length(dt)
        disp(['    source ' num2str(s) '/' num2str(length(dt))]);
        load(['d:\data\ecogres\g' num2str(g) 's' num2str(s) '.mat'],'raw','params');
        fs=params.fs;

        % rereference the data
        [raw,layout,spacing]=reref(raw,REF,layout,spacing,grids(g).badchan);

        % reshape by window
        nseg=floor(size(raw,1)/(movingwin(1)*fs));
        dt{s}=reshape(raw(1:movingwin(1)*fs*nseg,:),movingwin(1)*fs,nseg,size(raw,2));
        clear raw;
    end
    raw=cat(2,dt{:}); clear dt;

    % set up channel pairs
    minch=min(layout(layout>0));
    maxch=max(layout(:));
    numch=maxch-minch+1;
    p0=repmat((minch:maxch),numch,1);
    p1=repmat((minch:maxch)',1,numch);
    chanpairs=[p0(:) p1(:)];
    
    % keep only 1-aways
    for k=size(chanpairs,1):-1:1
        [r1,c1]=find(layout==chanpairs(k,1));
        [r2,c2]=find(layout==chanpairs(k,2));
        % disp(['Channels ' num2str(chanpairs(k,1)) ' and ' num2str(chanpairs(k,2)) ': ' num2str(sqrt( (r2-r1)^2 + (c2-c1)^2 ),2)]);
        if( sqrt( (r2-r1)^2 + (c2-c1)^2 )~=1 )
            chanpairs(k,:)=[];
        end
    end

    % CCFs
    disp('  processing CCFs');
    lags=(-maxlag:1/fs:maxlag)';
    ccfs=zeros(length(lags),size(raw,2),size(chanpairs,1));
    raw1=raw(:,:,chanpairs(:,1));
    raw2=raw(:,:,chanpairs(:,2));
    for k=1:size(raw,2)
        disp(['    win ' num2str(k) '/' num2str(size(raw,2))]);
        parfor c=1:size(chanpairs,1)
            ccfs(:,k,c)=xcov(squeeze(raw1(:,k,c)),squeeze(raw2(:,k,c)),maxlag*fs,'coeff');
        end
    end
end
