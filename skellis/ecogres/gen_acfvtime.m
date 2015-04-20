% generate all correlation functions (ACFs and CCFs) and spectral coherence
% functions (SCFs)
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');
use('parfor',8);

% define grids
grids=defgrids;
movingwin=[2 2];
maxlag=2;

% specify rereferencing
ref='unr';

disp(' ');
disp('GEN_ACFVTIME: Generate autocorrelation functions for each segment');
disp(['Rereferencing scheme: ' ref]);
disp(' ');

% loop over grids
for g=8:10%1:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);

    layout=grids(g).layout;
    spacing=grids(g).spacing;

    % load data
    disp('  loading data');
    [raw,params]=get_segdata('d:\matlab\ecogres\',grids(g),g,movingwin,ref);
    fs=params.fs;

    % ACFs only
    disp('  processing ACFs only');
    lags=(-maxlag:1/fs:maxlag)';
    acfs=zeros(length(lags),size(raw,2),size(raw,3));
    for k=1:size(raw,2)
        disp(['    win ' num2str(k) '/' num2str(size(raw,2))]);
        parfor c=1:size(raw,3)
            acfs(:,k,c)=xcov(squeeze(raw(:,k,c)),maxlag*fs,'coeff');
        end
    end
    clear raw;

    % save results
    disp('  saving');
    save(['d:\matlab\ecogres\g' num2str(g) 'acfvtime_' upper(ref)],'acfs','lags','layout','-v7.3');

end