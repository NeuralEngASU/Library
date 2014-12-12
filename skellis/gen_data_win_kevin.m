% generate data for ecog spatiotemporal analysis
clear all;
close all;
clc;

% set up environment
% use('cleanpath');
% use('pkgs/skellis');
% use('pkgs/chronux');
% use('pkgs/nsx');
% use('pkgs/edf');

% parameters for chronux
chr.pad=0;
chr.trialave=0;
chr.tapers=[3 5];
chr.Fs=1e3;
chr.fpass=[0 500];

% define parameters
% % params.bandstop=[... % kill 60 hz noise
% %     59.2 60.8;...
% %     119.2 120.8;...
% %     179.2 180.8;...
% %     239.2 240.8;...
% %     299.2 300.8;...
% %     359.2 360.8;...
% %     419.2 420.8;...
% %     479.2 480.8;];
params.prebuffer=0.5; % in seconds, extra to read then toss for filtering
params.maxdata=96*150*30e3; % channels*seconds*samplingrate; maximum data to load in at once
params.fs=1e3;
params.detrend=0; % whether or not to detrend the data
params.detrend_win=[2 1]; % win/step size for detrending (see chronux/locdetrend)

% some filter characteristics
Apass=1;   % Passband Ripple (dB)
Astop=20;  % Stopband Attenuation (dB)

% define grids
grids=defgrids;

% loop over grids/sources
for g=1:length(grids)
    grid=grids(g);

    % loop over data files for this grid
    for s=1:length(grid.sources)
        disp(['  grid ' num2str(g) '/' num2str(length(grids)) ' source ' num2str(s) '/' num2str(length(grid.sources))]);
        source=grid.sources(s);

        % set up parallel workers
