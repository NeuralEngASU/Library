function [mvals,seps,angles,pairseps,pairangles,sevals]=avgpersepdir(data,pairlist,layout,spacing,varargin)
% AVGPERSEP   Average a dataset by separation distance between electrodes
%    [MVALS,SEPS]=AVGPERSEP(DATA,PAIRLIST,LAYOUT,SPACING) returns the
%    mean of the data in DATA for unique separation distances.  For
%    MxNx... matrix DATA, with M observations for each of N channel pairs
%    (extra dimensions will be averaged out), PAIRLIST must be Nx2 
%    (specifying N pairs of channels in DATA).  LAYOUT contains the 
%    relative positions of each channel, with elements corresponding to the
%    values in PAIRLIST.  SPACING indicates the distance (in millimeters) 
%    between neighboring electrodes.  For P unique separation distances 
%    determined from LAYOUT and SPACING, MVALS will be an MxP matrix, and 
%    SEPS will contain the P separation distances.
%
%    [MVALS,SEPS,PAIRSEPS]=AVGPERSEP(...) also returns the distance
%    separating each pair of electrodes listed in PAIRLIST.
%
%    [MVALS,SEPS,PAIRSEPS,SEVALS]=AVGPERSEP(...) also returns the standard
%    error corresponding to each point in MVALS.

% error checking
if(size(pairlist,1)~=size(data,2))
    error('avgpersep:dim','There must be as many rows in pairlist as columns in data');
end

% check for specified bad channels
badchan=[];
if(~isempty(varargin))
    badchan=varargin{1};
end

% set layout to start at 1
layout=layout-min(layout(layout>0))+1;

% figure separation distances between electrodes
pairangles=pairlist(:,1)*0;
pairseps=pairlist(:,1)*0;
for p=1:size(pairlist,1)
    [r1,c1]=find(layout==pairlist(p,1));
    [r2,c2]=find(layout==pairlist(p,2));
    if(~isempty(r1)&&~isempty(r2))
        % separation distance
        x=spacing*(c2-c1);
        y=spacing*(r1-r2); % matrix indices upside down relative to cartesian coordinate system
        pairseps(p)=round(sqrt(x^2+y^2)*1000)/1000;

        % angle separating the two
        pairangles(p)=atan(y/x);
        if(x<0&&y>0)
            pairangles(p)=pairangles(p)+pi;
        elseif(x<0&&y<0)
            pairangles(p)=pairangles(p)-pi;
        end
        if(pairangles(p)<0)
            pairangles(p)=pairangles(p)+2*pi;
        end
        if(pairangles(p)>pi)
            pairangles(p)=pairangles(p)-pi;
        end
        pairangles(p)=round(pairangles(p)*1e6)/1e6;
        if(isnan(pairangles(p)))
            pairangles(p)=Inf;
        end
    else
        pairseps(p)=nan;
        pairangles(p)=nan;
    end
end
angles=unique(pairangles(~isnan(pairangles)&~isinf(pairangles)));
seps=unique(pairseps(~isnan(pairseps)));
clear p r1 r2 c1 c2 x y;

% set pair separations involving bad channels to -1
for k=1:length(badchan)
    pairseps(pairlist(:,1)==badchan(k)|pairlist(:,2)==badchan(k))=-1;
    pairangles(pairlist(:,1)==badchan(k)|pairlist(:,2)==badchan(k))=-1;
end

% loop over separation distances
mvals=zeros(size(data,1),length(seps),length(angles));
sevals=zeros(size(data,1),length(seps),length(angles));
for a=1:length(angles)
    for p=1:length(seps)
        if(seps(p)==0)
            rel=data(:,pairseps==seps(p)&isinf(pairangles),:);
        else
            rel=data(:,pairseps==seps(p)&pairangles==angles(a),:);
        end
        mvals(:,p,a)=nanmean(rel(:,:),2);
        sevals(:,p,a)=nanstd(rel(:,:),[],2)/sqrt(size(rel,2));
    end
end