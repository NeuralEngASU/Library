function plot_raw_data(data,varargin)

layout = [-1 5  11 17 22 28; ...
          -1 6  12 18 23 29; ...
           1 7  13 19 24 30; ...
           2 8  14 20 25 31; ...
           3 9  15 21 26 -1; ...
           4 10 -1 -1 27 -1]';
ind = find(layout~=-1);
[rows,cols] = size(layout);
subplot_height = 1/rows;
subplot_width = 1/cols;

chan_list = sort(layout(ind));
channel_count = numel(chan_list);
handles = zeros(channel_count,1);
title_str = 'Raw Data';

YLimMax = 0;
YLimMax = max(YLimMax,max(data(:)))+100;
YLimMin = min(YLimMax,min(data(:)))+100;
YLim = [YLimMin YLimMax];

% user specified options
if(~isempty(varargin))
    for k=1:2:length(varargin)
        switch(varargin{k})
            case 'chan_list'
                chan_list = varargin{k+1};
            case 'layout'
                layout = varargin{k+1};
            case 'YLim'
                YLim = varargin{k+1};
            case 'title_str'
                title_str = varargin{k+1};
            otherwise
                disp(['Input option ' varargin{k} ' not supported']);
        end
    end
end

% generate plots
for c=1:channel_count
    [xpos,ypos] = find(layout==chan_list(c));
    if(~isempty(xpos) && ~isempty(ypos))
        % position the axes
        width = 0.95*subplot_width ;
        height = 0.92*subplot_height;
        left = (0.99*xpos*subplot_height - width);
        top = (0.96 - 1.03*ypos*height);
        handles(c) = axes('position',[left top width height]);
        
        % draw the spectrogram
        plot(squeeze(data(:,c,1:10:end))');
        set(gca,'YLim',YLim);
        if(c==5)
            set(gca,'XTick',[]);
        elseif(c==15)
            set(gca,'YTick',[]);
        else
            set(gca,'XTick',[],'YTick',[]);
        end
        
        % annotate the channel number to the axes
        awidth = diff(get(gca,'XLim'));
        aheight = diff(get(gca,'YLim'));
        text(0.9*awidth, 0.2*aheight, num2str(chan_list(c)),'FontUnits','normalized','FontSize',.12,'FontWeight','bold');
        box on;
    end
end
annotation('textbox',[0 0.97,1,0.02],'String',title_str,...
    'HorizontalAlignment','Center','Interpreter','none','EdgeColor','none','FontSize',0.12,'FontUnits','normalized','FontWeight','Bold');
set(gcf,'Name',title_str);