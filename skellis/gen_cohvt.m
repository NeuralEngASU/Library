% compute coherence
clear all;
close all;
clc;

% set up environment
% use('cleanpath');
% use('parfor',8);
% use('pkgs/chronux');
% use('pkgs/skellis');

% Chronux parameters
params.Fs=1e3;
params.tapers=[3 5];
params.pad=0;
params.fpass=[0 100];
params.trialave=0;
movingwin=[4 4];

% specify rereferencing
ref='unr';

disp(' ');
disp('GEN_COHVT: Generate coherence over time');
disp(['Rereferencing scheme: ' ref]);
disp(' ');

% load data
grids=defgrids;
for g=1%:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);
    layout=grids(g).layout;
    spacing=grids(g).spacing;

    % load data
    disp('  loading data');
    dt=cell(1,length(grids(g).sources));
    for s=1:length(dt)
        disp(['    source ' num2str(s) '/' num2str(length(dt))]);
        load(['D:\Kevin\SpencerPaper\201203\g' num2str(g) 's' num2str(s) '.mat'],'raw');

        % rereference the data
        switch(lower(ref))
            case 'unr'
                raw=reref(raw,ref);
            case 'car'
                raw=reref(raw,ref,'badchan',grids(g).badchan);
        end

        % reshape the data for later processing
        nseg=floor(size(raw,1)/(movingwin(1)*params.Fs));
        dt{s}=reshape(raw(1:(movingwin(1)*params.Fs)*nseg,:),(movingwin(1)*params.Fs),nseg,size(raw,2));
        clear raw;
    end
    raw=cat(2,dt{:}); clear dt;

    % set up channel pairs
    chanpairs=nchoosek(sort(unique(layout(layout>0)),'ascend'),2);

    % run the first pair to get dimensions
    [tmpcoh,tmpphi,tmpcx,tmpS1,tmpS2,tmpf]=...
        coherencyc(raw(:,:,chanpairs(1,1)),raw(:,:,chanpairs(1,2)),params);

    % initialize variables
    coh=zeros(size(tmpcoh,1),size(raw,2),size(chanpairs,1));
    coh(:,:,1)=tmpcoh;
    f=tmpf;

    % now run the rest of the pairs
    disp('  processing');
    nw=2*matlabpool('size');
    for cp=2:nw:size(chanpairs,1)

        cpidx=cp:min(size(chanpairs,1),cp+nw-1);

        % pull out just the data for this iteration
        disp(['    chanpair ' num2str(cp) '/' num2str(size(chanpairs,1))]);
        raw1=raw(:,:,chanpairs(cpidx,1));
        raw2=raw(:,:,chanpairs(cpidx,2));
        tmpcoh=zeros(size(tmpcoh,1),size(raw,2),length(cpidx));

        % process in parallel
        parfor k=1:length(cpidx)
            [tmpcoh(:,:,k)]=coherencyc(raw1(:,:,k),raw2(:,:,k),params);
        end

        % save results
        coh(:,:,cpidx)=tmpcoh;
    end

    % save results
    save(['D:\Kevin\SpencerPaper\201203\g' num2str(g) 'cohvt_' upper(ref)],'coh','f','chanpairs','spacing','layout','-v7.3');
end