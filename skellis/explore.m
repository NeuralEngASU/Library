function explore
% EXPLORE Graphically browse data in NSX files

% (Leave a blank line following the help.)
fig1.width = 600;
fig1.height = 670;
fig1.margin = 25;

%  Initialization tasks
handles = [];

fh = figure(...
    'NumberTitle','off', ...
    'Name','explore', ...
    'Resize','off', ...
    'Visible','off',...
    'MenuBar','none',...
    'Units','pixels',...
    'Position',[20 60 fig1.width fig1.height]);

%  Construct the components
panel0.x = fig1.margin;
panel0.y = fig1.margin;
panel0.height = 100;
panel0.width = fig1.width - 2*fig1.margin;
panel0.position = genPosition(panel0,fig1.height,fig1.width);
panel0.marginX = panel0.width*0.05;
panel0.marginY = panel0.width*0.05;
handles.p0 = uipanel(...
    'Parent',fh,...
    'Background',[.8 .8 .8],...
    'Title','Data Source',...
    'Units','pixels',...
    'Position',panel0.position);


% "NSX Description" static text
control = [];
control.x = panel0.x + panel0.marginX;
control.y = panel0.y + panel0.marginY;
control.height = panel0.height - 2*panel0.marginY;
control.width = panel0.width*0.65;
control.position = genPosition(control,fig1.height,fig1.width);
handles.nsxdesc_UI_statictext = uicontrol(...
    'Parent',fh,...
    'BackgroundColor',[.9 .9 .9],...
    'Units','pixels',...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','Click the button on the right to choose a data file (*.NSX)',...
    'Style','text',...
    'Tag','nsxdesc_UI_statictext');

% "Choose NSX" pushbutton
control = [];
control.x = panel0.x + panel0.width*0.05 + panel0.width*0.65 + panel0.width*0.05;
control.y = panel0.y + panel0.marginY;
control.height = panel0.height - 2*panel0.marginY;
control.width = panel0.width*0.2;
control.position = genPosition(control,fig1.height,fig1.width);
handles.choosensx_UI_pushbutton = uicontrol(...
    'Parent',fh,...
    'Units','pixels',...
    'Position',control.position,...
    'String','Choose NSX',...
    'Tag','choosensx_UI_pushbutton',...
    'Callback',{@choosensx_UI_pushbutton_Callback});



panel1.x = fig1.margin;
panel1.y = panel0.y + panel0.height + fig1.height*0.04;
panel1.height = 150;
panel1.width = fig1.width - 2*fig1.margin;
panel1.position = genPosition(panel1,fig1.height,fig1.width);
panel1.marginX = panel1.width*0.05;
panel1.marginY = panel1.width*0.06;
handles.p1 = uipanel(...
    'Parent',fh,...
    'Background',[.8 .8 .8],...
    'Title','Window Parameters',...
    'Units','Pixels',...
    'Position',panel1.position);

% "Select channel" popupmenu
control = [];
control.x = panel1.x + panel1.marginX;
control.y = panel1.y + panel1.marginY;
control.height = 20;
control.width = panel1.width*0.65;
control.position = genPosition(control,fig1.height,fig1.width);
handles.chansel_UI_popupmenu = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'BackgroundColor',[1 1 1],...
    'Position',control.position,...
    'String',{  'Select an NSX file before choosing a channel' },...
    'Style','popupmenu',...
    'Value',1,...
    'Tag','chansel_UI_popupmenu',...
    'UserData',[]);

% "Generate Plot" pushbutton
control = [];
control.x = panel1.x + panel1.width*0.05 + panel1.width*0.65 + panel1.width*0.05;
control.y = panel1.y + panel1.marginY;
control.height = panel1.height - 2*panel1.height*0.2;
control.width = panel1.width - 2*panel1.width*0.05 - (panel1.width*0.65 + panel1.width*0.05);
control.position = genPosition(control,fig1.height,fig1.width);
handles.genplot_UI_pushbutton = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'Position',control.position,...
    'String','Generate Plot',...
    'Tag','genplot_UI_pushbutton',...
    'Callback',@genplot_UI_pushbutton_Callback);

