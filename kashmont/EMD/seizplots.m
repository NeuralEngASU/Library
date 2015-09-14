%% Seizure

clear all

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');


files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);

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
        
        s = isnan(EMDonset);
        [rs,~] = find(s==0);
        idxx = [];
        
        tt=1;
        for t = 5:(size(IMFperWin,2))-5
            [idch,~] = find(EMDonset >= t-5 & EMDonset < t+5);
            ss(tt,:) = size(idch,1);
            tt=tt+1;
        end
        
        id = find (ss>=7);
        if isempty(id)
            idxx = NaN;
            ii = NaN;
            idx = NaN;
        else
            for i = 1:size(id,1)-1
                ii(i) = id(i+1)-id(i);
            end
        clear i
        iii = find(ii>20);
        if isempty(iii)
            idxx = id(1);
        else
            idxx = id(1);
            for j = 1:size(iii,2)
            idxx = [idxx id(iii(j)+1)];
            end
        end
        for jj = 1:size(idxx,2)
            k(jj) = abs(idxx(jj)) - onsetwin(f);
            kk(jj) = abs(k(jj)+5);
        end
        
        [~,c] = min(kk);
        
        idx = idxx(c)+5;
        end

        clear i ii iii c idxx
                
%         figure;
%         subplot(2,1,2)
%         plot(ss)
%         xlim([0 200])
%         hold on;
%         plot([idx idx],[0 100])
%         hold off;
        
        
%         subplot(3,1,3)
%         plot([0 0],[0 30],'color','k','LineWidth',1.25);
%         hold on;
%         h = histogram(center,20,'BinLimits',[-100 100],'FaceColor',[0 0 0.7],'FaceAlpha',1);
%         [~,jj] = find(h.Values>=5,1);
%         if isempty(jj)==1
%             j = NaN;
%         else j=h.BinEdges(jj)+(.5*h.BinWidth);
%         end
%         plot([j j], [0 30],'color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',1.25);
%         ylabel('Number of Onsets')
%         xlabel({'Time(min)','Relative to Clinical Onset'})
%         xlim([-100 99])
%         hold off;
%         
%         subplot(2,1,1)
%         plot([onsetwin(f) onsetwin(f) ],[0 121],'color','k','LineWidth',1.25);
%         hold on;
%         plot([idx idx], [0 121],'color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',1.25);
%         legend ('Clinical Onset','EMD Onset')
%         plot(EMDonset(rs,:),rs,'.','color',[0 0 0.7],'MarkerSize',10)
%         title(sprintf('Seizure 2',p))
%         title({sprintf('P%d Sz%d Onsets Detected by EMD',p,sz),'  ',})
%         ylabel('Electrode Number','FontName','TimesNewRoman','FontSize',12)
%         xlim([0 200])
%         ylim([0 121])
%         hold off;

        if isnan(idx)
            x = NaN;
            EMDinfo{p}.onsett(sz,:) = NaN;
            EMDinfo{p}.FN = EMDinfo{p}.FN+1;
            offset = NaN;
            avgoffset = NaN;
        else
                [ch,r] = find (EMDonset>=idx-5 & EMDonset<idx+15,1);
                [x,~]=find(EMDonset == EMDonset(ch,r));
                
                offset = idx - onsetwin(f);
        end
        
        EMDinfo{p}.onsett(sz,:) = idx;
        EMDinfo{p}.offset(sz,:) = offset;
        if isnan(offset)
            avgoffset = NaN;
        else
        avgoffset = nanmean(abs(offset));
        offavg = nanmean(offset);
        end
       
        if isempty(x)
           
            x = NaN;
        end
        ii = 50-size(x,1);
        EMDinfo{p}.onsetch(sz,:) = padarray(x,[ii 0],NaN,'post');
        EMDinfo{p}.avgoffset = nanmean(avgoffset);
        EMDinfo{p}.offavg = nanmean(offavg);
        
        sz = sz+1;
        clear offset avgoffset ch r x i chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt
    end
    clear sz
