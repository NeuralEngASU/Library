
% files = dir(['/Users/kariashmont/Desktop/Data/WinData/2HzStop/CAR/', '*.mat']);
% load('/Users/kariashmont/Desktop/EMD/XLvariables/clpstrt.mat')
% load('/Users/kariashmont/Desktop/EMD/XLvariables/clonset.mat')
% load('/Users/kariashmont/Desktop/EMD/XLvariables/Fs.mat')


files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);
load('E:\data\human CNS\EMD\XLvariables\clpstrt.mat')
load('E:\data\human CNS\EMD\XLvariables\clonset.mat')
load('E:\data\human CNS\EMD\XLvariables\Fs.mat')
load('E:\data\human CNS\EMD\XLvariables\sznum.mat')
% xlfile =  'E:\data\human CNS\EMDDatabase.xlsx';
% Fs = xlsread(xlfile,'NonSz','H3:H100');
% sznum = xlsread(xlfile,'NonSz','E3:E100');


for f = 1:size(files,1)
    patnum{f} = files(f).name(1:10);
%         patnum{f} = files(f).name(1:13);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end
% 
% for f = 1:size(files,1)
%     iddot = strfind(files(f).name,'.');
%     patnum{f} = files(f).name(1:(iddot-1));
% end

%% Detection based on all channels (regardless of grid)


load('E:\data\human CNS\EMD\XLvariables\baseavg.mat')
load('E:\data\human CNS\EMD\XLvariables\basestd.mat')

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
%         filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    for f = c(1):c(end)
        
        %         load(['/Users/kariashmont/Desktop/Data/WinData/2HzStop/CAR/',files(f).name]);
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']);
        
        %clonset - clpstrt to determine offset of seizure onset within clip
        onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs(f);
        clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs(f);
        offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
        offsetwin(f,:) = floor((offsetsamps(f,:)/Fs(f))/3);
        %
        winavg = nanmean(IMFperWin);
        %         d = diff(winavg);
        %         %[~,m] = max(d);
        %         avgd = nanmean(d);
        %         sdd = 2*std(d);
        %         upd = avgd+(1*sdd);
        %         lowd = avgd-(1*sdd);
        %
                avg = nanmean(winavg);
                [~,m] = max(winavg);
                SD = 2*nanmean(std(IMFperWin));
                upper = avg+(2*SD);
                lower = avg-(2*SD);

        emdonset{f} = find(winavg>=upper); %| winavg<=lower);
        if isempty (emdonset{f} == 1)
            emdonset{f} = NaN;
        end
        %
        %         emdonsetd{f} = find(d>=upd); %| winavg<=lower);
        %         if isempty (emdonsetd{f} == 1)
        %             emdonsetd{f} = NaN;
        %         end
        %
        figure;
        %         subplot(2,1,1);
        plot(winavg); ylim([0 10]);
        title(sprintf( '%s', ptnum{p}));
        line([0 size(IMFperWin,2)], [upper upper], 'Color', [0.6,0.6,0.6]);
        line([0 size(IMFperWin,2)], [lower lower], 'Color', [0.6,0.6,0.6]);
        line([0 size(IMFperWin,2)], [avg avg], 'Color', [0,0,0]);
        line([emdonset{f}(1) emdonset{f}(1)], [0 10], 'Color', 'r')
        %         line([m m], [0 10], 'Color', [0.6,0.6,0.6])
        line([offsetwin(f) offsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
        
        %         subplot(2,1,2); plot(d);
        %         title(sprintf( '%s', ptnum{p}));
        %         line([0 size(IMFperWin,2)], [upd upd], 'Color', [0.6,0.6,0.6]);
        %         line([0 size(IMFperWin,2)], [lowd lowd], 'Color', [0.6,0.6,0.6]);
        %         line([0 size(IMFperWin,2)], [avgd avgd], 'Color', [0,0,0]);
        %         line([emdonsetd{f}(1) emdonsetd{f}(1)], [-5 5], 'Color', 'r')
        %         %line([m m], [-5 5], 'Color', 'r')
        %
        %         line([offsetwin(f) offsetwin(f)], [-5 5], 'Color', 'k', 'LineStyle' ,'--')
        
        clear SD avg lower upper winavg sdd avgd lowd upd d m name
        pltinfo ={'.b' '.r' '.g' '.k' '.m' '.c' '+b' '+r' '+g' '+k' '+m' '+c' 'ob' 'or' 'og' 'ok' 'om' 'oc'};
        
        
    end
    %     figure;
    %
    %     for ii = 1:size(c,2)
    %         cent{ii} = emdonset{c(ii)} - offsetwin(c(ii));
    %         y = 1:size(cent{ii},2);
    %
    %         plot(cent{ii},y,pltinfo{ii})
    %         title(sprintf( '%s', ptnum{p}));
    %         xlim([-150 150])
    %         hold on;
    %     end
    
    
end



%% Detection based on channels - separated by grid

grids{1} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90; 91 94; 95 98]; %2012PP05
grids{2} = [1 64; 65 80; 81 96; 97 104; 105 112; 113 118]; %2013PP01
grids{3} = [1 64; 65 80; 81 96; 97 102; 103 108; 109 114; 115 120]; %2014PP01
grids{4} = [1 64; 65 70; 71 76; 77 82; 83 88; 89 94]; %2014PP02
grids{5} = [1 64; 65 70; 71 76; 77 84; 85 89]; %2014PP04
grids{6} = [1 64; 65 68; 69 74; 75 78; 79 82; 83 88]; %2014PP05
grids{7} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90]; %2014PP06
grids{8} = [1 16; 17 32; 33 52; 53 72; 73 78; 79 84; 85 90]; %2014PP07

