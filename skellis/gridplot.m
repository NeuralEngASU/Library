function varargout=gridplot(varargin)
% GRIDPLOT   Plot channel data in a supplied grid layout
%    For matrix input Y, GRIDPLOT(X,Y,LAYOUT) plots each column of Y 
%    against X in the appropriate grid location as specified by LAYOUT.  
%    Each position in LAYOUT identifies the channel (i.e., column of Y) 
%    which should be plotted at that location in the figure.  The input X 
%    must be a vector with LENGTH(X) equal to SIZE(Y,1).
%
%    GRIDPLOT(T,F,S,LAYOUT) assumes S is three-dimensional, with the last
%    dimension representing channels, and uses IMAGESC(T,F,S(:,:,CHAN)) 
%    for each subplot.
%
%    GRIDPLOT exploits the matrix nature of the built-in SUBPLOT function 
%    to reduce the amount of whitespace between subplots.  GRIDPLOT creates
%    a rectangular matrix representing the grid layout, with many times 
%    more rows and columns than the layout requires.  GRIDPLOT assigns
%    multiple rows and columns for each grid position, leaving only a few 
%    rows or columns as a narrow whitespace between subplots.
%    
%    GRIDPLOT(H,...) uses the figure identified by its handle H.  If no
%    handle is supplied, GRIDPLOT will use the current figure (identified 
%    by GCF) or create a new figure if none are open.
%
%    GRIDPLOT accepts the following parameters:
%
%       BLOCKW      Width (in elements of a subplot matrix) of each subplot
%       BLOCKH      Height (in elements of a subplot matrix) of each 
%                   subplot
%       ISPACING    Spacing (number of rows or columns of a subplot matrix)
%                   between each subplot
%       OSPACING    Spacing (number of rows or columns of a subplot matrix)
%                   around the edges of the figure
%       TITLEH      Height (number of rows of a subplot matrix) of the
%                   title subplot at the top of the figure
%       TITLE       A string to display at the top of the figure
%       TYPE        The type of plot to use; acceptable values are 'plot'
%                   or 'imagesc'.
%       XLABEL      A string to display beneath the bottom row of subplots
%       YLABEL      A string to display along the left column of subplots
%       CHAN        A value of 1 or 0 to indicate whether to label selected
%                   subplots with the corresponding channel number
%       HOLD        Uses built-in HOLD function.  Value should be 'on' or 
%                   'off'.  The command is applied to each subplot.
%       LINESPEC    A string formatted as the normal LINESPEC input to the
%                   built-in PLOT function.
%       LINKAXES    Whether to link x, y, or both axes for all subplots in
%                   the figure.  Default to none (set to '').  CAUTION:
%                   turning this option on will significantly increase
%                   runtime.
%       LINEWIDTH   Works as with the LINEWIDTH parameter for the PLOT
%                   function.
%       MARKERSIZE  Works as with the MARKERSIZE parameter for the PLOT
%                   function.
%       PLOTARGS    A struct array with fields 'name' and 'val'indicating 
%                   the property names and property values to be applied to
%                   the plot handle.  This struct takes precedence over the
%                   previous arguments 'LINEWIDTH' and 'MARKERSIZE'.
%       AXISARGS    A struct array with fields 'name' and 'val'indicating 
%                   the property names and property values to be applied to
%                   the subplot handle
%
%    Example
%    In this example, 'S' is 410x32x192, or frequency x channel x trial.
%    The variable 'lbl' identifies the class of each trial.  The variable
%    'f' identifies each frequency.  
%
%       layout=[    -1     5    11    17    22    28
%                   -1     6    12    18    23    29
%                    1     7    13    19    24    30
%                    2     8    14    20    25    -1
%                    3     9    15    21    26    -1
%                    4    10    -1    -1    27    -1];
%       
%       gridplot(f,10*log10(mean(S(:,:,lbl==0),3)),layout,...
%                'hold','on','LineSpec','b','LineWidth',2);
%       gridplot(f,10*log10(mean(S(:,:,lbl==1),3)),layout,...
%                'hold','off','LineSpec','g','LineWidth',2);
%
%    This sequence produces a plot of the 0-class trials in blue overlaid 
%    by the 1-class trials in green.
%
%    Additional information
%    Function created by Spencer Kellis, spencer.kellis@utah.edu
%    v0.1 -- 6 April 2011 -- initial release (beta)


