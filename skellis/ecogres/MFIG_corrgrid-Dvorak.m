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
ref='unr';

% loop over grids
d=cell(size(grids));
for g=1:length(grids)
    load(['d:/Spencer/ecogres/g' num2str(g) 's1.mat']);

    % calculate the correlation coefficients
    [tmprr,p]=corrcoef(raw);

    % place nans in badchan positions throughout tmprr
    for k=1:length(grids(g).badchan)
        tmprr(:,grids(g).badchan(k)) = nan;
        tmprr(grids(g).badchan(k),:) = nan;
    end

    % all this to put the results in their correct positions, i.e.,
    % according to their actual channel number as opposed to their linear
    % ordering (example: what if channel 16 is not present in the layout?)
    max_channel_number=max(grids(g).layout(:)); % maximum channel number in the channel pairs
    %channels=sort(grids(g).layout(~isnan(grids(g).layout)&grids(g).layout>0),'ascend'); % minimum valid channel, just as one to use
    %channels(grids(g).badchan)=nan;
    channels=nan(size(tmprr,1),1);
    for k=1:length(channels)
        if(~isempty(find(grids(g).layout==k, 1)) && isempty(find(grids(g).badchan==k, 1)))
            channels(k)=k;
        end
    end
    
    % put the results into the right spot
    r=nan(size(grids(g).layout,1),size(grids(g).layout,2),max_channel_number);
    for k=1:size(tmprr,1)
        % find the correct index for this channel
        idx=find(channels==k);
        if(~isempty(idx))
            r(:,:,idx)=vec2layout(abs(tmprr(:,k)),grids(g).layout);
        end
    end

    fig=figure('PaperPositionMode','auto','Position',[50 50 size(grids(g).layout,1)*80 size(grids(g).layout,2)*80]);
    mymap=colormap('jet');
    %mymap=[0 0 0; mymap;];
    colormap(mymap);
    gridimagesc(1:size(r,1),1:size(r,1),r,grids(g).layout,...
        'axisargs',struct('clim',[0 1]),...
        'title',['grid ' num2str(g) ': ' grids(g).label])

    saveas(gcf,['d:/Spencer/ecogres/figures/MCRGRID_' grids(g).shortname '_' upper(ref) '.fig']);
    saveas(gcf,['d:/Spencer/ecogres/figures/MCRGRID_' grids(g).shortname '_' upper(ref) '.png']);
    saveas(gcf,['d:/Spencer/ecogres/figures/MCRGRID_' grids(g).shortname '_' upper(ref) '.eps'],'epsc2');
    close(gcf);
end