load('E:\data\human CNS\EMD\XLvariables\baseavg.mat')
load('E:\data\human CNS\EMD\XLvariables\basestd.mat')
load('E:\data\human CNS\EMD\XLvariables\basevar.mat')
load('E:\data\human CNS\EMD\XLvariables\basemode.mat')


for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
%     filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    for f = c(1):c(end)
        figure;
        
        %         load(['/Users/kariashmont/Desktop/Data/WinData/2HzStop/CAR/',files(f).name]);
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']);
        
        %clonset - clpstrt to determine offset of seizure onset within clip
        onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs(f);
        clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs(f);
        offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
        offsetwin(f,:) = floor((offsetsamps(f,:)/Fs(f))/3);
        
        for g = 1:size(grids{p})
            %             gstdavg(g,:) = nanmean(basestd{g}((grids{p}(g,1):grids{p}(g,2)),:))
            gwinavg(g,:) = nanmean(IMFperWin((grids{p}(g,1):grids{p}(g,2)),:));
            
            avg = abs(nanmean(gwinavg(g,:)));
            [~,m] = max(gwinavg(g,:));
            SD = abs(std(gwinavg(g,:)));
            upper = avg+(2*SD);
            lower = avg-(2*SD);

            gwinavg(g,(1:3))=0;
            gwinavg(g,(end-3:end))=0;
            
            
            imfonset{f} = find(gwinavg(g,:)>=upper); %| winavg<=lower);
            if isempty (imfonset{f} == 1)
                imfonset{f} = NaN;
            end
            
            % Find what windows have more IMFs than the clip average
            % Gives T/F response (0/1)
            i = gwinavg(g,:) > upper;
            
            % Add found windows together
            for w = 1:(length(IMFperWin)-3)
                ii = i(w) + i(w+1) + i(w+2);%+ i(w+3);%+ i(w+4);
                winsum(w,:) = ii;
            end
            
            [idwin,~] = find (winsum >= 3);
            
            if isempty(idwin)==0
                szwin= idwin(1);
                x = 1;
                while x < length(idwin)
                    szid = idwin(x+1) - idwin(x);
                    if szid > 6
                        szwin = [szwin idwin(x+1)];
                    end
                    x=x+1;
                end
            else szwin = NaN;
            end
            
            %             emdonsetd{f} = find(d(g,:)>=upd(g,:)); %| winavg<=lower);
            %             if isempty (emdonsetd{f} == 1)
            %                 emdonsetd{f} = NaN;
            %             end
            %
            subplot(size(grids{p},1),1,g);
            plot(gwinavg(g,:)); ylim([0 10]);
            title(sprintf( '%s Grid %d', ptnum{p},g));
            line([0 size(IMFperWin,2)], [upper upper], 'Color', [0.6,0.6,0.6]);
            line([0 size(IMFperWin,2)], [lower lower], 'Color', [0.6,0.6,0.6]);
            line([0 size(IMFperWin,2)], [avg avg], 'Color', [0,0,0]);
            line([szwin(1) szwin(1)], [0 10], 'Color', 'r')
            line([offsetwin(f) offsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
            %             hold on;
            %
        end
        %         subplot(2,1,2); plot(gd);
        %         title(sprintf( '%s', ptnum{p}));
        %         line([0 size(IMFperWin,2)], [upd upd], 'Color', [0.6,0.6,0.6]);
        %         line([0 size(IMFperWin,2)], [lowd lowd], 'Color', [0.6,0.6,0.6]);
        %         line([0 size(IMFperWin,2)], [avgd avgd], 'Color', [0,0,0]);
        %         line([emdonsetd{f}(1) emdonsetd{f}(1)], [0 5], 'Color', [0.6, 0.6, 0.6])
        %         line([m m], [0 5], 'Color', 'r')
        
        %             line([offsetwin(f) offsetwin(f)], [0 5], 'Color', 'k', 'LineStyle' ,'--')
        
        clear SD avg lower upper winavg sdd avgd lowd upd d m szwin w gwinavg g
        
    end
    
end


%% Only plot grid containing channel of onset and show rate of change

grids{1} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90; 91 94; 95 98]; %2012PP05
grids{2} = [1 64; 65 80; 81 96; 97 104; 105 112; 113 118]; %2013PP01
grids{3} = [1 64; 65 80; 81 96; 97 102; 103 108; 109 114; 115 120]; %2014PP01
grids{4} = [1 64; 65 70; 71 76; 77 82; 83 88; 89 94]; %2014PP02
grids{5} = [1 64; 65 70; 71 76; 77 84; 85 89]; %2014PP04
grids{6} = [1 64; 65 68; 69 74; 75 78; 79 82; 83 88]; %2014PP05
grids{7} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90]; %2014PP06
grids{8} = [1 16; 17 32; 33 52; 53 72; 73 78; 79 84; 85 90]; %2014PP07

