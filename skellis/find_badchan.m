% find bad channels
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');

% define grids
grids=defgrids;
for g=6%1:length(grids)
    
    % specify rereferencing
    reref_method='none';
    reref_label='none';
    reref_append='_UNR';
    
    % load data
    d1=load(['d:/results/ecogres/g' num2str(g) 'mccf' reref_append '.mat'],'mccf','lags','chanpairs');
    lags=d1.lags;
    
    % load data
    d2=load(['d:/results/ecogres/g' num2str(g) 'mpsd' reref_append '.mat'],'mpsd','f');
    f=d2.f;
    
    % find the ACFs
    idx=zeros(1,length(unique(d1.chanpairs(:))));
    for k=1:length(unique(d1.chanpairs(:)))
        idx(k)=find(d1.chanpairs(:,1)==k&d1.chanpairs(:,2)==k);
    end
    macf1=d1.mccf(:,idx);
    clear d1;
    
    % pull out psd's, convert to dB
    mpsd=10*log10(d2.mpsd);
    clear d2;
    
    % SSE (vs median) for ACFs
    cnf1=zeros(1,length(idx));
    parfor k=1:length(idx)
        cnf1(k)=sum((nanmedian(macf1,2)-macf1(:,k)).^2);
    end
    
    % SSE (vs median) for PSDs
    cnf2=zeros(1,size(mpsd,2));
    parfor k=1:size(mpsd,2)
        cnf2(k)=sum((nanmedian(mpsd,2)-mpsd(:,k)).^2);
    end

    % plot
    figure
    subplot(2,2,1:2);
    bar([cnf1/nanstd(cnf1(~isinf(cnf1))); cnf2/nanstd(cnf2(~isinf(cnf2)))]')
    title(['Grid ' num2str(g) ': ' grids(g).label]);
    legend({'ACF','PSD'});
    xlim([0 length(cnf2)+1]);
    subplot(223);
    bar(cnf1);
    title('ACF');
    ylim([0 50]);
    xlim([0 length(cnf2)+1]);
    subplot(224);
    bar(cnf2);
    title('PSD');
    ylim([0 50000]);
    xlim([0 length(cnf2)+1]);

    % find badchannels
    badchan=unique(cat(2,find(cnf1>3*std(cnf1)),find(cnf2>3*std(cnf2))));
    
    % let user know the results
    disp(['Grid ' num2str(g) ' bad electrodes: ' num2str(badchan)]);
end