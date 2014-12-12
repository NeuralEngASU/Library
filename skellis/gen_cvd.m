% generate all correlation functions (ACFs and CCFs) and spectral coherence
% functions (SCFs)
clear all;
close all;
clc;

% set up environment
% use('cleanpath');
% use('pkgs/skellis');
% use('parfor',4);

% define grids
grids=defgrids;
movingwin=[2 2];
maxlag=2;

% specify rereferencing
ref='unr';

disp(' ');
disp('GEN_CVD: Zero-lag cross-correlation at each separation distance');
disp(['Rereferencing scheme: ' ref]);
disp(' ');

% loop over grids
for g=1:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);
    layout=grids(g).layout;
    spacing=grids(g).spacing;

    % get sampling rate
    load(['D:\Kevin\SpencerPaper\201203\g' num2str(g) 's1.mat'],'params');
    fs=params.fs;

    % set up channel pairs
    chanlist=sort(layout(layout>0&~isnan(layout)),'ascend');
    numch=length(chanlist);
    p0=repmat(chanlist',numch,1);
    p1=repmat(chanlist,1,numch);
    chanpairs=[p0(:) p1(:)];

    % load data
    disp('  loading data');
    [raw,params]=get_segdata('D:\Kevin\SpencerPaper\201203\',grids(g),g,movingwin,ref);

    % calculate zero-lag correlation coefficient
    disp('    processing');
    rho=zeros(size(raw,2),size(chanpairs,1));
    parfor k=1:size(raw,2)
        tmprho=corrcoef(squeeze(raw(:,k,chanlist)));
        rho(k,:)=tmprho(:);
    end

    % average at each separation: for boxplot of distribution OVER TIME
    [avg.rho,avg.seps,avg.pairseps,avg.stderr,avg.population]=...
        avgpersep(rho,chanpairs,layout,spacing,grids(g).badchan);

    % average at each separation, for each direction
    [dir.rho,dir.seps,dir.angles,dir.pairseps,dir.pairangles,dir.stderr]=...
        avgpersepdir(rho,chanpairs,grids(g).layout,grids(g).spacing,grids(g).badchan);

    disp('Hello')
    
    % save results
    save(['D:\Kevin\SpencerPaper\201203\g' num2str(g) 'cvd_' upper(ref) '.mat'],...
        'rho','chanpairs','avg','dir','-v7.3');
end