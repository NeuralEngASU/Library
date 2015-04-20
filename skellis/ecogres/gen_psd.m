% compute power spectral densities
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('parfor',2);
use('pkgs/skellis');
use('pkgs/chronux');

% Chronux parameters
params.Fs=1e3;
params.tapers=[3 5];
params.pad=0;
params.fpass=[0 400];
params.trialave=1;
movingwin=[4 4];

% specify rereferencing
ref='unr';

disp(' ');
disp('GEN_PSD: Generate power spectral densities');
disp(['Rereferencing scheme: ' ref]);
disp(' ');

% load data
grids=defgrids;
for g=1:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);
    layout=grids(g).layout;
    spacing=grids(g).spacing;

    % load data
    disp('  loading data');
    dt=cell(1,length(grids(g).sources));
    for s=1:length(dt)
        disp(['    source ' num2str(s) '/' num2str(length(dt))]);
        load(['d:\data\ecogres\g' num2str(g) 's' num2str(s) '.mat'],'raw');

        % rereference the data
        switch(lower(ref))
            case 'none'
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

    % calculate PSD by chronux method
    disp('  processing');
    [tmppsd,f]=mtspectrumc(raw(:,:,1),params);
    mpsd=zeros(length(tmppsd),size(raw,3));
    mpsd(:,1)=tmppsd; clear tmppsd;
    parfor k=2:size(raw,3)
        disp(['    chan ' num2str(k) '/' num2str(size(raw,3))]);
        mpsd(:,k)=mtspectrumc(raw(:,:,k),params);
    end

    % save results
    save(['d:\results\ecogres\g' num2str(g) 'mpsd_' upper(ref)],'mpsd','f','spacing','layout');
end