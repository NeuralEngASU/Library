function varargout=gridimagesc(x,y,z,layout,varargin)

if(isempty(x) || isempty(y) || isempty(z) || isempty(layout))
    error('gridplot2:inputs','Must provide nonempty x, y, and layout');
end

if(size(x,1)<size(x,2))
    x=x';
end

if(size(y,1)<size(y,2))
    y=y';
end

AXISARGS=struct([]);
TITLE=0;
for idx=1:length(varargin)
    if(strcmpi(varargin{idx},'axisargs'))
        AXISARGS=varargin{idx+1};
    end
    if(strcmpi(varargin{idx},'title'))
        TITLE=1;
        TITLESTR=varargin{idx+1};
    end
end

% number of axes in each dimension
NUM_PLOTS_Y=size(layout,1);
NUM_PLOTS_X=size(layout,2);

% full height/width of figure
PLOT_HEIGHT=1;
PLOT_WIDTH=1;

% title or no
TITLE_HEIGHT=0;
if(TITLE)
    TITLE_HEIGHT=0.05;
end

% space between axes and around figure edges
INNER_SPACE=0.01;
OUTER_SPACE=0.05;

% width and height of each axis
AX_WIDTH=(PLOT_WIDTH-2*OUTER_SPACE-(NUM_PLOTS_X-1)*INNER_SPACE)/NUM_PLOTS_X;
AX_HEIGHT=(PLOT_HEIGHT-TITLE_HEIGHT-2*OUTER_SPACE-(NUM_PLOTS_Y-1)*INNER_SPACE)/NUM_PLOTS_Y;

% left/bottom indices for each axis starting point
LEFT_IDX= OUTER_SPACE: (AX_WIDTH+INNER_SPACE) :(PLOT_WIDTH-OUTER_SPACE);
BOTTOM_IDX= (PLOT_HEIGHT-TITLE_HEIGHT-OUTER_SPACE-AX_HEIGHT): -(AX_HEIGHT+INNER_SPACE) :OUTER_SPACE;

% determine which channels to plot
chanlist=sort(unique(layout(~isnan(layout(:)) & layout(:)>0)),'ascend');

% determine labeling
XLBLSTR='';
YLBLSTR='';
CLBLSTR='';

% determine axis limits
XLIMS=[];
YLIMS=[];
CLIMS=[];
axisargfields=fieldnames(AXISARGS);
for k=1:length(axisargfields)
    if(strcmpi(axisargfields{k},'xlim'))
        XLIMS=AXISARGS.(axisargfields{k});
    elseif(strcmpi(axisargfields{k},'ylim'))
        YLIMS=AXISARGS.(axisargfields{k});
    elseif(strcmpi(axisargfields{k},'clim'))
        CLIMS=AXISARGS.(axisargfields{k});
    end
end
if(isempty(XLIMS))
    XLIMS=[min(x(~isinf(x(:))))-0.5 max(x(~isinf(x(:))))+0.5];
end
if(isempty(YLIMS))
    YLIMS=[min(y(~isinf(y(:))))-0.5 max(y(~isinf(y(:))))+0.5];
end
if(isempty(CLIMS))
    CLIMS=[min(z(~isinf(z(:)))) max(z(~isinf(z(:))))];
end
dXLIMS=diff(XLIMS);
dYLIMS=diff(YLIMS);
dCLIMS=diff(CLIMS);

% establish left/bottom position for each channel
LEFTS=zeros(1,length(chanlist));
BOTTOMS=zeros(1,length(chanlist));
TOP_ROW=zeros(1,length(chanlist));
BOTTOM_ROW=zeros(1,length(chanlist));
LEFT_COL=zeros(1,length(chanlist));
RIGHT_COL=zeros(1,length(chanlist));
for k=1:length(chanlist)
    [r,c]=find(layout==chanlist(k));
    LEFTS(k)=LEFT_IDX(c);
    BOTTOMS(k)=BOTTOM_IDX(r);
    if(r==1)
        TOP_ROW(k)=1;
    end
    if(r==NUM_PLOTS_Y)
        BOTTOM_ROW(k)=1;
    end
    if(c==1)
        LEFT_COL(k)=1;
    end
    if(c==NUM_PLOTS_X)
        RIGHT_COL(k)=1;
    end
end

% test with numbers
LH=zeros(1,length(chanlist));
AXH=zeros(1,length(chanlist));
AXOPT=repmat(AXISARGS,1,length(chanlist));
for k=1:length(chanlist)

    % set up axes properties
    AXOPT(k).position=[LEFTS(k) BOTTOMS(k) AX_WIDTH AX_HEIGHT];
    AXOPT(k).xlim=XLIMS;
    AXOPT(k).ylim=YLIMS;
    AXOPT(k).clim=CLIMS;
    AXOPT(k).xtick=[];
    AXOPT(k).ytick=[];
    AXOPT(k).yaxislocation='left';
    thisax_xlbl='';
    thisax_ylbl='';

    % special cases: the left, bottom, right edges
    if(BOTTOM_ROW(k))
        %AXOPT(k).xtick=unique(round( (linspace(XLIMS(1)+0.15*dXLIMS,XLIMS(2)-0.15*dXLIMS,3))*100 )/100);
        thisax_xlbl=XLBLSTR;
    end
    if(LEFT_COL(k))
        %AXOPT(k).ytick=unique(round( (linspace(YLIMS(1)+0.15*dYLIMS,YLIMS(2)-0.15*dYLIMS,3))*100 )/100);
        thisax_ylbl=YLBLSTR;
    end
    if(RIGHT_COL(k))
        %AXOPT(k).yaxislocation='right';
        %AXOPT(k).ytick=unique(round( (linspace(YLIMS(1)+0.15*dYLIMS,YLIMS(2)-0.15*dYLIMS,3))*100 )/100);
        thisax_ylbl=YLBLSTR;
    end

    % create the axes
    AXH(k)=axes();

    % plot the data
    LH(k)=image(x,y,z(:,:,chanlist(k)),'CDataMapping','scaled','Parent',AXH(k));
    set(AXH(k),AXOPT(k));

    % set properties
    set(AXH(k),AXISARGS);
    xlabel(thisax_xlbl);
    ylabel(thisax_ylbl);

    % print the channel number in the corner
%     text(XLIMS(1)+0.05*dXLIMS,YLIMS(1)+0.25*dYLIMS,num2str(chanlist(k)),...
%         'Color',[1 1 1],'FontWeight','normal','FontSize',20);
end

% set the title
if(TITLE)
    AXH(end+1)=axes('position',[LEFT_IDX(1) 0.91 0.9 0.0001],'color','none');
    set(gca,'box','off','xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[],...
        'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8]);
    title(TITLESTR);
end