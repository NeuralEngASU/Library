%This script is used to calculate the number of electrographic events
%detected using empirical mode decomposition (EMD)

%% Seizure


files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);
[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');
EMDavg = [];
elecevents = [];

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:10);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    sz = 1;
    allsz.var = [];
    EMDinfo{p}.FN = 0;
    
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)))
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
        
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        s = ~isnan(EMDonset);
        [rs,~] = find(s==0);
        idxx = [];
        
        s =EMDonset(~isnan(EMDonset));
        ss = find(s<200);
     

ee= size(ss,1);
elecevents = [elecevents ee];

EMDoffset = EMDonset - onsetwin(end);
avgoff = nanmean(nanmean(EMDoffset));
EMDavg = [EMDavg (abs(avgoff)*3)];
    end
end


sz = [1 5; 6 8; 9 14; 15 24; 25 37; 38 47; 48 62; 63 68]; %seizure
for p =1:8
    elecpavg(p) = nanmean(elecevents(sz(p,1):sz(p,2)));
    elecpsum(p) = sum(elecevents(sz(p,1):sz(p,2)));
    elecpstd(p) = nanstd(elecevents(sz(p,1):sz(p,2)));
    avg(p) = nanmean(EMDavg(sz(p,1):sz(p,2)));
    stdp(p) = nanstd(EMDavg(sz(p,1):sz(p,2)));
end
ovavg = nanmean(EMDavg);
ovstd = nanstd(EMDavg);

%% Non-Seizure

files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\', '*.mat']);
[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','J3:J100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','H3:H100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','L3:L100');
EMDavg = [];
elecevents = [];

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:13);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
    sz = 1;
    allsz.var = [];

    
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)))
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure

        s =EMDonset(~isnan(EMDonset));
        ss = find(s<200);
     

ee= size(ss,1);
elecevents = [elecevents ee];

    end
end

sz = [1 5; 6 8; 9 14; 15 24; 25 37; 38 47; 48 62; 63 68]; %seizure
for p =1:8
    elecpavg(p) = nanmean(elecevents(sz(p,1):sz(p,2)));
    elecpsum(p) = sum(elecevents(sz(p,1):sz(p,2)));
    elecpstd(p) = nanstd(elecevents(sz(p,1):sz(p,2)));
end
