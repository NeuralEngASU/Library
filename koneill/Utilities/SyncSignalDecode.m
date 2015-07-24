%% Sync Signal Decode

%% EDF Read
filePath = 'D:\Data\HumanECoG\2015PP01\2015PP01_D02B_Sz1.edf';

[Header, data] = edfread(filePath);

syncData = data(1,:);
%%

Fs = ceil(Header.samples(1)/Header.duration);

MaxSyncTSLength = 4.3*Fs; % Units samples. Timestamps in sync signal are 43 bits long and sent at a rate of 10 Hz.
MinSyncTSPeriod = 10*Fs; % Units samples. Timestamps in sync signal can have a minimum period of 10 sec.
BitLength = 0.1*Fs; % Units samples.

% Finding voltages (Values) for each timestamp (TS) in the SyncSignal
params.Fs = Fs;
params.eventGap = 3; % [seconds] Gap threshold between event groups
eventIdx = FindStepEvents(syncData, params);
%%
strMat = [];
% loop over each event
for ii = 1:size(eventIdx,2)-1
    testEvent = eventIdx{ii};
    testEvent = testEvent-testEvent(1)+1;
    if size(testEvent,2) <= 2
        timeStamp{ii} = nan;
    else
        
        signal = zeros(1, MaxSyncTSLength);
        % Calculate bit length
        bitLen = diff(testEvent(1:2))/10;
        
        for jj = 1:2:size(testEvent,2)
            if jj+1>size(testEvent,2)
                signal(testEvent(jj):end) = 1;
            else
                signal(testEvent(jj):testEvent(jj+1)) = 1;
            end
        end
        
        signal2 = reshape(signal, 50, 43);
        syncBits = round(mean(signal2,1));
        if syncBits(end) == 0
            disp(ii)
            syncBits = ~syncBits;
        end
        syncBitsStr = num2str(fliplr(syncBits(:,12:end))')';
        syncBitsStr = syncBitsStr(1:3:size(syncBitsStr,1),:);
        syncSec = bin2dec(syncBitsStr);
        
        strMat = [strMat;syncBitsStr];
        
        % Convert from Labview to Matlab time (64800 represents seconds in 18 hours)
Labview2MatlabOffset = etime(datevec('01-01-1904 00:00:00','mm-dd-yyyy HH:MM:SS'),datevec('01-01-0000 00:00:00','mm-dd-yyyy HH:MM:SS')) + 64800;
% SyncTSDays = (SyncTSSec + Labview2MatlabOffset)/86400;


        labViewTime = datenum('19040101 00:00:00', 'yyyymmdd HH:MM:SS');
        expTime = (Labview2MatlabOffset + syncSec)/8.64e4;
        matlabTime = datenum('0000101 00:00:00', 'yyyymmdd HH:MM:SS');
        offset = labViewTime - matlabTime;
        
        SyncTSDateVec(ii,:) = datevec(expTime);
        
%         expTime = offset + syncSec/8.64e4;
%         matlabTime = datenum('0000', 'yyyy');
%         timeRef = datenum('1970', 'yyyy'); % Setup a reference date (Jan-1 1970)
%         startTimeMatlab = timeRef + tsqStartTimeStamp / 8.64e4; % Convert the tsqStartTimeStamp into days and add the days to the reference date
%         startTimeMatlab = startTimeMatlab - 7/24; % Arizona time is GMT-7:00
%         startTimeMatlabString = datestr(startTimeMatlab, 'yyyymmdd HH:MM:SS'); % Convert to string

        timeMat(ii) = expTime;

        timeStamp{ii} = expTime;
    end   
end % END FOR

for kk = 1:size(timeStamp,2)
    if ~isnan(timeStamp{kk})
        disp(datestr(timeStamp{kk}, 'yyyymmdd HH:MM:SS'))
    end
end

%%

[SyncIdxs, SyncMS] = PulseCounter(SyncSignal,Fs,10000);
SyncTSStartIdxs = SyncIdxs([1,find(diff(SyncIdxs)>MaxSyncTSLength)+1])';
SyncTSStartIdxsMat = repmat(SyncTSStartIdxs,1,MaxSyncTSLength) + repmat(0:MaxSyncTSLength-1,size(SyncTSStartIdxs,1),1);
SyncTSValues = SyncSignal(SyncTSStartIdxsMat);

% Finding the voltage values at the middle of each 200 sample bit (43 total)
SyncTSBits = SyncTSValues(:,100:BitLength:MaxSyncTSLength-100)>10000;

% Converting to decimal
SyncTSBitsStr = num2str(fliplr(SyncTSBits(:,12:end))')';
SyncTSBitsStr = SyncTSBitsStr(1:3:size(SyncTSBitsStr,1),:);
SyncTSSec = bin2dec(SyncTSBitsStr);

% Convert from Labview to Matlab time (64800 represents seconds in 18 hours)
Labview2MatlabOffset = etime(datevec('01-01-1904 00:00:00','mm-dd-yyyy HH:MM:SS'),datevec('01-01-0000 00:00:00','mm-dd-yyyy HH:MM:SS')) + 64800;
SyncTSDays = (SyncTSSec + Labview2MatlabOffset)/86400;
SyncTSDateVec = datevec(SyncTSDays);

% Saving to Structure
for k=1:size(SyncTSDateVec,1)    
    SyncStruct(k).Date = SyncTSDateVec(k,:);
    SyncStruct(k).Samples = SyncTSStartIdxs(k);
    SyncStruct(k).Seconds = SyncTSStartIdxs(k)/Fs;            
end