% generate figures of zero-lag cross-correlation vs. separation distance
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');

% define grids
grids=defgrids;

% specify rereferencing
reref_method='unr';

% loop over grids
d=cell(size(grids));
for g=1:length(grids)
    d{g}=load(['d:/matlab/ecogres/g' num2str(g) 'cvd_' upper(reref_method) '.mat']);

    % pull out 0, 45, 90, and 135 degree separation vs. distance
    idx(1)=1;
    [dummy,idx(2)]=min(abs(rad2deg(d{g}.dir.angles)-45));
    [dummy,idx(3)]=min(abs(rad2deg(d{g}.dir.angles)-90));
    [dummy,idx(4)]=min(abs(rad2deg(d{g}.dir.angles)-135));
    figure
    hold all;
    clr={'r','b','g','m'};
    for k=1:length(idx)
        ok=~isnan(d{g}.dir.rho(1,:,idx(k)));
        plot(d{g}.dir.seps(ok),nanmean(d{g}.dir.rho(:,ok,idx(k)),1),...
            'color',clr{k},'linewidth',2);
    end
    legend({'0 \circ','45 \circ','90 \circ','135 \circ'});
    title([grids(g).shortname ' (' reref_method ')']);
    grid on;
    ylim([0 1]);
    set(gca,'TickDir','out')

    % save
    saveas(gcf,['d:/matlab/ecogres/figures/MCVDVD_' grids(g).filename '_' upper(reref_method) '.fig']);
    saveas(gcf,['d:/matlab/ecogres/figures/MCVDVD_' grids(g).filename '_' upper(reref_method) '.png']);
    saveas(gcf,['d:/matlab/ecogres/figures/MCVDVD_' grids(g).filename '_' upper(reref_method) '.eps'],'epsc2');
end