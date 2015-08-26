%raster plot of EMD detected onset times vs. channels of detected
%onsets, centered on clinically determined onset time with different
%seizures in different colors

%Raster by window number
%EMDraster('E:\data\human CNS\EMD','E:\data\human CNS\EMDDatabase.xlsx','Sz')
%function EMDraster(folderpath, xlfile,ictal_state)
%
% %load number of sampling frequency from excel file
% %Read seizure onset and clip start times, clinical onset channel and sampling rate from excel file

%%
clear all

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');


%Seizure
files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:10);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

pltinfo = {'.b' '.r' '.g' '.c' '.m' '.k' '+b' '+r' '+g' '+c' '+m' '+k' 'ob' 'or' 'og' 'oc' 'om' 'ok'};
threshold = {'mode' 'avg' 'var'};

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allsz = [];
    
    figure;
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
                
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        
        allsz = [allsz,center];
                
        s = isnan(center);
        [rs,~] = find(s==0);
        
        subplot(3,1,1)
        plot(center(rs,:),rs,pltinfo{sznum(f)})
        title(sprintf('Seizure 2',p))
%         title({sprintf('Patient %d All Seizure Onsets Detected',p),'  ','EMD Onset Raster - All Seizures'})
%         xlabel('Window Relative to Clinically Determined Seizure Onset')
        ylabel('Channels')
        line([0 0],[0 121],'LineStyle','--','Color',[0 0 0]);
        xlim([-100 100])
        ylim([0 100])
        hold on;
        
        clear rm ra rs
        
        ww = 1;
        for w = -100:100
            [rs,~] = find(center == w);
            id{ww} = rs;
            ws(ww,:) =size(rs,1);
            ww = ww+1;
        end
        
        total{p}(f,:)= ws;
        clear rm ra rs
        
        y = [-100:1:100];
        plt = {'b' 'r' 'g' 'c' 'm' 'k' '--b' '--r' '--g' '--c' '--m' '--k' '-.b' '-.r' '-.g' '-.c' '-.m' '-.k'};
        
        subplot(3,1,3)
        plot(y,ws,plt{sznum(f)});
        hold on;
        title('Number of Onsets Detected per Seizure')
        xlabel('Window Relative to Clinically Determined Seizure Onset')
        ylabel('Number of Onsets Detected')
        xlim([-100 100])
        ylim([0 25])
        line([0 0],[0 121],'LineStyle','--','Color',[0 0 0]);        
        hold on;
        
        clear EMDonset
        
    end
    
    tt=-100:5:100;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allsz > tt(t)& allsz < tt(t+1));
        ss(t,:) = size(idch,1);
    end

    subplot(3,1,2)
    h = histogram(allsz,20,'BinLimits',[-100 100],'FaceColor',[0 0 0.7],'FaceAlpha',1);
%     edgess = [-95:5:94];
%     bar(edgess,ss);
%     title('Total Number of Onsets Detected')
    ylabel('Number of Onsets')
    xlabel('Window Relative to Clinically Determined Seizure Onset')
    xlim([-100 100])
%     ylim([0 100])
    line([0 0],[0 121],'LineStyle','--','Color',[0 0 0]);

    
%     cs = ~isnan(allsz);
%     chanss =sum(cs,2);
%     subplot(4,1,4)
%     edgess = [1:size(chanss,1)];
%     barh(edgess,chanss);
%     title('Number of Onsets Detected Per Channel')
%     ylabel('Channel')
%     xlabel('Number of Onsets Detected')
%     ylim([0 121])
%     xlim([0 20])
%     
    hold off;
    
    clear allsz tt t ss edgess
end


%%  Non-Seizure
clear all

load('E:\data\human CNS\EMD\XLvariables\clpstrt.mat')
load('E:\data\human CNS\EMD\XLvariables\clonset.mat')
load('E:\data\human CNS\EMD\XLvariables\onsetchans.mat')

pltinfo = {'.b' '.r' '.g' '.c' '.m' '.k' '+b' '+r' '+g' '+c' '+m' '+k' 'ob' 'or' 'og' 'oc' 'om' 'ok'};
threshold = {'mode' 'avg' 'var'};

%Nonseizure
files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\', '*.mat']);

xlfile =  'E:\data\human CNS\EMDDatabase.xlsx';
Fs = xlsread(xlfile,'NonSz','H3:H100');
sznum = xlsread(xlfile,'NonSz','E3:E100');

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:13);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddot = strfind(files(f).name,'.');
    patnum{f} = files(f).name(1:(iddot-1));
