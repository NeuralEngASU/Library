%
% get_trials
%  Analyze x/y movement and velocity to extract trials
%  Returns a struct containing trial info
%
%  trials = get_trials(x,y,v,t)
%
function trials = get_trials(x,y,v,t,varargin)

%%
%  CONSTANTS
%  define threshold characteristics
%
Fs = 100;
PLOT = 0;
MIN_HEIGHT = 0.2; % velocity must reach at least 20% above baseline (5%)
MIN_WIDTH = 0.5; % total velocity movement width at least 500ms
MIN_SEPARATION = 0.5; % required time lapse between end of last movement and beginning of current

%%
%  User-defined constants
%
for k=1:2:length(varargin)
    switch(varargin{k})
        case 'Fs'
            Fs = varargin{k+1};
        case 'MIN_HEIGHT'
            MIN_HEIGHT = varargin{k+1};
        case 'MIN_WIDTH'
            MIN_WIDTH = varargin{k+1};
        case 'MIN_SEPARATION'
            MIN_SEPARATION = varargin{k+1};
        case 'PLOT'
            PLOT = varargin{k+1};
        otherwise
            disp(['Input option ' varargin{k} ' not supported']);
    end
end

%%
%  EXTRACT TRIALS
%
% find all "velocity pulses"
potential_points = find(v>0.05); % recall from above the velocity is normalized so this is everything above the 5% level
movement.start = potential_points(  find(diff(potential_points)>1) + 1  ); % this finds the first marker in each movement (assumes within a movement all markers are next to each other)
potential_points(1) = []; % the first velocity is == 1 which messes up end_point calculation
movement.end = [potential_points( find(diff(potential_points)>1) - 1  ) potential_points(end)];

% catch any poor pairings (where end is before or equal to start)
bad_points = movement.end-movement.start <= 0;
movement.start( bad_points ) = [];
movement.end( bad_points ) = [];

movement.vmax = zeros(1,length(movement.start));
for p=1:length(movement.start)
    movement.vmax(p) = find(v(movement.start(p):movement.end(p))==max(v(movement.start(p):movement.end(p))),1) + movement.start(p);
end

% filter out bad pulses
for p=length(movement.start):-1:1
    if((v(movement.vmax(p))-mean([v(movement.start(p)) v(movement.end(p))]) < MIN_HEIGHT) ... % test heigh of velocity movement
            || (movement.end(p) - movement.start(p) < MIN_WIDTH*Fs) ... % test width of velocity movement
            || (p>1 && movement.start(p)-movement.end(p-1) < MIN_SEPARATION*Fs) ... % test separation between movements
            )
        movement.vmax(p) = [];
        movement.start(p) = [];
        movement.end(p) = [];
    end
end

%%
%  SORTING
%  arrange trial markers into reachout/upleft,
%  reachout/upright, etc.
%
% 3x3 grid of start/end points
hor_edges = linspace(-1e4,1e4,4);
ver_edges = linspace(-1e4,1e4,4);

% use histc to perform the work of classifying movements
[nstartx,binstartx] = histc(x(movement.start),hor_edges);
[nstarty,binstarty] = histc(y(movement.start),ver_edges);
[nendx,binendx]     = histc(x(movement.end),hor_edges);
[nendy,binendy]     = histc(y(movement.end),ver_edges);

% arrange into struct
trials = repmat(struct,length(movement.start),1);
for p=1:length(movement.start)
    trials(p).type = str2double([num2str(binstartx(p)) num2str(binstarty(p)) num2str(binendx(p)) num2str(binendy(p))]);
    trials(p).time_start = t(movement.start(p));
    trials(p).time_vmax = t(movement.vmax(p));
    trials(p).time_end = t(movement.end(p));
    trials(p).sample_start = movement.start(p);
    trials(p).sample_vmax = movement.vmax(p);
    trials(p).sample_end = movement.end(p);
    trials(p).x = x(movement.start(p):movement.end(p));
    trials(p).y = y(movement.start(p):movement.end(p));
    trials(p).v = v(movement.start(p):movement.end(p));
    trials(p).use = 1;
end
types = unique([trials.type]);
colors = {'gx','rx','mx','kx','yx','bx','go','ro','mo','ko','yo','bo','g.','r.','m.','k.','y.','b.'};

if(PLOT==1)
    figure;
    plot3(t,x,y);
    hold on;
    lgnd = {'Movement'};
    for p=1:length(types)
        tmp = trials([trials.type]==types(p));
        plot3(t([tmp.sample_start]),x([tmp.sample_start]),y([tmp.sample_start]),colors{p},'MarkerSize',10,'LineWidth',5);
        lgnd{end+1} = type_id2str(types(p));
    end
    ylim([-1e4 1e4]);
    zlim([-1e4 1e4]);
    xlabel('time');
    ylabel('x');
    zlabel('y');
    legend(lgnd,'Interpreter','none');
end

%%
%  FILTERING
%  hold on to just the well-stereotyped movement
%
for tp=types
%     disp(['Looking at tp = ' type_id2str(tp)]);
    ind = find([trials.type]==tp);
%     disp(['Before: ' num2str(numel(ind))]);
    AVG_VMAX = mean([trials(ind).sample_vmax]-[trials(ind).sample_start]);
    STD_VMAX = std([trials(ind).sample_vmax]-[trials(ind).sample_start]);
    AVG_HEIGHT = mean(v([trials(ind).sample_vmax]));
    STD_HEIGHT = std(v([trials(ind).sample_vmax]));
    AVG_END = mean([trials(ind).sample_end]-[trials(ind).sample_start]);
    STD_END = std([trials(ind).sample_end]-[trials(ind).sample_start]);

    for p=ind
        if(  (abs(trials(p).sample_vmax-trials(p).sample_start - AVG_VMAX) > 1.7*STD_VMAX) ... % test location of velocity max
                || (abs(v(trials(p).sample_vmax)-AVG_HEIGHT) > 1.7*STD_HEIGHT) ... % test height of velocity max
                || (abs(trials(p).sample_end-trials(p).sample_start - AVG_END) > 1.7*STD_END) ... % test end location
                )
            trials(p).use = 0;
        else
            trials(p).use = 1;
        end
    end

    if(sum([trials(ind).use])<3)
        trials(ind) = [];
        types(types==tp) = [];
    end
end

if(PLOT==1)
    figure;
    [rows,cols] = bestplotdim(1:10,length(types));
    for p=1:length(types)
        subplot(rows,cols,p);
        tmp=find([trials.type]==types(p));
        hold on;
        for q=1:length(tmp)
            if(trials(tmp(q)).use==1)
                plot(trials(tmp(q)).v);
            else
                plot(trials(tmp(q)).v,'r');
            end
        end
        title(type_id2str(types(p)),'Interpreter','none');
        xlabel('Samples');
        ylabel('Velocity');
    end
end

end