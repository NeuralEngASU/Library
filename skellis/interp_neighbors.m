% data=interp_neighbors(data,map,electrodes,mode)
% replace electrodes with neighbor-averages
% used to add data to corners in UEA, or replace bad electrodes with guess
% at what the signal should have been.
%
% inputs:
% data - full set of data; 
%      - for matrix, channels x time (e.g., data(1,:) is chan 1)
%      - for vector, points x channels (e.g., 1x100 for one pt, 100 chan)
% map - the layout of the electrodes
% electrodes - which electrodes to be replaced by neighbor averages
% mode - use mean, median, fix the data, etc. (option; default 'mean')
%      - possible values are 'mean','fixmedian'
%
% outputs:
% data - the updated matrix of data

function data=interp_neighbors(data,map,electrodes,varargin)
% to do: add weights based on distance (e.g., vertical and horizontal 
% neighbors weighted more than diagonal neighbors)

% check for empty electrodes list
if(isempty(electrodes))
    return;
end

% re-orient for the loop
if(size(electrodes,1)>size(electrodes,2))
    electrodes=electrodes';
end

% re-orient data if necessary
transpose_flag=0;
if(min(size(data))==1 && size(data,1)<size(data,2))
    transpose_flag=1;
    data=data';
elseif(min(size(data))~=1 && size(data,1)>size(data,2))
    transpose_flag=1;
    data=data';
end

% defaults
mode='mean';

% user-defined inputs
if(nargin>3)
    mode=varargin{1};
end

% loop over electrodes to be replaced by neighbor averages
for el=electrodes
    % find row, column indicies
    [r,c]=find(map==el);

    % generate neighbor row, column indices
    vec=[r-1 c-1; r-1 c; r-1 c+1; r c-1; r c+1; r+1 c-1; r+1 c; r+1 c+1;];

    % get rid of points outside the boundaries of the map
    vec(vec(:,1)==0|vec(:,1)>size(map,1),:)=[]; % rows
    vec(vec(:,2)==0|vec(:,2)>size(map,2),:)=[]; % columns

    % convert back to channel numbers (i.e. indices into "data" matrix)
    neighbors=map(sub2ind(size(map),vec(:,1),vec(:,2)));

    % remove any subject-electrodes from the neighbor list
    for n=length(neighbors):-1:1
        if(sum(electrodes(find(electrodes==el):end)==neighbors(n)))
            vec(n,:)=[];
            neighbors(n)=[];
        end
    end

    % assign neighbor average
    switch(mode)
        case 'mean'
            data(el,:)=mean(data(neighbors,:),1);
        case 'fixmedian'
            data(el,:)=fix(median(data(neighbors,:),1));
    end
end

% re-transpose data if needed
if(transpose_flag)
    data=data';
end