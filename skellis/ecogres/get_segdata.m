function [raw,params]=get_segdata(path,grid,g,movingwin,ref)
% [raw,params]=get_segdata(path,grid,g,movingwin,ref)

% make sure there's a folder separation at the end
if(path(end)~='\' && path(end)~='/')
    path(end+1)='/';
end

% loop over sources, if any
dt=cell(1,length(grid.sources));
for s=1:length(dt)
    load([path 'g' num2str(g) 's' num2str(s) '.mat'],'raw','params');
    fs=params.fs;

    % rereference the data
    switch(lower(ref))
        case 'unr'
            raw=reref(raw,ref);
        case 'car'
            raw=reref(raw,ref,'badchan',grid.badchan);
        case 'dtr'
            raw=reref(raw,ref);
    end

    % reshape by window
    nseg=floor(size(raw,1)/(movingwin(1)*fs));
    dt{s}=reshape(raw(1:movingwin(1)*fs*nseg,:),movingwin(1)*fs,nseg,size(raw,2));
    clear raw;
end
raw=cat(2,dt{:}); clear dt;