%         use('parfor',8);

        % load data
        % read out 2x prebuffer (remove one prebuffer for bandstop here
        % remove second prebuffer for bandpass later on
        disp('    loading data');
        [pathstr,basename,ext]=fileparts(source.file);
        if(strcmpi(ext,'.edf'))
            % read the data
            edf=loadEDF(source.file);
            EDF_SR=ceil(edf.Samples(1)/edf.Record_Length);
            tmpdata=readEDF(edf,source.nschans(1),source.block(1)-2*params.prebuffer,source.block(2)+2*params.prebuffer,'s','s');
            raw=zeros(length(tmpdata),length(source.nschans));
            raw(:,1)=tmpdata; clear tmpdata;
            for k=2:length(source.nschans)
                raw(:,k)=readEDF(edf,source.nschans(k),source.block(1)-2*params.prebuffer,source.block(2)+2*params.prebuffer,'s','s');
            end

            % upsample if necessary
            if(fix(params.fs/EDF_SR)>1)
                old=raw;
                raw=zeros(size(old,1)*fix(params.fs/EDF_SR),size(old,2));
                parfor k=1:size(old,2)
                    raw(:,k)=interp(old(:,k),fix(params.fs/EDF_SR));
                end
            end
        elseif(strcmpi(ext,'.ns4mat'))
            % load the data
            fileName = ['20120703-084201-001.ns4mat'];
            humanData = readNSxMat(...
                ['D:\Kevin\SpencerPaper\201203\20120703-084201\', fileName], [1:64]);
            tmp = humanData.header;
            fields=fieldnames(tmp);
%             for f=1:length(fields)
%                 if(size(tmp.(fields{f}),1)>size(tmp.(fields{f}),2) && size(tmp.(fields{f}),2)==source.nschans)
%                     raw=tmp.(fields{f});
%                     break;
%                 end
%             end
            raw = humanData.data';
            fs=tmp.Fs;
            clear tmp;
            clear humanData

            % downsample if necessary
            if(fs>params.fs)
                % low-pass filtering
                Fpass=0.8*params.fs/2;  % Passband Frequency
                Fstop=params.fs/2;      % Stopband Frequency
                parfor k=1:size(raw,2)
                    disp(k);
                    h=fdesign.lowpass(Fpass,Fstop,Apass,Astop,fs);
                    Hd=design(h,'butter','MatchExactly','stopband');
                    raw(:,k)=filtfilt(Hd.sosMatrix,Hd.ScaleValues,raw(:,k));
                end
                raw=raw(1:(fs/params.fs):end,:);
            end
            
            % only allow sizes in multiples of 1 second
            v=size(raw,1)-mod(size(raw,1),params.fs);
            raw=raw(1:v,:);
        else
            ns=nsopen(source.file);

            % set up how much data to read in for each segment
            maxtime=floor(params.maxdata/(source.nschans(2)*ns.fs));
            wins=source.block(1):maxtime:sum(source.block);
            wlens=[diff(wins) sum(source.block)-wins(end)];
            if(wlens(end)==0)
                wlens(end)=[];
                wins(end)=[];
            end

            % loop over windows
            raw=zeros(params.fs*(2*params.prebuffer+source.block(2)),source.nschans(2));
            for w=1:length(wins)
                disp(['      win ' num2str(w) '/' num2str(length(wins)) ...
                    ': ' num2str(wins(w)) 's + ' num2str(wlens(w)) 's']);

                % load in this window's worth of data
                tmpraw=nsread(ns,source.nschans(1),source.nschans(2),wins(w)-2*params.prebuffer,wlens(w)+2*params.prebuffer);
                tmpraw=tmpraw';

                % downsample the data if necessary
                if(ns.fs>params.fs)
                    % low-pass filtering
                    Fpass=0.8*params.fs/2;    % Passband Frequency
                    Fstop=params.fs/2;        % Stopband Frequency
                    parfor k=1:size(tmpraw,2)
                        h=fdesign.lowpass(Fpass,Fstop,Apass,Astop,ns.fs);
                        Hd=design(h,'butter','MatchExactly','stopband');
                        tmpraw(:,k)=filtfilt(Hd.sosMatrix,Hd.ScaleValues,tmpraw(:,k));
                    end
                    tmpraw=tmpraw(1:(ns.fs/params.fs):end,:);
                end

                % only keep the prebuffer if it's the first window
                if(w>1)
                    tmpraw(1:fix(2*params.fs*params.prebuffer),:)=[];
                end

                % add this window to the full dataset
                winstartidx=1;
                if(w>1)
                    winstartidx=params.fs*((w-1)*maxtime+2*params.prebuffer)+1;
                end
                raw( winstartidx : winstartidx+size(tmpraw,1)-1,:)=tmpraw;
                clear tmpraw;
            end
        end

        % remove 60-Hz (and harmonics) noise
        parfor k=1:size(raw,2)
            raw(:,k)=rmlinesmovingwinc(raw(:,k),[2 1],10,chr,0.05);
        end

        % detrend the data
        if(params.detrend)
            raw=locdetrend(raw,params.fs,params.detrend_win);
        end

        % remove DC offset
        parfor k=1:size(raw,2)
            raw(:,k)=raw(:,k)-mean(raw(:,k));
        end

        % % % bandstop filtering
        % % disp('    filtering');
        % % if(source.remln==1)
        % %     for b=1:size(params.bandstop,1)
        % %         parfor k=1:size(raw,2)
        % %             Hd=bsfilt(params.bandstop(b,:),params.fs);
        % %             raw(:,k)=filtfilt(Hd.sosMatrix,Hd.ScaleValues,raw(:,k));
        % %         end
        % %     end
        % % end
        % % raw(1:fix(params.fs*params.prebuffer),:)=[]; % first prebuffer

        % save the data
        disp('    saving');
        save(['D:\Kevin\SpencerPaper\201203\g' num2str(g) 's' num2str(s) '.mat'],'raw','grid','params','-v7.3');

        % clean up (big) variables
        clear raw;

        % clean up parallel workers
        matlabpool close;
    end
end