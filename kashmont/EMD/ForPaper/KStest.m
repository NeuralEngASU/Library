% Two-Sample Kolmogorow-Smirnov test


%%  Create seizure 1 min clips 5 windows before on seizure onset only on onset electrodes
%To perform KS with average across onset electrodes detected by EMD during seizure only

files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\*.mat']);
load('E:\data\human CNS\EMD\XLvariables\EMDinfo.mat')
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');

idf = [1 5; 6 8; 9 14; 15 24; 25 37; 38 47; 48 62; 63 68]; %seizure

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
    
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)))
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure

        if isnan(EMDinfo{p}.onsett(sz,:))
            szKS(f,:) = NaN;
            ch{f} = NaN;
        else
                t = EMDinfo{p}.onsett(sz,:);
                [s,~] = find (EMDonset>=(t-5) & EMDonset<(t+35));
                if t+35<=size(IMFperWin,2)
                    i = IMFperWin(s,((t-5):(t+35)));
                    ch{f} = s;
                else
                    ii = IMFperWin(s,(t:end));
                    i= padarray(ii,[0 41-size(ii,2)],NaN,'post');
                    ch{f} = s;
                end
                szKS(f,:) = nanmean(i);
        end
        sz = sz+1;
        clear  t i ii
    end
    clear h jj j i c
end

%% 

%create nonseizure 1 minute subclips from center of file only on channels
%used for sz clips
files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\*.mat']);
for f = 1:length(files)
    load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\' files(f).name]);
    
    if isnan(ch{f})
        nonKS(f,:) = NaN;
    else
    idmid = ceil(size(IMFperWin,2)/2);
    chimfs(1,:) = [IMFperWin(ch{f}(1),(idmid-20:idmid+20))];
        for c = 2:size(ch{f},1)
        chimfs = [chimfs; IMFperWin(ch{f}(c),(idmid-20:idmid+20))];
        end
        nonKS(f,:) = nanmean(chimfs,1);
        clear chimfs idmid
    end
end
  
%% non seizure, all electrodes
files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\*.mat']);
for f = 1:length(files)
   
    load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\' files(f).name]);
    
    idmid = ceil(size(IMFperWin,2)/2);
    
    nonKS(f,:) = nanmean(IMFperWin(:,(idmid-20:idmid+20)));
    clear idmid
end


%%  KS 

for f = 1:68
    
    if isnan(szKS(f,1))==1;
        KS(f,:) =0;
        Prob(f,:) = 0;
        k(f,:) = 0;
    else
        [h,p,ks2stat] = kstest2(szKS(f,:),nonKS(f,:),'Alpha',0.005);
        
        KS(f,:) = h;
        Prob(f,:) = p;
        k(f,:) = ks2stat;
        
        g(f,:) = [KS(f,:) szKS(f,1)];
        
    end
end

clear ch
for ch = 1:size(idf,1)
    pval{ch} = nanmean(Prob(idf(ch,1):idf(ch,2)));
    kstat{ch} = nanmean(k(idf(ch,1):idf(ch,2)));
end

%% KS between non-seizure clip FPs and non-seizure activity