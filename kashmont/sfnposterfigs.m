
%Figure 1: Show envelopes and extraction of first potential IMF

[hdr, rcd] = edfread('C:\Users\Kari\Downloads\PK4.edf');
sample = rcd(10,(10000:10100));

smth = smooth(sample,3);
avg = mean(smth);
sm = smth - avg;

[maxenv,minenv] = Envelopes(sm);
avgenv=(maxenv+minenv)./2;
sub = sm - avgenv';



figure; 
plot(sm,'k'); hold on; 
plot(maxenv,'g'); 
plot(minenv,'g'); 
plot(avgenv,'r');
legend('Sample Data (x(t))', 'Max Envelope', 'Min Envelope', 'Envelopes Mean(m)');
ylabel('Amplitude');
xlabel('Time');
xlim ([1 100]);
set(gca, 'Ticklength', [0 0])
title('Sample Data (x(t)), Envelopes and Mean of Envelopes (m)');

figure; 
plot(sub,'m'); hold on;
plot(sm,'k');
legend('h','Sample Data (x(t)');
ylabel('Amplitude');
xlabel('Time');
xlim ([1 100]);
ylim ([-80 80]);
set(gca, 'Ticklength', [0 0])
title('Comparison of First Possible IMF (h) and Original Data (x(t))');

figure;
for k = 1:length(imf)
    subplot(2,2,k)
    plot(imf{k})
end



%%

[hdr,rcd] = edfread('\\tsclient\H\2014PP04\2014PP04_D02.edf') ;

for ch = 80:90;
figure; plot(rcd(ch,(5000:600000)));
end

for ch = 2:90
    i = ch-1;
    
    PP04D02S3(i,:) = rcd(ch,(9146000:9446000));
end


save('\\tsclient\H\2014PP04\2014PP04D02S1.mat','PP04D02S1','-v7.3');
save('\\tsclient\H\2014PP04\2014PP04D02S2.mat','PP04D02S2','-v7.3');
save('\\tsclient\H\2014PP04\2014PP04D02S3.mat','PP04D02S3','-v7.3');
save('\\tsclient\H\2014PP04\2014PP04D02S4.mat','PP04D02S4','-v7.3');


for ch = 1:40;
    figure; 
    plot(PP02D02CS2(23,:))
end



%%
%Figure 2:  Raw Data

data = rec(10,:);
normdata = data-mean(data);
figure; 
plot(normdata,'k');
hold on; line([133000 133000], [-4000 4000]);
line([130000 130000], [-4000 4000]);
title('P1 Seizure Clip')
ylabel('Amplitude (uV)')
xlabel('Time(s)')
ylim([-4000 4000])
xlim([0 300000])
legend('kt','line','line')



%%
%Figure 2:  Spectrograms

nfft = 2^nextpow2(500);
ovlp = 40;
window_2 = 50;
[S1,F1,T1,P1] = spectrogram(E10,50,45,nfft,1000); 

%Plot the spectrogram
figure;
imagesc(T1,F1,(10*log10(P1))); 
 caxis([0 60]);
% imagesc(T1,F1,P1); 
axis xy; colorbar; 
h = colorbar;
ylabel(h, 'Power Spectral Density (dB)');
title('P3 Seizure Spectrogram');
xlabel('Time(s)'); 
ylabel('Freq(Hz)');
xlim([0 600])
ylim([0 100])
hold on;line([266 266], [0 250]);
%line([260 260], [0 250]);

params.tapers = [1,5];
params.pad = 2;
params.Fs = 1000;

[S,t,f]=mtspecgramc(E10,[2 1.75],params);

colormap (jet); imagesc(t,f,(10*log10(S)'))



%%
%Figure 2:  IMF windows

% %
figure; plot(wincomp(ch,:),'k.','MarkerSize',15); 
line([133 133], [0 10]);
line([130 130], [0 10]);
%plot(cox,y,'-r', 'MarkerSize', 20);
ylim([0 10]);
xlim([0 300]);
title ('P1 Number of IMFs in Each Window '); 
xlabel ('Window Number'); 
ylabel('Number of IMFs');
legend ('kt','Clinical Onset', 'EMD Onset')


%% Plot each IMF
%
[hdr,rcd] = edfread('E:\data\human CNS\2012PP05\KT_7.edf');
data = rcd(10,(26000:28500));
IMF = EmpModeDecomp(data);
X = IMF{end};
X=X-mean(X(:));

Y = data - mean(data(:));

IMF = EmpModeDecomp(data);

X = IMF{6};
X=X-mean(X(:));

Y = data - mean(data(:));

imf = {Y' IMF{1} IMF{2} IMF{3} IMF{4} IMF{5} X};

figure;
plot(Y','k');
xlim([0 2500]);
ylim([-2500 2500]);
title('Original Signal');
ylabel('Amplitude (uV)');
xlabel('Time (s)')

figure;
plot(IMF{1},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 1');
ylabel('Amplitude (uV)');
xlabel('Time (s)')

figure;
plot(IMF{2},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 2');
ylabel('Amplitude (uV)');
xlabel('Time (s)')

figure;
plot(IMF{3},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 3');
ylabel('Amplitude (uV)');
xlabel('Time (s)');

figure;
plot(IMF{4},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 4');
ylabel('Amplitude (uV)');
xlabel('Time (s)')

figure;
plot(IMF{5},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 5');
ylabel('Amplitude (uV)');
xlabel('Time (s)')

figure;
plot(IMF{6},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 6');
ylabel('Amplitude (uV)');
xlabel('Time (s)')

figure;
plot(IMF{7},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 7');
ylabel('Amplitude (uV)');
xlabel('Time (s)')

figure;
plot(IMF{8},'k');
xlim([0 2500]);
ylim([-2500 2500]);
title('IMF 8 (Residual)');
ylabel('Amplitude (uV)');
xlabel('Time (s)')


for k = 1:length(imf);
    subplot(2,4,k);
    plot(imf{k},'k');
    xlim([0 2500]);
    ylim([-2500 2500]);
end



for ch = 40:80%size(PP01D02BS1,1)
    figure;
    plot(PP05D02BS10(ch,:))
    
end
