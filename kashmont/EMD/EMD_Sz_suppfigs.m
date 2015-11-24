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

figure;
pp=1;
for p = 7:8
    
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allsz.var = [];
    
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
                
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        allsz.var = [allsz.var,center];
                
        s = isnan(center);
        [rs,~] = find(s==0);
        
        subplot(3,2,pp);
%         set(subplot(3,1,1),'Position',[0.13 0.709 0.6 0.25]);
        plot([0 0],[0 121],'color','r','LineWidth',1);
        hold on;
        plot(center(rs,:),rs,pltinfo{sznum(f)})
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 120])
        set(gca,'ytick',[0 25 50 75 100]);
        set(gca,'yticklabel',{'0' '' '50' '' '100'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
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
        
       subplot(3,2,(pp+2));
%         set(subplot(3,1,2),'Position',[0.13 0.409 0.6 0.25])
%         subplot(3,1,2)
        plot([0 0],[0 30],'color','r','LineWidth',1);
        hold on;
        plot(y,ws,plt{sznum(f)});
        hold on;
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
        set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 30])
        set(gca,'ytick',[0 5 10 15 20 25])
        set (gca,'yticklabel',{'0' '' '' '' '' '25'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear EMDonset
        
    end
    
    tt=-100:5:100;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allsz.var > tt(t)& allsz.var < tt(t+1));
        ss(t,:) = size(idch,1);
    end
    
   subplot(3,2,(pp+4));
%     set(subplot(3,1,3),'Position',[0.13 0.11 0.6 0.25]);
%     set(gca,'Position',[0.13 0.11 0.6 0.25])
%     subplot(3,1,3)
    plot([0 0],[0 200],'color','r','LineWidth',1);
    hold on;
    h = histogram(allsz.var,20,'BinLimits',[-100 100],'FaceColor',[0 0 0],'FaceAlpha',1);
    xlim([-100 100]) 
    set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',{'-5' '' '' '' '' '0' '' '' '' '' '5'});
    set(gca,'ytick',[0 50 100 150 200]);
    set(gca,'yticklabel',{'0' '' '100' '' '200'});
    set (gca,'TickLength',[0.01 0.01]);
    
    clear allsz tt t ss edgess
    
    pp=pp+1;
end


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

%%
pltinfo = {'.b' '.r' '.g' '.c' '.m' '.k' '+b' '+r' '+g' '+c' '+m' '+k' 'ob' 'or' 'og' 'oc' 'om' 'ok'};
threshold = {'mode' 'avg' 'var'};
pt=5;
for p = 5:8
    
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allsz.var = [];
    
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
                
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        allsz.var = [allsz.var,center];
                
        s = isnan(center);
        [rs,~] = find(s==0);
        
        subplot(3,2,(pt+4));
%         set(subplot(3,1,1),'Position',[0.13 0.709 0.6 0.25]);
        plot([0 0],[0 121],'color','r','LineWidth',1);
        hold on;
        plot(center(rs,:),rs,pltinfo{sznum(f)})
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 120])
        set(gca,'ytick',[0 25 50 75 100]);
        set(gca,'yticklabel',{'0' '' '50' '' '100'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
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
        
       subplot(6,4,(pt+12));
        plot([0 0],[0 30],'color','r','LineWidth',1);
        hold on;
        plot(y,ws,plt{sznum(f)});
        hold on;
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
        set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 30])
        set(gca,'ytick',[0 5 10 15 20 25])
        set (gca,'yticklabel',{'0' '' '' '' '' '25'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear EMDonset
        
    end
    
    tt=-100:5:100;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allsz.var > tt(t)& allsz.var < tt(t+1));
        ss(t,:) = size(idch,1);
    end
    
   subplot(6,4,(pt+16));
    plot([0 0],[0 200],'color','r','LineWidth',1);
    hold on;
    h = histogram(allsz.var,20,'BinLimits',[-100 100],'FaceColor',[0 0 0],'FaceAlpha',1);
    xlim([-100 100]) 
    set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',{'-5' '' '' '' '' '0' '' '' '' '' '5'});
    set(gca,'ytick',[0 50 100 150 200]);
    set(gca,'yticklabel',{'0' '' '100' '' '200'});
    set (gca,'TickLength',[0.01 0.01]);
    
    clear allsz tt t ss edgess
    
    pt=pt+1;
end