% "Window Size (sec)" static text
control = [];
control.x = panel1.x + panel1.marginX;
control.y = panel1.y + panel1.marginY + 30;
control.height = 13;
control.width = 100;
control.position = genPosition(control,fig1.height,fig1.width);
handles.winsize_UI_statictext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','Window Size (sec)',...
    'Style','text');

% "Window Size" edit text
control = [];
control.x = panel1.x + panel1.marginX;
control.y = panel1.y + panel1.marginY + 45;
control.height = 17;
control.width = 80;
control.position = genPosition(control,fig1.height,fig1.width);
handles.winsize_UI_edittext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','20',...
    'Style','edit',...
    'Tag','winsize_UI_edittext');

% "Step Size (sec)" static text
control = [];
control.x = panel1.x + panel1.marginX;
control.y = panel1.y + panel1.marginY + 70;
control.height = 13;
control.width = 100;
control.position = genPosition(control,fig1.height,fig1.width);
handles.stepsize_UI_statictext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','Step Size (sec)',...
    'Style','text');

% "Step Size" edit text
control = [];
control.x = panel1.x + panel1.marginX;
control.y = panel1.y + panel1.marginY + 85;
control.height = 17;
control.width = 80;
control.position = genPosition(control,fig1.height,fig1.width);
handles.stepsize_UI_edittext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','5',...
    'Style','edit',...
    'Tag','stepsize_UI_edittext');

% "Ymax" static text
control = [];
control.x = panel1.x + panel1.marginX + 150;
control.y = panel1.y + panel1.marginY + 30;
control.height = 13;
control.width = 100;
control.position = genPosition(control,fig1.height,fig1.width);
handles.ymax_UI_statictext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','Ymax (auto or #)',...
    'Style','text');

% "Ymax" edit text
control = [];
control.x = panel1.x + panel1.marginX + 150;
control.y = panel1.y + panel1.marginY + 45;
control.height = 17;
control.width = 80;
control.position = genPosition(control,fig1.height,fig1.width);
handles.ymax_UI_edittext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','auto',...
    'Style','edit',...
    'Tag','stepsize_UI_edittext');

% "Ymin" static text
control = [];
control.x = panel1.x + panel1.marginX + 150;
control.y = panel1.y + panel1.marginY + 70;
control.height = 13;
control.width = 100;
control.position = genPosition(control,fig1.height,fig1.width);
handles.ymin_UI_statictext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'BackgroundColor',[.8 .8 .8],...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','Ymin (auto or #)',...
    'Style','text');

% "Step Size" edit text
control = [];
control.x = panel1.x + panel1.marginX + 150;
control.y = panel1.y + panel1.marginY + 85;
control.height = 17;
control.width = 80;
control.position = genPosition(control,fig1.height,fig1.width);
handles.ymin_UI_edittext = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'Position',control.position,...
    'String','auto',...
    'Style','edit',...
    'Tag','stepsize_UI_edittext');



panel2.x = fig1.margin;
panel2.y = panel1.y + panel1.height + fig1.height*0.04;
panel2.height = fig1.height - panel2.y - fig1.margin;
panel2.width = fig1.width - 2*fig1.margin;
panel2.position = genPosition(panel2,fig1.height,fig1.width);
panel2.marginX = panel2.width*0.05;
panel2.marginY = panel2.width*0.06;
% handles.p2 = uipanel(...
%     'Parent',fh,...
%     'Background',[.8 .8 .8],...
%     'Title','Plot',...
%     'Units','Pixels',...
%     'Position',panel2.position);

% Axes
control = [];
control.x = panel2.x + panel2.marginX;
control.y = panel2.y + panel2.marginY;
control.height = 200;
control.width = panel2.width - 2*panel2.marginX;
control.position = genPosition(control,fig1.height,fig1.width);
handles.axes1 = axes(...
    'Parent',fh,...
    'HandleVisibility','callback',...
    'Units','Pixels',...
    'Position',control.position,...
    'Tag','axes1');