gg = [1 1 1 1 1 1 4 4 4 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 3 3 3 1 1 1 1 4 3 3 3 3 3 4 4 7 7 7 5 5 1];

load('E:\data\human CNS\EMD\XLvariables\baseavg.mat')
load('E:\data\human CNS\EMD\XLvariables\basestd.mat')

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    for f = c(1):c(end)
        figure;
        
        %         load(['/Users/kariashmont/Desktop/Data/WinData/2HzStop/CAR/',files(f).name]);
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\2HzStop\CAR\',name{1},'_CAR_Win.mat']);
        
        %clonset - clpstrt to determine offset of seizure onset within clip
        onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs(f);
        clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs(f);
        offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
        offsetwin(f,:) = floor((offsetsamps(f,:)/Fs(f))/2);
        
        %for g = 1:size(grids{p})
        gwinavg = nanmean(IMFperWin((grids{p}(gg(f),1):grids{p}(gg(f),2)),:));
        
        %         gd = diff(gwinavg);
        %         [~,m] = max(gd);
        %         avgd = nanmean(gd);
        %         sdd = roundn(std(gd),-2);
        %         upd = avgd+(2*sdd);
        %         lowd = avgd-(2*sdd);
        
        avg = baseavg{p};
        [~,mm] = max(gwinavg);
        SD = basestd{p};
        chupper = avg+(1*SD);
        lower = avg-(1*SD);
        
        gwinavg(:,(1:3)) = 0;
        gwinavg(:,(end-3:end))=0;
        
        idonset{f} = find(gwinavg>=chupper); % | gwinavg<=lower);
        emdonset{f} = idonset{f}(find(idonset{f}>2 & idonset{f}<size(gwinavg,2)-2));
        if isempty (emdonset{f} == 1)
            emdonset{f} = NaN;
        end
        
        %         emdonsetd{f} = find(gd>=upd); %| winavg<=lower);
        %         if isempty (emdonsetd{f} == 1)
        %             emdonsetd{f} = NaN;
        %         end
        
        %         subplot(2,1,1);
        plot(gwinavg); ylim([0 10]);
        title(sprintf( '%s Grid %d', patnum{f},gg(f)));
        line([0 size(IMFperWin,2)], [chupper chupper], 'Color', [0.6,0.6,0.6]);
        line([0 size(IMFperWin,2)], [lower lower], 'Color', [0.6,0.6,0.6]);
        line([0 size(IMFperWin,2)], [avg avg], 'Color', [0,0,0]);
        line([emdonset{f}(1) emdonset{f}(1)], [0 10], 'Color', 'r')
        line([offsetwin(f) offsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
        %             line([mm mm], [0 10], 'Color', [0.6, 0.6, 0.6],'LineStyle','--')
        hold on;
        
        %         subplot(2,1,2); plot(gd);
        %         line([0 size(IMFperWin,2)], [upd upd], 'Color', [0.6,0.6,0.6]);
        %         line([0 size(IMFperWin,2)], [lowd lowd], 'Color', [0.6,0.6,0.6]);
        %         line([0 size(IMFperWin,2)], [avgd avgd], 'Color', [0,0,0]);
        %         line([emdonsetd{f}(1) emdonsetd{f}(1)], [-5 5], 'Color', 'r');
        %         line([m m], [-5 5], 'Color', [0.6, 0.6, 0.6])
        %
        %         line([offsetwin(f) offsetwin(f)], [-5 5], 'Color', 'k', 'LineStyle' ,'--')
        
        clear SD avg lower upper winavg sdd avgd lowd upd gd m
        
    end
    clear gwinavg g
end
% end


%% Channel by channel with baseline threshold

load('E:\data\human CNS\EMD\XLvariables\onsetchans.mat')
load('E:\data\human CNS\EMD\XLvariables\baseavg.mat')
load('E:\data\human CNS\EMD\XLvariables\basestd.mat')

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    sz=1;
    for f = c(1):c(end)
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\2HzStop\CAR\NEW\',name{1},'_CAR_Win.mat']);
        
        %clonset - clpstrt to determine offset of seizure onset within clip
        onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs(f);
        clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs(f);
        offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
        offsetwin(f,:) = floor((offsetsamps(f,:)/Fs(f))/3);
        
        cc = ~isnan(onsetchans{p});
        cx = find(cc(sz,:)==1);
        
        for ch = 1:size(cx,2)
            chan = onsetchans{p}(sz,ch);
            
            %                 chavg = baseavg{p}(chan(end),:);
            chavg = nanmean(IMFperWin(chan,:));
            IMFperWin(chan,(1:5)) = NaN;
            IMFperWin(chan,(end-5:end)) = NaN;
            chstd = basestd{p}(chan,:);
            
            chupper = chavg+(chstd);
            chlower = chavg-(chstd);
            
            i = IMFperWin(chan,:)>chupper; %| winavg<=lower);
            
            for w = 1:(size(IMFperWin,2)-4)
                ii = i(w) + i(w+1) + i(w+2) + i(w+3);%+ i(w+4);%+i(w+5)+i(w+6)+i(w+7);%+i(w+8)+i(w+9);
                winsum(w,:) = ii;
            end
            
            
            %Gives first window number of 5 consecutive windows of increased number of
            %IMFS (will last all windows during a seizure)
            [idwin,~] = find (winsum >= 4);
            if isempty(idwin)
                idwin = NaN;
            end
            
            figure;
            plot(IMFperWin(chan,:),'.');
            ylim([0 10]);
            title(sprintf( '%s %d Ch %d', ptnum{p},sz,chan));
            line([0 size(IMFperWin,2)], [chupper chupper], 'Color', [0.6,0.6,0.6]);
            line([0 size(IMFperWin,2)], [chlower chlower], 'Color', [0.6,0.6,0.6]);
            line([0 size(IMFperWin,2)], [chavg chavg], 'Color', [0,0,0]);
            line([idwin(1) idwin(1)], [0 10], 'Color', 'r')
            line([offsetwin(f) offsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
            
            clear chstd chavg chlower chupper idwin winsum i ii chan
        end
        sz=sz+1;
        clear IMFperWin chavg chstd cc cx
    end
    clear sz
end

%%
grids{1} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90; 91 94; 95 98]; %2012PP05
grids{2} = [1 64; 65 80; 81 96; 97 104; 105 112; 113 118]; %2013PP01
grids{3} = [1 64; 65 80; 81 96; 97 102; 103 108; 109 114; 115 120]; %2014PP01
grids{4} = [1 64; 65 70; 71 76; 77 82; 83 88; 89 94]; %2014PP02
grids{5} = [1 64; 65 70; 71 76; 77 84; 85 89]; %2014PP04
grids{6} = [1 64; 65 68; 69 74; 75 78; 79 82; 83 88]; %2014PP05
grids{7} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90]; %2014PP06
grids{8} = [1 16; 17 32; 33 52; 53 72; 73 78; 79 84; 85 90]; %2014PP07

gg = [1 1 1 1 1 1 4 4 4 3 3 3 3 3 3 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 3 3 3 1 1 1 1 4 3 3 3 3 3 4 4 7 7 7 5 5 1];

load('E:\data\human CNS\EMD\XLvariables\baseavg.mat')
load('E:\data\human CNS\EMD\XLvariables\basestd.mat')

for p = 1%:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    for f = c(1):c(end)
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\2HzStop\CAR\NEW\',name{1},'_CAR_Win.mat']);
        
        %clonset - clpstrt to determine offset of seizure onset within clip
        onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs(f);
        clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs(f);
        offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
        offsetwin(f,:) = floor((offsetsamps(f,:)/Fs(f))/3);
        
        gwinavg = nanmean(IMFperWin((grids{p}(gg(f),1):grids{p}(gg(f),2)),:));
        
        gavg = nanmean(baseavg{p}(grids{p}(gg(f),1):grids{p}(gg(f),2)));
        gstd = nanmean(basestd{p}(grids{p}(gg(f),1):grids{p}(gg(f),2)));
        
        gupper = gavg+(2*gstd);
        glower = gavg-(2*gstd);
        
        emdonset{f} = find(gwinavg>=gupper); %| winavg<=lower);
        if isempty (emdonset{f} == 1)
            emdonset{f} = NaN;
        end
        
        figure;
        plot(gwinavg); ylim([0 10]);
        title(sprintf( '%s Grid %d', ptnum{p},gg));
        line([0 size(IMFperWin,2)], [gupper gupper], 'Color', [0.6,0.6,0.6]);
        line([0 size(IMFperWin,2)], [glower glower], 'Color', [0.6,0.6,0.6]);
        line([0 size(IMFperWin,2)], [gavg gavg], 'Color', [0,0,0]);
        line([emdonset{f}(1) emdonset{f}(1)], [0 10], 'Color', 'r')
        line([offsetwin(f) offsetwin(f)], [0 10], 'Color', 'k', 'LineStyle' ,'--')
        
        clear chstd chavg chlower chupper
    end
    
    clear gwinavg g
end


%%% subplot(3,1,2)
%Plot the spectrogram
% imagesc(T1,F1,(10*log10(P1))); 
% caxis([0 60]);
% colormap(jet);
% axis xy; colorbar; 
% h = colorbar;
% ylabel(h, 'Power Spectral Density (dB)');
% title('Patient 1 Seizure 7 Channel 26 Spectrogram');
% xlabel('Time(s)'); 
% ylabel('Freq(Hz)');
% % xlim([0 600])
% ylim([0 150])
% line([135500/500 135500/500], [0 150],'Color','k','LineWidth', 2);
figure;
params.tapers=[3 5];
params.pad = 2;
params.Fs = 500;
[S,t,f]=mtspecgramc(x(ch,:),[2 1.75],params);
% subplot(9,10,ch)
colormap (jet); imagesc(t,f,(10*log10(S)'));axis xy;
% ylim([0 150])
colorbar;
%  caxis([25 50]);