%% DEFAULTS
PARAMS.blockw=15; % width of each electrode's plot, in terms of subplot elements
PARAMS.blockh=15; % height of each electrode's plot
PARAMS.ispacing=1; % rows or columns of ispacing between each plot
PARAMS.ospacing=0; % rows or columns of ispacing around the figure edges
PARAMS.titleh=5; % rows of subplots for the title
PARAMS.title_str=[];
PARAMS.type='plot'; % type of plot to make (imagesc or plot)
PARAMS.xlbl=[]; % label to place on x-axis of bottom row
PARAMS.ylbl=[]; % label to place on y-axis of leftmost column
PARAMS.dispchan=1; % whether to display the channel numbers at selected positions
PARAMS.hold='off'; % argument to the built-in HOLD function, applied to each subplot
PARAMS.linespec=''; % the LineSpec string normally accepted by PLOT
PARAMS.linkaxes=''; % the OPTION parameter to built-in linkaxes function
PARAMS.linewidth=1; % passed as an argument to the PLOT function
PARAMS.markersize=1; % passed as an argument to the PLOT function

%% USER INPUTS
% check for arguments
if(nargin<1 || (nargin==1 && ishandle(varargin{1})))
    error('gridplot:input','There must be at least one input to plot');
end

% parse the user inputs
[FIGH,PARAMS,PLOTARGS,AXISARGS,LAYOUT,DATA]=gridplot_parse_inputs(varargin,PARAMS);


%% SUBPLOT INITIALIZATION
% grid size of the electrode layout
[R,C]=size(LAYOUT);

% height/width of non-title subplots
sph=2*PARAMS.ospacing+R*PARAMS.blockh+(R-1)*PARAMS.ispacing;
spw=2*PARAMS.ospacing+C*PARAMS.blockw+(C-1)*PARAMS.ispacing;

% init subplot matrices: column-order first for ease of populating the
% data, then switch to row-order for subplot indices
spmat_title=reshape(1:PARAMS.titleh*spw,[spw PARAMS.titleh])';
spmat_plots=reshape((PARAMS.titleh*spw)+(1:sph*spw),[spw sph])';

% adjust height to account for the title
sph=sph+PARAMS.titleh;

%% PLOTTING

% put figure title up
if(~isempty(spmat_title))
    subplot(sph,spw,spmat_title(:));
    axis off; title(PARAMS.title_str,'FontWeight','bold');
end

