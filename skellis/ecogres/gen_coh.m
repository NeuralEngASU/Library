% compute coherence
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('parfor',4);
use('pkgs/chronux');
use('pkgs/skellis');

% Chronux parameters
chr.Fs=1e3;
chr.tapers=[2 3];
chr.pad=0;
chr.fpass=[0 400];
chr.trialave=1;
chr.err = [0 0.05];

% data segmenting
movingwin=[2 2];

% specify rereferencing
ref='unr';

disp(' ');
disp('GEN_COH: Generate coherence functions');
disp(['Rereferencing scheme: ' ref]);
disp(' ');

% load data
grids=defgrids;
for g=5%1:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);
    layout=grids(g).layout;
    spacing=grids(g).spacing;

    % load data
    disp('  loading data');
    [raw,params]=get_segdata('d:\Spencer\ecogres',grids(g),g,movingwin,ref);

    % set up channel pairs
    chanpairs=nchoosek(sort(unique(layout(~isnan(layout)&layout>0)),'ascend'),2);

    % run the first pair to get dimensions
    disp('  checking first channel pair');
    % % [tmpcoh,tmpphi,tmpcx,tmpS1,tmpS2,tmpf,tmpconfc,tmpphistd,tmpcerr]=...
    % %     coherencyc(raw(:,:,chanpairs(1,1)),raw(:,:,chanpairs(1,2)),chr);
    [tmpcoh,tmpphi,tmpcx,tmpS1,tmpS2,tmpf]=...
        coherencyc(raw(:,:,chanpairs(1,1)),raw(:,:,chanpairs(1,2)),chr);

    % initialize variables
    mcoh=zeros(length(tmpcoh),size(chanpairs,1));
    mcoh(:,1)=tmpcoh;
    mphi=zeros(length(tmpphi),size(chanpairs,1));
    mphi(:,1)=tmpphi;
    mcx=zeros(length(tmpcx),size(chanpairs,1));
    mcx(:,1)=tmpcx;
    % % mconfc=zeros(1,size(chanpairs,1));
    % % mconfc(1)=tmpconfc;
    % % mphistd=zeros(length(tmpphistd),size(chanpairs,1));
    % % mphistd(:,1)=tmpphistd;
    % % mcerr=zeros(2,length(tmpcerr),size(chanpairs,1));
    % % mcerr(:,:,1)=tmpcerr;
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
        tmpmcoh=zeros(length(tmpcoh),length(cpidx));
        tmpmphi=zeros(length(tmpphi),length(cpidx));
        tmpmcx=zeros(length(tmpcx),length(cpidx));
        % % tmpmconfc=zeros(1,length(cpidx));
        % % tmpmphistd=zeros(length(tmpphistd),length(cpidx));
        % % tmpmcerr=zeros(2,length(tmpcerr),length(cpidx));

        % process in parallel
        % % parfor k=1:length(cpidx)
        % %     [tmpmcoh(:,k),tmpmphi(:,k),tmpmcx(:,k),~,~,~,...
        % %         tmpmconfc(:,k),tmpmphistd(:,k),tmpmcerr(:,:,k)]=...
        % %         coherencyc(raw1(:,:,k),raw2(:,:,k),chr);
        % % end
        parfor k=1:length(cpidx)
            [tmpmcoh(:,k),tmpmphi(:,k),tmpmcx(:,k)]=...
                coherencyc(raw1(:,:,k),raw2(:,:,k),chr);
        end

        % save results
        mcoh(:,cpidx)=tmpmcoh;
        mphi(:,cpidx)=tmpmphi;
        mcx(:,cpidx)=tmpmcx;
        % % mconfc(cpidx)=tmpconfc;
        % % mphistd(:,cpidx)=tmpmphistd;
        % % mcerr(:,:,cpidx)=tmpmcerr;
    end

    % save results
    save(['d:\Spencer\ecogres\g' num2str(g) 'mcoh_' upper(ref)],'mcoh','mphi','f','chanpairs','spacing','layout');
    % % save(['d:\Spencer\ecogres\g' num2str(g) 'mcoherr_' upper(ref)],'mconfc','mphistd','mcerr','chanpairs','f','spacing','layout');
    save(['d:\Spencer\ecogres\g' num2str(g) 'mcx_' upper(ref)],'mcx','f','chanpairs','spacing','layout');
end