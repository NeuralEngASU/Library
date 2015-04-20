function [x,layout,spacing,ref]=reref(x,varargin)
% REREF Apply software rereferencing to time series
%    X=REREF(X) performs a common-average re-reference of the data in X, 
%    in which rows are observations and columns are channels of data.
%
%    X=REREF(X,'unr') does not modify the data in any way.
%
%    X=REREF(X,'car') (default) performs a common-average re-reference by 
%    subtracting the average of all channels from each channel.  No
%    additional parameters are required.
%
%    X=REREF(X,'war') performs weighted-average re-reference, in which the
%    contribution of each channel is weighted by the inverse of its 
%    interquartile range (the difference between the 75th and 25th 
%    percentiles).  No additional parameters are required.
%
%    X=REREF(X,'sar',LAYOUT,SPACING) performs a spatial-average 
%    re-reference, in which the contribution of each channel to the average
%    is weighted according to distance from the channel being 
%    re-referenced.  The weighting is given by a Gaussian function centered
%    at the channel being re-referenced, with default standard deviation 
%    0.5mm.
%
%    X=REREF(X,'sar',LAYOUT,SPACING,SIGMA) performs the spatial-average
%    re-referencing described above, with standard deviation specified by
%    SIGMA.  SIGMA should be specified in units of millimeters.
%
%    X=REREF(X,'pwr',LAYOUT,SPACING) performs a pair-wise re-reference, in
%    which new bipolar channels are formed as the difference between
%    physical neighbors, and are located midway between the pair.  This
%    option is not fully tested.
%
%    X=REREF(X,'dtr') detrends each column of data in 200 msec segments.
%
%    X=REREF(...,'badchan',BADCHAN) uses vector of channels specified in
%    BADCHAN to exclude certain channels from contributing to the
%    re-reference.

% assign empty outputs
layout=[];
spacing=[];
ref=[];

% assign method
METHOD='car';
if(~isempty(varargin))
    METHOD=varargin{1};
    varargin(1)=[];
end

% specify which channels to use; incorporate specified bad channels
badchan=[];
if(~isempty(varargin))
    if(strcmpi(varargin{length(varargin)-1},'badchan'))
        badchan=varargin{end};
        varargin(end-1:end)=[]; % remove from input list
    end
end
goodchan=setdiff(1:size(x,2),badchan);

% evaluate
switch(lower(METHOD))
    case 'unr' % no action
        return;

    case 'car' % common average re-referencing
        ref=mean(x(:,goodchan),2);
        x=x-repmat(ref,[1 size(x,2)]);
        
    case 'bankcar' % common average re-referencing by 16-chan bank
        num_banks=ceil(size(x,2)/16);
        ref=zeros(size(x,1),num_banks);
        for b=1:num_banks
            bank_goodchan=goodchan(goodchan>((b-1)*16+1)&goodchan<b*16);
            bank_allchan=((b-1)*16+1):min(b*16,size(x,2));
            ref(:,b)=mean(x(:,bank_goodchan),2);
            x(:,bank_allchan)=x(:,bank_allchan)-repmat(ref(:,b),[1 length(bank_allchan)]);
        end

    case 'war' % weighted average re-referencing
        % find interquartile range
        percentiles=prctile(x,[25 75]);
        iq=abs(diff(percentiles,1));

        % weighted common average
        idx=goodchan;
        idx( iq(idx)==0 )=[];
        comavg=sum(repmat(1./iq(idx),size(x,1),1).*x(:,idx),2)/nnz(idx);
        ref=repmat(iq,size(x,1),1).*repmat(comavg,1,size(x,2));

        % scaled rereferencing
        x=x-ref;

    case 'sar' % spatial average re-referencing
        % pull out layout and spacing data
        layout=varargin{1};
        spacing=varargin{2};

        % specify sigma
        sg=0.5; % in mm
        if(length(varargin)>2)
            sg=varargin{3};
        end

        % calculate spatial averages
        ref=zeros(size(x));
        for k=1:size(x,2)
            [r,c]=find(layout==k);

            % find distance between this and every other electrode
            d=zeros(1,size(x,2));
            for m=1:size(x,2)
                [rr,cc]=find(layout==m);
                if(~isempty(rr))
                    d(m)=spacing*sqrt( (rr-r)^2 + (cc-c)^2 );
                else
                    d(m)=inf; % result in 0 weight
                end
            end

            % calculate weighting by gaussian function
            w=exp((-d.^2)/(2*sg^2));
            
            % % % constrain the current channel to the same weight as one-away
            % % % neighbors
            % % w(k)=max(w(w<1));
            
            % exclude current channel from the average
            w(k)=0;
            
            % scale to sum to one
            w=w/sum(w); % sum to one for the average

            % remove bad channels
            w(badchan)=0;

            % form the spatial average as a weighted combination
            ref(:,k)=sum(repmat(w,size(x,1),1).*x,2);
        end
        x=x-ref;

    case 'pwr' % pair-wise re-referencing
        % pull out layout and spacing data
        layout=varargin{1};
        spacing=varargin{2};

        % find neighbors from the layout
        chlist=sort(layout(layout>0),'ascend');
        neighbors=nchoosek(chlist,2);
        for k=size(neighbors,1):-1:1 % look for neighbors
            [r1,c1]=find(layout==neighbors(k,1));
            [r2,c2]=find(layout==neighbors(k,2));
            if(sqrt((r1-r2)^2+(c1-c2)^2)~=1)
                neighbors(k,:)=[];
            end
        end

        % set up new spacing, layout
        spacing=spacing/2;
        tmplayout=layout;
        layout=-1*ones(2*size(tmplayout)-1);
        for k=1:size(neighbors,1)
            [r1,c1]=find(tmplayout==neighbors(k,1));
            [r2,c2]=find(tmplayout==neighbors(k,2));
            rr=mean([2*r1-1 2*r2-1]);
            cc=mean([2*c1-1 2*c2-1]);
            layout(rr,cc)=k;
        end
        clear tmplayout;

        % rereference
        tmpdata=x;
        x=zeros(size(tmpdata,1),size(neighbors,1));
        for k=1:size(neighbors,1)
            x(:,k)=tmpdata(:,neighbors(k,1))-tmpdata(:,neighbors(k,2));
        end
        clear tmpdata;
        
    case 'dtr' % detrend: subtract smooth version of signal
        for k=1:size(x,2)
            %x(:,k)=detrend(x(:,k),'linear',1:200:size(x,1));
            x(:,k)=x(:,k)-smooth(x(:,k),1e3,'sgolay');
        end
        
    otherwise
        error('reref:method','Unknown re-referencing method specified');
end