% run through subplots, one per electrode
elist=LAYOUT(LAYOUT>0);
SPH=zeros(size(elist)); % handles to the subplots
for k=1:length(elist)
    elec=elist(k);
    [r,c]=find(LAYOUT==elec);
    spidx_row=PARAMS.ospacing+(r-1)*PARAMS.blockh+(r-1)*PARAMS.ispacing+1;
    spidx_row=spidx_row:spidx_row+PARAMS.blockh-1;
    %spidx_row=(r-1)*(blockh+ispacing)+1:(r-1)*(blockh+ispacing)+blockh;
    spidx_col=PARAMS.ospacing+(c-1)*(PARAMS.blockw+PARAMS.ispacing)+1;
    spidx_col=spidx_col:spidx_col+PARAMS.blockw-1;
    %spidx_col=(c-1)*(blockw+ispacing)+1:(c-1)*(blockw+ispacing)+blockw;
    splist=spmat_plots(spidx_row,spidx_col);
    
    % PLOT
    SPH(k)=subplot(sph,spw,splist(:));
    switch(PARAMS.type)
        case 'plot'
            d1=DATA.DIM1;
            d2=DATA.SIGNAL(:,elec);
            PLOTH=plot(d1,d2,PARAMS.linespec);
            set(PLOTH,'LineWidth',PARAMS.linewidth);
            set(PLOTH,'MarkerSize',PARAMS.markersize);
        case 'imagesc'
            d1=DATA.DIM1;
            d2=DATA.DIM2;
            d3=DATA.SIGNAL(:,:,elec);
            PLOTH=imagesc(d1,d2,d3'); axis xy;
    end
    
    % APPLY PLOT ARGUMENTS
    set(PLOTH,PLOTARGS);

    % APPLY SUBPLOT ARGUMENTS
    set(SPH(k),AXISARGS);

    % HOLD ON OR OFF
    hold(PARAMS.hold);

    % X LABEL
    if(isempty(find(LAYOUT(end,:)==elec,1)))
        set(gca,'XTick',[]);
    else
        if(PARAMS.dispchan)
            if(isempty(PARAMS.xlbl))
                xlabel(['Chan. ' num2str(elec)]);
            else
                xlabel({PARAMS.xlbl,['Chan. ' num2str(elec)]});
            end
        else
            xlabel(PARAMS.xlbl);
        end
    end

    % Y LABEL
    if(isempty(find(LAYOUT(:,1)==elec,1)))
        set(gca,'YTick',[]);
    else
        if(PARAMS.dispchan)
            if(isempty(PARAMS.ylbl))
                ylabel(['Chan. ' num2str(elec)]);
            else
                ylabel({PARAMS.ylbl,['Chan. ' num2str(elec)]});
            end
        else
            ylabel(PARAMS.ylbl)
        end
    end
    
    % TOP ROW TITLES
    if(~isempty(find(LAYOUT(1,:)==elec,1)))
        if(PARAMS.dispchan)
            title(['Chan. ' num2str(elec)]);
        end
    end

end

% LINKAXES
if(~isempty(PARAMS.linkaxes))
    linkaxes(SPH,PARAMS.linkaxes);
end

%% assign output arguments
if(nargout>0)
    varargout{1}=FIGH;
end




%% PARSE USER INPUTS
% Returns figure handle, parameters, plot parameters, layout, and data from
% the supplied input arguments
function [h,params,plotargs,axisargs,layout,data]=gridplot_parse_inputs(inp,params)

% check whether the first argument is a figure handle
if(ishandle(inp{1}))
    h=inp{1};
    inp(1)=[];
else
    h=[];
end

% loop over inputs
plotargs=struct([]);
axisargs=struct([]);
num_data_inputs=0;
params.utype=''; % user-specified plot type
idx=1;
while(idx<=length(inp))
    if(strcmpi(inp{idx},'blockw'))
        params.blockw=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'blockh'))
        params.blockh=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'ispacing'))
        params.ispacing=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'ospacing'))
        params.ospacing=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'titleh'))
        params.titleh=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'type'))
        params.utype=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'title'))
        params.title_str=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'xlabel'))
        params.xlbl=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'ylabel'))
        params.ylbl=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'chan'))
        params.dispchan=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'hold'))
        params.hold=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'linespec'))
        params.linespec=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'linkaxes'))
        params.linkaxes=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'linewidth'))
        params.linewidth=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'markersize'))
        params.markersize=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'plotargs'))
        plotargs=inp{idx+1};
        idx=idx+1;
    elseif(strcmpi(inp{idx},'axisargs'))
        axisargs=inp{idx+1};
        idx=idx+1;
    else
        num_data_inputs=num_data_inputs+1;
    end
    idx=idx+1;
end

% assume layout is last before string/value-style arguments
layout=inp{num_data_inputs};
num_data_inputs=num_data_inputs-1;

% init plot type: autoselect if no input, otherwise check for problems
if(isempty(params.utype))
    switch(num_data_inputs)
        case 1, params.type='plot'; % default PLOT for only one input
        case 2, params.type='plot'; % default PLOT for two inputs
        case 3, params.type='imagesc'; % default IMAGESC for three inputs
    end
else
    params.type=params.utype;
    params=rmfield(params,'utype');
    switch(num_data_inputs)
        case 2
            if(strcmpi(params.type,'imagesc'))
                error('gridplot:wrongplottype','Wrong plot type (''imagesc'') for 2 inputs');
            end
        case 3
            if(strcmpi(params.type,'plot'))
                error('gridplot:wrongplottype','Wrong plot type (''plot'') for 3 inputs');
            end
    end
end

% assign plot variables
if(num_data_inputs==1)
    if(strcmpi(params.type,'plot'))
        data.SIGNAL=inp{1};
        data.DIM1=(1:size(SIGNAL,1))';
    elseif(strcmpi(params.type,'imagesc'))
        data.SIGNAL=inp{1};
        data.DIM1=(1:size(SIGNAL,1))';
        data.DIM2=(1:size(SIGNAL,2))';
    end
elseif(num_data_inputs==2)
    data.SIGNAL=inp{2};
    data.DIM1=inp{1};
elseif(num_data_inputs==3)
    data.SIGNAL=inp{3};
    data.DIM1=inp{1};
    data.DIM2=inp{2};
end

% check size of SIGNAL
if(min(size(data.SIGNAL))==1)
    error('gridplot:badlayout','LAYOUT must be supplied and the data should be two-dimensional');
end

% check number of elements in LAYOUT
if(numel(layout)<size(data.SIGNAL,numel(size(data.SIGNAL))))
    error('gridplot:badlayout','LAYOUT must have at least as many elements as columns of data');
end

% turn off title if not used
if(isempty(params.title_str))
    params.titleh=0;
end

% init or focus figure
if(isempty(h))
    h=gcf;
end