end

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allsz = [];
    
     figure;
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',name{1},'_CAR_Win.mat']); %nonseizure
                
        allsz = [allsz,EMDonset];
        s = isnan(EMDonset);
        [rs,~] = find(s==0);
        
        subplot(3,1,1)
        plot(EMDonset(rs,:),rs,pltinfo{sznum(f)})
        title(sprintf('Non-Seizure 2'))
%         xlabel('Time (min)')
        ylabel('Channels')
        line([0 0],[0 121],'LineStyle','--','Color',[0 0 0]);
        xlim([0 199])
        ylim([0 100])
        hold on;
        
        clear rm ra rs
        
        ww = 1;
        for w = 1:199
            [rs,~] = find(EMDonset == w);
            id{ww} = rs;
            ws(ww,:) =size(rs,1);
            ww = ww+1;
        end
        
        total{p}(f,:)= ws;
        clear rm ra rs
        
        y = [0:1:199];
        plt = {'b' 'r' 'g' 'c' 'm' 'k' ':b' ':r' ':g' ':c' ':m' ':k' '-.b' '-.r' '-.g' '-.c' '-.m' '-.k'};
        
        subplot(3,1,3)
        plot(y,ws,plt{sznum(f)});
        hold on;
        title('Number of Onsets Detected per Seizure')
        xlabel('Window Relative to Clinically Determined Seizure Onset')
        ylabel('Number of Onsets Detected')
        xlim([0 199])
        ylim([0 25])
        hold on;
        
        clear EMDonset
        
    end
    
    tt=1:5:199;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allsz > tt(t)& allsz < tt(t+1));
        ss(t,:) = size(idch,1);
    end

    subplot(3,1,2)
    h = histogram(allsz,20,'BinLimits',[-100 100],'FaceColor',[0 0 0.7],'FaceAlpha',1);
%     edgess = [1:5:199];
%     bar(edgess,ss);
%     title('Total Number of Onsets Detected')
    ylabel('Number of Onsets')
    xlabel('Time (min)')
    xlim([0 199])
    ylim([0 100])
    

    hold off;
    
    clear allsz tt t ss edgess
end



%% EMD detected onset channels


% sz = [1 6; 7 9; 10 15; 16 24; 25 40; 41 50; 51 58; 59 64];
sz = [1 5; 6 8; 9 14; 15 23; 24 39; 40 49; 50 57; 58 63];
% Total onsets per channel, per seizure
for p=1:8
    id{p} = sum(total{p},2);
    % totsz{p}= sum()
end


%onset closest to clinically determined onset
[idt,idch] = sort(abs(center))

for p = 1:size(ptnum,2)
    %     filecomp{p} = strncmp(ptnum(p),patnum,8);
    filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allsz = [];
    
    figure;
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        %         load(['E:\data\human CNS\EMD\NonSz\WinData\2HzStop\5wins\CAR\NEW\',name{1},'_CAR_Win.mat']);
        load(['E:\data\human CNS\EMD\NonSz\WinData\2HzStop\5wins\CAR\NEW\3wins\',name{1},'_CAR_Win.mat']);
        
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        [idt,idch]=sort(abs(center));
        chans = find(idt == idt(1));
        
        % NOTE: Plots only show -97 to 97 on x-axis to ensure that any false positives caused by end effect of EMD are not shown.
        plt = {'b' 'r' 'g' 'c' 'm' 'k' ':b' ':r' ':g' ':c' ':m' ':k' '-.b' '-.r' '-.g' '-.c' '-.m' '-.k'};
        
        for i = 1:size(chans,1)
        subplot(1,size(chans,1),i)
        plot(IMFperWin(idch(chans),:),'.');
        ylim([0 10])
        hold on;
        title('Number of Onsets Detected per Seizure')
        xlabel('Window Relative to Clinically Determined Seizure Onset')
        ylabel('Number of Onsets Detected')
        line([szwin(1) szwin(1)], [0 10], 'Color', 'r')
        end

        
         line([0 size(IMFperWin,2)], [chupper chupper], 'Color', [0.6,0.6,0.6]);
            line([0 size(IMFperWin,2)], [lower lower], 'Color', [0.6,0.6,0.6]);
            line([0 size(IMFperWin,2)], [avg avg], 'Color', [0,0,0]);
            line([szwin(1) szwin(1)], [0 10], 'Color', 'r')
            line([offsetwin(f) offsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
        
        clear EMDonset
        
    end
        
    hold off;
    
    clear allsz tt t ss edgess
end