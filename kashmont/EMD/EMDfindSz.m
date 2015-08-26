%ictal_state = 'Sz' or 'NonSz'
%type = 'Raw' 'CAR' 'DN' or 'DN_CAR'

function EMDfindSz(folderpath,ictal_state)
%% 5 consecutive windows

%
% %load arrays
% % type = {'Raw' 'CAR' 'DN' 'DN_CAR'};
% type = {'CAR'};
% for tp = 1:size(type,2)
%     disp(type{tp})
% files = dir([folderpath '\' ictal_state '\WinData\2HzStop\5wins\' type{tp}, '\NEW\3wins\*.mat']);
%
% for f = 1:length(files)
%     d = load([folderpath '\' ictal_state '\WinData\2HzStop\5wins\' type{tp} '\NEW\3wins\' files(f).name]);
%
%     disp(files(f).name)
%
%     m = fieldnames(d);
%     id = strcmp('IMFperWin',m);
%     IMFperWin = d.(m{id ==1});
%
%     labels.mode = zeros(size(IMFperWin,1),size(IMFperWin,2));
%     labels.avg = zeros(size(IMFperWin,1),size(IMFperWin,2));
%     labels.sd = zeros(size(IMFperWin,1),size(IMFperWin,2));
%
%      for ch = 1:size(IMFperWin,1)
%         %Find the mode of the number of IMFs in the clip
%         imfmode = mode(IMFperWin);
%         imfavg = abs(roundn(nanmean(IMFperWin),-2));
%         imfsd = abs(roundn((std(IMFperWin)),-2))+imfavg;
%
%         %         imfmode(ch,:) = mode(IMFperWin(ch,:));
% %         imfavg(ch,:) = abs(roundn(nanmean(IMFperWin(ch,:)),-2));
% %         imfsd(ch,:) = abs(roundn((1*std(IMFperWin(ch,:))),-2));
% %         imfvar(ch,:) = 1*(roundn(var(IMFperWin(ch,:)),-2));
% %         m(ch,:) = max(IMFperWin(ch,:));
% %         mm(ch,:) = min(IMFperWin(ch,:));
%
%         threshold = [imfmode imfavg imfsd];
%
% % load('E:\data\human CNS\EMD\XLvariables\baseavg.mat')
% % load('E:\data\human CNS\EMD\XLvariables\basestd.mat')
%
%         for id = 1:3
%             clear i ii w n d dd
%
%             % Find what windows have more IMFs than the clip average
%             % Gives T/F response (0/1)
%             i = IMFperWin(ch,:) > threshold(id);
%             d = IMFperWin(ch,:) <= threshold(id);
%
%             % Add found windows together
%             for w = 1:(length(IMFperWin)-4)
%                 ii = i(w) + i(w+1) + i(w+2) + i(w+3);%+ i(w+4);%+i(w+5)+i(w+6)+i(w+7);%+i(w+8)+i(w+9);
%                 winsum(w,:) = ii;
%             end
%
%             % Add nonsz windows together
%             for n = 1:(length(IMFperWin)-4)
%                 dd = d(n) + d(n+1) + d(n+2) + d(n+3);% +d(n+4);%+d(n+5)+d(n+6)+d(n+7)%+d(n+8)+d(n+9);
%                 nonsum(n,:) = dd;
%             end
%
%             %Gives first window number of 5 consecutive windows of increased number of
%             %IMFS (will last all windows during a seizure)
%             [idwin,~] = find (winsum >= 4);
%
%             %Gives first window number of 5 consecutive windows of nonseizure windows
%             [idnon,~] = find (nonsum >= 4);
%
%             %isolates first window of onset within a channel
%             %may be more than one number if multiple increases occur that are separated
%             %by at least 4 windows
%             if isempty(idwin)==0
%                 szwin= idwin(1);
%                 x = 1;
%                 while x < length(idwin)
%                     szid = idwin(x+1) - idwin(x);
%                     if szid > 8
%                         szwin = [szwin idwin(x+1)];
%                     end
%                     x=x+1;
%                 end
%             else szwin = NaN;
%             end
%
%             %Determine if the number of IMFs drops below the threshold for
%             %more than 5 consecutive windows.  If it does, a new seizure onset is identified.  If
%             %not, the increase is considered part of the previous seizure.
%             t=1;
%             szonset = [];
%             for s = 2:length(szwin)
%                 idbreak = find(idnon>szwin(t) & idnon<szwin(s));
%                 if isempty (idbreak)
%                     szonset = [szonset szwin(t)];
%                 else
%                     szonset = [szonset szwin(t) szwin(s)];
%                     t = s;
%                 end
%             end
%
%             %Remove any duplicate onset windows
%             szonset = unique(szonset);
%
%             if id == 1
%                 labels.mode(ch,szonset) = 1;
%             end
%
%             if id == 2
%                 labels.avg(ch,szonset) = 1;
%             end
%
%             if id == 3
%                 labels.sd(ch,szonset) = 1;
%             end
%
%             if isempty(szonset)
%                 szonset = NaN;
%             end
%             %Pad array
%             %Creates a structure of 3 matrices - each is channel x first window of onset in that channel
%             i = 20-length(szonset);
%             if id == 1
%                 EMDonset.mode(ch,:) = padarray(szonset,[0 i],NaN,'post');
%             end
%
%             if id == 2
%                 EMDonset.avg(ch,:) = padarray(szonset,[0 i],NaN,'post');
%             end
%
%             if id == 3
%                 EMDonset.sd(ch,:) = padarray(szonset,[0 i],NaN,'post');
%             end
%
%         end
% end
%         clear imfmode imfavg imfsd threshold
%
% %     end
%
%     save([folderpath '\' ictal_state '\WinData\2HzStop\5wins\' type{tp} '\NEW\test\' files(f).name],'IMFperWin','EMDonset','labels');
% clear labels EMDonset IMFperWin ch
%
% end
% end

%% EMD onset determined at 4 consecutive windows of increased number of IMFs

%Note:  tested both 5 and 4 consecutive windows (and 3 consecutive windows
%at 2 std dev above the mean and 5 consecutive windows with 1 std dev above
%the mean seemed to give best results

sz = [1 5; 6 8; 9 14; 15 24; 25 37; 38 47; 48 62; 63 68]; %seizure
%sz = [1 5; 6 8; 9 14; 15 24; 25 40; 41 50; 51 65; 66 71]; %nonseizure

%load arrays

files = dir(['E:\data\human CNS\EMD\' ictal_state '\WinData\NEW\*.mat']);

for f = 1:length(files)
    d = load(['E:\data\human CNS\EMD\' ictal_state '\WinData\NEW\' files(f).name]);
    clear EMDonset
    
    disp(files(f).name)
    
    m = fieldnames(d);
    idf = strcmp('IMFperWin',m);
    IMFperWin = d.(m{idf ==1});
    
    for s = 1:size(sz,1)
        id(s,:) = f>=sz(s,1) && f<=sz(s,2);
    end
    
    for ch = 1:size(IMFperWin,1)
        %Find the mode of the number of IMFs in the clip
        
        imfavg = ceil(nanmean(IMFperWin(ch,:)));
        imfmode = mode(IMFperWin(ch,:));
        
        %             imfvar = 2*(basevar{id==1}(ch,:))+imfavg;
        %              imfvar = mode(IMFperWin(ch,:));%2*(basestd{id==1}(ch,:))+imfavg;
        if imfavg>imfmode
            imfthresh =imfavg;
        else imfthresh = imfmode;
        end
        
        % 2*std(IMFperWin(ch,:))+imfavg;
        clear i ii w n d dd imfavg imfmode
        
        % Find what windows have more IMFs than the clip average
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
        idc = find(idinc>40);
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
        i = 20-length(szonset);
        EMDonset(ch,:) = padarray(szonset,[0 i],NaN,'post');

        clear szonset szwin idnon szid idbreak idwin imfthresh i x winsum
    end
    
    clear imfsd imfavg
    
    save(['E:\data\human CNS\EMD\' ictal_state '\WinData\NEW\' files(f).name],'IMFperWin','EMDonset');
    clear EMDonset IMFperWin ch
end
end

