function EMDfindSz

for ch = 1:size(IMFperWin,1)
%Find the mode of the number of IMFs in the clip
imfmode = mode(IMFperWin(ch,:));
imfavg = nanmean(IMFperWin(ch,:));
imfthird = length(IMFperWin(ch,:)/3);

% Find what windows have more IMFs than the clip average
% Gives T/F response (0/1)
i = IMFperWin(ch,:) > imfmode;
d = IMFperWin(ch,:) <= imfmode;

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

for s = 2:length(szwin)
    sz = s-1;
    idbreak = find(idnon>szwin(sz) & idnon<szwin(s));
end
    
if isempty (idbreak) == 0
    
    
    
    
    
    
    
    
    
    for x = 1:10
    i = wincomp == x;
    ii(x) = sum(i);
end
%100 is 1/3 of total windows per clip
[r,c] = find(ii(x)>100);