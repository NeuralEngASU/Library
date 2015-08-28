%figure 1

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
