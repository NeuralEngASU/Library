% Assumes the windowed empirical mode decomposition (EMD) algorithm (used in "EMDanaly.m") has been run
% on the data. Opens the files and determines where a seizure happens based
% on the number of intrinsic mode functions (IMFs) generated by EMD.

%Does NOT generate plots.

%ictal_state = 'Sz' or 'NonSz'
%type = 'Raw' 'CAR' 'DN' or 'DN_CAR'

% function EMDfindSz_FullFile(folderpath)
%% EMD onset determined at 4 consecutive windows of increased number of IMFs

%Note:  tested both 5 and 4 consecutive windows (and 3 consecutive windows
%at 2 std dev above the mean and 5 consecutive windows with 1 std dev above
%the mean seemed to give best results

%Load files
files = dir(['E:\data\human CNS\EMD\FullFile\WinData\*.mat']);

for f = 1%:length(files)
    d = load(['E:\data\human CNS\EMD\FullFile\WinData\' files(f).name]);
    clear EMDonset
    
    disp(files(f).name)
    
    m = fieldnames(d);
    idf = strcmp('IMFperWin',m);
    IMFperWin = d.(m{idf ==1});
    
%     for s = 1:size(sz,1)
%         id(s,:) = f>=sz(s,1) && f<=sz(s,2);
%     end
    
    for ch = 1:size(IMFperWin,1)
        
        %Find the mode of the number of IMFs in the clip
        imfmode = mode(IMFperWin(ch,:));
        
        %Find the average of the number of IMFs in the clip
        imfavg = ceil(nanmean(IMFperWin(ch,:)));
        
        %Set the initial threshold based on which value (imfmode or imfavg) is
        %greater
        if imfavg>imfmode
            imfthresh =imfavg;
        else imfthresh = imfmode;
        end
        
        clear i ii w n d dd imfavg imfmode
        
        % Find what windows have more IMFs than the initial threshold
        % Gives T/F response (0/1)
        i = IMFperWin(ch,:) > imfthresh;
        
        %check to see how many instances of i there are
        k = unique(IMFperWin(ch,i==1));
        if isempty(k)==1
            k(1) = NaN;
        end
        for kk=1:size(k,2)
            idinc(kk,:) = sum(IMFperWin(ch,:) == k(kk));
        end
        adj = 40*(size(IMFperWin,2)/300);
        idc = find(idinc>adj);
        if isempty(idc)==1
            imfthresh = imfthresh;
        else
            idc=max(idc);
            imfthresh = k(idc);
        end
        
        clear k idinc idc kk
        l=IMFperWin(ch,:)>imfthresh;
        
        % Add found windows together
        for w = 1:(length(IMFperWin)-4)
            ll = l(w) + l(w+1) + l(w+2)+ l(w+3);%+ l(w+4);
            winsum(w,:) = ll;
        end
        
        %Gives first window number of 4 consecutive windows of increased number of
        %IMFS (will last all windows during a seizure)
        [idwin,~] = find (winsum >= 4);
        
        %isolates first window of onset within a channel
        %may be more than one number if multiple increases occur that are separated
        %by at least 20 windows (1 minute)
        if isempty(idwin)==0
            szwin= idwin(1);
            x = 1;
            while x < length(idwin)
                szid = idwin(x+1) - idwin(x);
                if szid > 20
                    szwin = [szwin idwin(x+1)];
                end
                x=x+1;
            end
        else szwin = NaN;
        end
        
        %Remove any duplicate onset windows
        szonset = unique(szwin);
        
        if isempty(szonset)
            szonset = NaN;
        end
        %Pad array
        %Creates a structure of 3 matrices - each is channel x first window of onset in that channel
        i = 500-length(szonset);
        EMDonset(ch,:) = padarray(szonset,[0 i],NaN,'post');

        clear szonset szwin idnon szid idbreak idwin imfthresh i x winsum
    end
    
    clear imfsd imfavg
    
    save(['E:\data\human CNS\EMD\FullFile\WinData\' files(f).name],'IMFperWin','EMDonset');
    clear EMDonset IMFperWin ch
end
% end