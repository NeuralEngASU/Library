% generate figures of zero-lag cross-correlation vs. separation distance
clear all;
close all;
clc;

% set up environment
% use('cleanpath');
% use('pkgs/skellis');

% define grids
grids=defgrids;

% specify rereferencing
ref='unr';

% specify frequency bins to look at
freq.bins=[8 12;
          30 80;];
freq.names={'beta','gamma'};

% loop over grids
d=cell(size(grids));
for g=1:length(grids)
    load(['D:\Kevin\SpencerPaper\201203\g' num2str(g) 'mcoh_' upper(ref) '.mat']);
    
    % maximum channel number
    max_channel_number=max(unique(chanpairs(:)));

    % convert to x by y by channel
    for q=1:length(freq.names)
        c.(freq.names{q})=zeros(size(layout,1),size(layout,2),max_channel_number);
        for k=1:max_channel_number
            if(~isempty(find(grids(g).badchan==k, 1)) || ~nnz(layout==k)) % bad channel, or not present in layout
                c.(freq.names{q})(:,:,k)=nan;
            else
                idx=find(chanpairs(:,1)==k|chanpairs(:,2)==k); % find any channel pairs involving channel k
                [notk,~]=find(chanpairs(idx,:)'~=k); % find which side of the pair is not channel k
                channels=chanpairs(sub2ind(size(chanpairs),idx,notk)); % list the other channels in the pairs involving k
                tmpdata=mean(mcoh(f>freq.bins(q,1)&f<freq.bins(q,2),idx),1); % calculate the data to be plotted
                mcoh_vec=nan(max(channels),1); % initialize to nans (for any empty channels)
                mcoh_vec(channels)=tmpdata; % place data in proper location in the vector, i.e., use the "other channels" from the pairs involving k
                mcoh_vec(k)=1; % set k's value to 1 - autocoherence
                mcoh_vec(grids(g).badchan)=nan;
                c.(freq.names{q})(:,:,k)=vec2layout(mcoh_vec,layout);
            end
        end

        fig=figure('PaperPositionMode','auto','Position',[50 50 size(layout,1)*80 size(layout,2)*80]);
        mymap=colormap('jet');
        mymap=[0 0 0; mymap;];
        colormap(mymap);
        gridimagesc(1:size(layout,1),1:size(layout,1),c.(freq.names{q}),layout,...
            'axisargs',struct('clim',[0 1],'box','off','Visible','off'),...
            'title',[grids(g).shortname ' (' freq.names{q} ')'])

        saveas(gcf,['D:\Kevin\SpencerPaper\201203\figures\MCHGRID_' grids(g).shortname '_' freq.names{q} '_' upper(ref) '.fig']);
        saveas(gcf,['D:\Kevin\SpencerPaper\201203\figures\MCHGRID_' grids(g).shortname '_' freq.names{q} '_' upper(ref) '.png']);
        saveas(gcf,['D:\Kevin\SpencerPaper\201203\figures\MCHGRID_' grids(g).shortname '_' freq.names{q} '_' upper(ref) '.eps'],'epsc2');
        close(gcf);
    end
end