end
        
    sd = []
for p = 1:8
    stand = nanstd(abs(EMDinfo{p}.offset*3));
    sd = [sd stand];
end

%% Non-Seizure

clear all

Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','H3:H100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','E3:E100');

files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\', '*.mat']);

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
    NonSzinfo{p}.FP = 0;   
    sz = 1;
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)))
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
        
        s = isnan(EMDonset);
        [rs,~] = find(s==0);
        
        tt=1;
        for t = 5:(size(IMFperWin,2))-5
            [idch,~] = find(EMDonset >= t-5 & EMDonset < t+5);
            ss(tt,:) = size(idch,1);
            tt=tt+1;
        end
        
%         ti = [-100:199];%linspace(-(size(ss,1)/2),size(ss,1)/2); %[-85:85];
        idx = (find (ss>=7,1))+5;
        if isempty(idx)
            idx = NaN;
        end
        
        figure;
        subplot(2,1,2)
        plot(ss)
        xlim([0 200])
        hold on;
        plot([idx idx],[0 50])
%         plot([0 200],[10 10])
        hold off;
        
        
% %         plot([0 0],[0 30],'color','k','LineWidth',1.25);
%         hold on;
%         h = histogram(EMDonset,20,'BinLimits',[0 199],'FaceColor',[0 0 0.7],'FaceAlpha',1);
%         [~,jj] = find(h.Values>=5,1);
%         if isempty(jj)==1
%             j = NaN;
%         else j=h.BinEdges(jj)+(.5*h.BinWidth);
%         end
%         plot([j j], [0 30],'color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',1.25);
%         ylabel('Number of Onsets')
%         xlabel({'Time(min)','Relative to Clinical Onset'})
%         xlim([0 199])
%         ylim([0 30])
%         hold off;
               
        
        subplot(2,1,1)
        plot([idx idx], [0 121],'color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',1.25);
        hold on;
        plot(EMDonset(rs,:),rs,'.','color',[0 0 0.7],'MarkerSize',10)
        title(sprintf('Seizure 2',p))
        title({sprintf('P%d NonSz%d Onsets Detected by EMD',p,sz),'  ',})
        ylabel('Electrode Number')
        xlim([0 199])
        ylim([0 121])
        hold off;
        
        if isnan(idx)
            x = NaN;
            NonSzinfo{p}.onsett(:,sz) = NaN;
        else
            [ch,r] = find (EMDonset>=idx,1);
            [x,~]=find(EMDonset == EMDonset(ch,r));
            NonSzinfo{p}.onsett(:,sz) = EMDonset(ch,r);
            NonSzinfo{p}.FP = NonSzinfo{p}.FP+1;
        end
        if isempty(x)
            x = NaN;
        end
        i = 130-size(x,1);
        NonSzinfo{p}.onsetch(:,sz) = padarray(x,[i 0],NaN,'post');
        
        sz = sz+1;
        clear ch r x i chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt EMDonset
    end
    clear sz 
end

%% unused pieces of code

%         s = isnan(center);
%         [rs,~] = find(s==0);
%         chavg = nanmean(IMFperWin(rs,:));
%         avg = nanmean(chavg);
%         sd = (std(chavg))+avg;
%         subplot(3,1,3)
%         plot(chavg)
%         title(sprintf('Patient %d Sz %d',p,sz));
%         ylim([0 10])
%         line([onsetwin(f) onsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
%         line([0 size(chavg,2)], [avg avg], 'Color', 'k')
%         line([0 size(chavg,2)], [sd sd], 'Color', [0.6 0.6 0.6])

%         s = isnan(center);
%         [rs,~] = find(s==0);
%         chavg = nanmean(IMFperWin(rs,:));
%         avg = nanmean(chavg);
%         sd = (std(chavg))+avg;
%         subplot(3,1,3)
%         plot(chavg)
%         title(sprintf('Patient %d Sz %d',p,sz));
%         ylim([0 10])
%         line([onsetwin(f) onsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