% "Back" pushbutton
control = [];
control.x = panel2.x + panel2.marginX;
control.y = panel2.y + 200 + 70;
control.height = 40;
control.width = 120;
control.position = genPosition(control,fig1.height,fig1.width);
handles.back_UI_pushbutton = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'Callback',@back_UI_pushbutton_Callback,...
    'Position',control.position,...
    'String','Back',...
    'Tag','back_UI_pushbutton');

% "Forward" pushbutton
control = [];
control.x = panel2.width - 120;
control.y = panel2.y + 200 + 70;
control.height = 40;
control.width = 120;
control.position = genPosition(control,fig1.height,fig1.width);
handles.fwd_UI_pushbutton = uicontrol(...
    'Parent',fh,...
    'Units','Pixels',...
    'Callback',@fwd_UI_pushbutton_Callback,...
    'Position',control.position,...
    'String','Forward',...
    'Tag','fwd_UI_pushbutton');


%  Initialization tasks

set(fh,'Visible','on');
handles.currTime = 0;

%  Callbacks

function choosensx_UI_pushbutton_Callback(hObject,eventdata)
    NSX = NSX_open;
    if(~isempty(NSX))
        set(handles.nsxdesc_UI_statictext,'String',{[NSX.fname], ...
            [num2str(NSX.length) 's'], [num2str(numel(NSX.Channel_ID)) ' Channels']});
        channel_list = [repmat('Channel ',[length(NSX.Channel_ID) 1]) num2str(NSX.Channel_ID')];
        set(handles.chansel_UI_popupmenu,'String', cellstr(channel_list));
        handles.NSX = NSX;
        guidata(hObject,handles);
    end
end

function back_UI_pushbutton_Callback(hObject,eventdata)
    axes(handles.axes1);
    cla;

    chidx = get(handles.chansel_UI_popupmenu, 'Value');
    start = handles.currTime - str2num(char(get(handles.stepsize_UI_edittext,'String')));
    if(start<0)
        start=0;
    end
    total = str2num(char(get(handles.winsize_UI_edittext,'String')));
    data = NSX_read(handles.NSX,chidx,1,start,total,'s','s');
    t = linspace(start,start+total,length(data));
    plot_window(t,data);

    handles.currTime = start;
end

function fwd_UI_pushbutton_Callback(hObject,eventdata)
    axes(handles.axes1);
    cla;

    chidx = get(handles.chansel_UI_popupmenu, 'Value');
    start = handles.currTime + str2num(char(get(handles.stepsize_UI_edittext,'String')));
    total = str2num(char(get(handles.winsize_UI_edittext,'String')));

    if(start+total > handles.NSX.length)
        start = handles.NSX.length-total;
    end

    data = NSX_read(handles.NSX,chidx,1,start,total,'s','s');
    t = linspace(start,start+total,length(data));
    plot_window(t,data);

    handles.currTime = start;
end

function genplot_UI_pushbutton_Callback(hObject,eventdata)
    axes(handles.axes1);
    cla;
    data = [];

    chidx = get(handles.chansel_UI_popupmenu, 'Value');
    total = str2num(char(get(handles.winsize_UI_edittext,'String')));
    data = NSX_read(handles.NSX,chidx,1,0,total,'s','s');
    t = linspace(0,total,length(data));
    plot_window(t,data);
    handles.currTime = 0;
end

%  Utility functions

function pos = genPositionNorm(s,h,w)
    pos = [s.x/w (h - s.y - s.height)/h s.width/w s.height/h];
end


function pos = genPosition(s,h,w)
    pos = [s.x (h - s.y - s.height) s.width s.height];
end

function plot_window(t,d)
    if(numel(t)==numel(d))
        plot(t,d);
        set(gca,'xlim',[min(t) max(t)]);
        ymax = char(get(handles.ymax_UI_edittext,'String'));
        ymin = char(get(handles.ymin_UI_edittext,'String'));
        
        if(strcmp(ymax,'auto') || strcmp(ymin,'auto'))
            ylim('auto');
        else
            set(gca,'ylim',[str2num(ymin) str2num(ymax)])
        end
    end
end

end