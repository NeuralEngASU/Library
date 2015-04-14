% generate figures of power spectral densities
clear all;
close all;
clc;

% set up environment
% use('cleanpath');
use('pkgs/skellis');

% define grids
grids=defgrids;
srcdir = '\\CHOPIN\Documents\Spencer\d_matlab\ecogres';%'E:\data\ecogres';
tgtdir = 'C:\Users\Spencer\Documents\MATLAB\2015jneurophys';

% specify rereferencing
reref_method='none';
reref_label='none';
reref_append='_UNR';

% frequency bands not to display
fbins=[ 57  63;
       117 123;
       177 183;
       237 243;
       297 303;
       357 363;
       417 423;
       477 483;];

% loop over grids
for g=1:length(grids)
    % load data
    d1=load(fullfile(srcdir,sprintf('g%dmpsd%s.mat',g,reref_append)),'mpsd','f');
    f=d1.f;

    % pull out psd's, convert to dB 
    mpsd=10*log10(d1.mpsd);
    clear d1;

    % remove bad channels
    mpsd=mpsd(:,setdiff(1:size(mpsd,2),grids(g).badchan));

    % nan's in for noisy frequencies
    for b=1:size(fbins,1)
        mpsd( f>=fbins(b,1)&f<=fbins(b,2),: )=nan;
    end

    % open figure
    figure('Name',['ACF: ' grids(g).label],...
        'PaperPositionMode','auto','Position',[243 208 1440 782]);
    hold all;

    % plot
    chan_h=plot(f,mpsd,'Color',[0.7 0.7 0.7],'LineWidth',1);
    median_h=plot(f,median(mpsd,2),'Color',[0 0 0],'LineWidth',4);

    % set up groups for legend
    chan_grp=hggroup;
    median_grp=hggroup;
    set(chan_h,'Parent',chan_grp);
    set(median_h,'Parent',median_grp);
    set(get(get(chan_grp,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
    set(get(get(median_grp,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
    legend({...
        ['All channels (' reref_method ')'],...
        ['Median (' reref_method ')']});

    % annotate
    title(grids(g).label);
    xlabel('frequency (Hz)');
    ylabel('power (dB)');
    grid on;
    xlim([0 400]);
    ylim([-40 40]);

    % save figure
    saveas(gcf,fullfile(tgtdir,sprintf('MPSD_%s.fig',grids(g).filename)));
    saveas(gcf,fullfile(tgtdir,sprintf('MPSD_%s.eps',grids(g).filename)),'epsc2');
    saveas(gcf,fullfile(tgtdir,sprintf('MPSD_%s.png',grids(g).filename)));

    % % screendim=get(0,'screensize');
    % % figure('Position',[1 41 screendim(3) screendim(4)-110]);
    % % gridplot2(f,mpsd,grids(g).layout,'axisargs',struct('ylim',[-40 40],'xlim',[0 400]));
end