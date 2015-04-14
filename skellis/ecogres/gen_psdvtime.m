% generate all correlation functions (ACFs and CCFs) and spectral coherence
% functions (SCFs)
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('parfor',4);
use('pkgs/skellis');
use('pkgs/chronux');

% Chronux parameters
chr.Fs=1e3;
chr.tapers=[3 5];
chr.pad=0;
chr.fpass=[0 500];
chr.trialave=0;
movingwin=[4 4];

% specify rereferencing
reref_method='none';
reref_label='none';
reref_append='_UNR';

disp(' ');
disp('GEN_PSDVTIME: Generate power spectral densities for each segment');
disp(['Rereferencing scheme: ' reref_label]);
disp(' ');

% loop over grids
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
        switch(lower(reref_method))
            case 'none'
                raw=reref(raw,reref_method);
            case 'car'
                raw=reref(raw,reref_method,'badchan',grids(g).badchan);
        end
        
        % reshape the data for later processing
        nseg=floor(size(raw,1)/(movingwin(1)*chr.Fs));
        dt{s}=reshape(raw(1:movingwin(1)*chr.Fs*nseg,:),movingwin(1)*chr.Fs,nseg,size(raw,2));
        clear raw;
    end
    raw=cat(2,dt{:}); clear dt;

    % calculate PSD by chronux method
    disp('  processing');
    [tmppsd,f]=mtspectrumc(raw(:,1,1),chr);
    psds=zeros(length(tmppsd),size(raw,2),size(raw,3));
    clear tmppsd;
    parfor c=1:size(raw,3)
        psds(:,:,c)=mtspectrumc(raw(:,:,c),chr);
    end
    clear raw;

    % save results
    disp('  saving');
    save(['d:\results\ecogres\g' num2str(g) 'psdvtime' reref_append],'psds','f','layout','-v7.3');

end