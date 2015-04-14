% generate all correlation functions (ACFs and CCFs) and spectral coherence
% functions (SCFs)
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');
use('parfor',4);

% define grids
grids=defgrids;
movingwin=[2 2];
maxlag=2;

% specify rereferencing
ref='unr';

disp(' ');
disp('GEN_CCF: Generate cross-correlation functions');
disp(['Rereferencing scheme: ' ref]);
disp(' ');

% loop over grids
for g=1:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);
    layout=grids(g).layout;
    spacing=grids(g).spacing;
    
    % get sampling rate
    load(['d:\Spencer\ecogres\g' num2str(g) 's1.mat'],'params');
    fs=params.fs;

    % set up channel pairs
    minch=min(layout(layout>0));
    maxch=max(layout(:));
    numch=maxch-minch+1;
    p0=repmat((minch:maxch),numch,1);
    p1=repmat((minch:maxch)',1,numch);
    chanpairs=[p0(:) p1(:)];
    lags=(-maxlag:1/params.fs:maxlag)';

    % load data and compute ccf's
    mccf=zeros(length(lags),numch^2);
    N=0;
    for s=1:length(grids(g).sources)
        disp(['  loading source ' num2str(s) '/' num2str(length(grids(g).sources))]);
        load(['d:\Spencer\ecogres\g' num2str(g) 's' num2str(s) '.mat'],'raw','params');

        % rereference the data
        switch(lower(ref))
            case 'unr'
                raw=reref(raw,ref);
            case 'car'
                raw=reref(raw,ref,'badchan',grids(g).badchan);
        end

        % reshape by window
        nseg=floor(size(raw,1)/(movingwin(1)*fs));
        raw=reshape(raw(1:movingwin(1)*fs*nseg,:),movingwin(1)*fs,nseg,size(raw,2));
        raw=permute(raw,[1 3 2]);

        % calculate ccf's
        disp('    processing');
        N=N+size(raw,3);
        for k=1:size(raw,3)
            if(~rem(k,10))
                disp(['      ' num2str(k) '/' num2str(size(raw,3))]);
            end
            raw1=squeeze(raw(:,chanpairs(:,1),k));
            raw2=squeeze(raw(:,chanpairs(:,2),k));
            parfor m=1:size(chanpairs,1)
                mccf(:,m)=mccf(:,m)+xcov(raw1(:,m),raw2(:,m),maxlag*fs,'coeff');
            end
        end

    end
    mccf=mccf/N;

    % save results
    save(['d:\Spencer\ecogres\g' num2str(g) 'mccf_' upper(ref) '.mat'],...
        'mccf','lags','chanpairs','layout','spacing','-v7.3');
end




% % % loop over windows
% % disp('  processing');
% % lags=(-maxlag:1/fs:maxlag)';
% % tmpsum=zeros(length(lags),numch^2); % summing things up as we go
% % N=0; % number of segments going into the eventual average
% % for k=1:size(raw,2)
% %     disp(['    win ' num2str(k) '/' num2str(size(raw,2))]);
% %     tmpsum=tmpsum+xcov(squeeze(raw(:,k,:)),maxlag*fs,'coeff');
% %     N=N+1;
% % end
% % mccf=tmpsum/N;