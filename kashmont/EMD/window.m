% This function windows Empirical Mode Decomposition (EMD) through a data set.

%P = patient
%Fs = sampling frequency
%WinLen = length of window, in seconds
%OvLp = length of desired overlap, in seconds---read paper about optimal overlap as a starting point and cite


%%

function [wincomp] = window(data,Fs,ch,WinLen,OvLp)

%calculate the number of samples (data points) in one window
winsamp = WinLen*Fs;
ovlplth = OvLp*Fs;

wincomp=[];

m=1;
n=m+winsamp;
numIMF=0;

while n<length(data)
    
    comps = EMD(data(m:n),Fs);
    
    numIMF(end+1) = length(comps);
    
    m=n-ovlplth;
    n=m+winsamp;
    
end

wincomp(ch,:) = numIMF;
      
end

% %%
% figure; plot(wincomp(ch,:),'k.','MarkerSize',15);
% % line([133 133], [0 10]);
% % line([130 130], [0 10]);
% %plot(cox,y,'-r', 'MarkerSize', 20);
% ylim([0 10]);
% xlim([0 300]);
% title ('P1 Sz7 Ch10 Number of IMFs in Each Window ','FontSize',14,'FontName','arial');
% xlabel ('Window Number','FontSize',14,'FontName','arial');
% ylabel('Number of IMFs','FontSize',14,'FontName','arial');
%
% hold on;
% plot(140,7,'r.','MarkerSize',20);
% %legend ('kt','Clinical Onset', 'EMD Onset')
% %
% % %line=214500,
% % figure; plot(KT4.data(10,:)); hold on; plot()
% %
% % cox = 134;
% % y = 0:.001:10;
% % emdx = 130;
% % %
% % figure;
% % h = plot(winIMF(10,:),'.k')
% % set(h, 'Markersize','3');
% % hold on;plot(cox,y, '-r')
% % plot(emdx,y,'-k');
% % ylim([0 10]);
% % title ('Number of IMFs in Each Window ');
% % xlabel ('Window Number');
% % ylabel('Number of IMFs');

