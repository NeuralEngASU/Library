%ictal_state = 'Sz' or 'NonSz'
%type = 'Raw' 'CAR' 'DN' or 'DN_CAR'

function EMDfindSz(folderpath,ictal_state,type)

files = dir([folderpath '\' ictal_state '\WinData\' type , '/*.mat']);

for f = 1:length(files)
    d = load([folderpath '\' ictal_state '\WinData\' type,'\',files(f).name]);
    
    disp(files(f).name)
    
    m = fieldnames(d);
    IMFperWin = d.(m{1});
    
    for ch = 1:size(IMFperWin,1)
        %Find the mode of the number of IMFs in the clip
        imfmode = mode(IMFperWin(ch,:));
        imfavg = ceil(nanmean(IMFperWin(ch,:)));
        imfsd = (std(IMFperWin(ch,:)))+(nanmean(IMFperWin(ch,:)));
        
        threshold = [imfmode imfavg imfsd];
        
        for id = 1:3
            clear i ii w n d dd
            
            % Find what windows have more IMFs than the clip average
            % Gives T/F response (0/1)
            i = IMFperWin(ch,:) > threshold(id);
            d = IMFperWin(ch,:) <= threshold(id);
            
            % Add found windows together
            for w = 1:(length(IMFperWin)-4)
                ii = i(w) + i(w+1) + i(w+2) + i(w+3);
                winsum(w,:) = ii;
            end
            
            % Add nonsz windows together
            
            for n = 1:(length(IMFperWin)-4)
                dd = d(n) + d(n+1) + d(n+2) + d(n+3);
                nonsum(n,:) = dd;
            end
            
            %Gives first window number of 4 consecutive windows of increased number of
            %IMFS (will last all windows during a seizure)
            [idwin,~] = find (winsum >= 4);
            
            %Gives first window number of 4 consecutive windows of nonseizure windows
            [idnon,~] = find (nonsum >= 4);
            
            %isolates first window of onset within a channel
            %may be more than one number if multiple increases occur that are separated
            %by at least 4 windows
            if isempty(idwin)==0
                szwin= idwin(1);
                x = 1;
                while x < length(idwin)
                    szid = idwin(x+1) - idwin(x);
                    if szid > 8
                        szwin = [szwin idwin(x+1)];
                    end
                    x=x+1;
                end
            else szwin = NaN;
            end
            
            %Determine if the number of IMFs drops below the threshold for more than 4
            %consecutive windows.  If it does, a new seizure onset is identified.  If
            %not, the increase is considered part of the previous seizure.
            t=1;
            szonset = [];
            for s = 2:length(szwin)
                idbreak = find(idnon>szwin(t) & idnon<szwin(s));
                if isempty (idbreak)
                    szonset = [szonset szwin(t)];
                else
                    szonset = [szonset szwin(t) szwin(s)];
                    t = s;
                end
            end
            
            
            %Remove any duplicate onset windows
            szonset = unique(szonset);
            
            if isempty(szonset)
                szonset = NaN;
            end
            
            
            %Pad array
            i = 20-length(szonset);
            if id == 1
                EMDonset.mode(ch,:) = padarray(szonset,[0 i],NaN,'post');
            end
            
            if id == 2
                EMDonset.avg(ch,:) = padarray(szonset,[0 i],NaN,'post');
            end
            
            if id == 3
                EMDonset.sd(ch,:) = padarray(szonset,[0 i],NaN,'post');
            end
            
        end
        
        clear imfmode imfavg imfsd threshold
        
    end
    
    save([folderpath '\' ictal_state '\WinData\' type '\' files(f).name],'IMFperWin','EMDonset');
    
end
