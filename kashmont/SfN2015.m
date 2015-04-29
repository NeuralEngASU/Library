
% Use OUTPUT = openNSx(fname, 'read', 'report', 'e:xx:xx', 'c:xx:xx', 't:xx:xx', 'mode', 'precision', 'skipfactor').
%1,2,4,11,16,17,28,29,30,31,32,36,37,38,41,42,43,46,60,62,65,76,83,85,96,120

<<<<<<< HEAD
%clip1 = 670000:6670000;
%clip2 = 650000:6650000;

MicroClip1 = openNSx('E:\data\human CNS\201101\20110323-185852\20110323-185852-001.ns4','read','t:670000:6670000','sample');
MicroClip2 = openNSx('E:\data\human CNS\201101\20110323-185852\20110323-185852-002.ns4','read','t:650000:6650000','sample');

clip{1} = double(MicroClip1.Data);
clip{2} = double(MicroClip2.Data);

ch = [63 64 65 66 67 75 76 77 78 79 85 86 87 88 89 96 97 98 99 100 107 108 109 110 111 118 119 120 121 122];

%% downsample
for i = 1:size(clip,2)
    d = clip{i};
    for j = 1:size(ch,2)
        ds_d(i,j,:) = downsample(d(ch(j),:),(10000/1000));
    end
end

%% Sum micro signals
for i = 1:size(clip,2)
       
        linear_sum = sum(ds_d)
   
end

t1 = linspace(1,size(d,2),size(ds_d,2));
t2 = linspace(1,size(d,2),size(d,2));
figure; plot(t2,d); hold on; plot(t1,ds_d,'r')
  
        
% %% Creating downsample object
%         %dsFs = desired/downsampled frequency
%         dsFs = 1000;
%         d = double(MicroClip1.Data);
%         
%         dsFs = MicroClip1.MetaTags.SamplingFreq / round(MicroClip1.MetaTags.SamplingFreq / dsFs);
%         if MicroClip1.MetaTags.SamplingFreq > dsFs
%             N = 10;         % order
%             Fpass = dsFs/4; % Passband frequency
%             Apass = 1;      % Passband ripple (dB)
%             Astop = 80;     % Stopband attenuation (dB)
%             h = fdesign.lowpass('N,Fp,Ap,Ast',N,Fpass,Apass,Astop,MicroClip1.MetaTags.SamplingFreq);
%             Hd = design(h,'ellip');
%         else
%             fprintf('Cannot downsample to this frequency, %d.\nChoose a different value.\n', dsFs)
%             return
%         end % END IF
% 
%         if dsFlag
%             tempChan = filtfilt(Hd.sosMatrix,Hd.ScaleValues,tempChan);
%             tempChan = tempChan(1:round(data.MetaTags.SamplingFreq/dsFs):end);
%         end

%% Creating downsample object

%
%dsFs = desired/downsampled frequency



    dsFs = data.MetaTags.SamplingFreq / round(data.MetaTags.SamplingFreq / dsFs);
    if data.MetaTags.SamplingFreq > dsFs
        N = 10;         % order
        Fpass = dsFs/4; % Passband frequency
        Apass = 1;      % Passband ripple (dB)
        Astop = 80;     % Stopband attenuation (dB)
        h = fdesign.lowpass('N,Fp,Ap,Ast',N,Fpass,Apass,Astop,data.MetaTags.SamplingFreq);
        Hd = design(h,'ellip');
    else
        fprintf('Cannot downsample to this frequency, %d.\nChoose a different value.\n', dsFs)
        return
    end % END IF




if dsFlag
    tempChan = filtfilt(Hd.sosMatrix,Hd.ScaleValues,tempChan);
    tempChan = tempChan(1:round(data.MetaTags.SamplingFreq/dsFs):end);
end


%% Extract clips from Utah patient 2011 clinical EDF file

[header,rcd] = edfread('E:\data\human CNS\201101\20110323-185852\Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf');

%Mclip1
data = rcd(:,(27000000:28000000));
hdr.patient = 'Utah Patient 2011'
hdr.parentfile = 'Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf'
hdr.parentfilestarttime = '14.23.03'
hdr.parentfiledate = '23.03.11'
hdr.Fs = '1000'
hdr.clipsamplerange = '27000000 to 28000000'
hdr.clipstarttime = '21.53.03'

save('E:\data\human CNS\201101\Mclip1.mat','data','hdr');
%start at sample 350000 to get start of Ns4 file

%Mclip2
data = rcd(:,(34000000:36000000));
hdr.patient = 'Utah Patient 201101'
hdr.parentfile = 'Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf'
hdr.parentfilestarttime = '14.23.03'
hdr.parentfiledate = '23.03.11'
hdr.Fs = '1000'
hdr.clipsamplerange = '34000000 to 36000000'
hdr.clipstarttime = '23.49.43'

save('E:\data\human CNS\201101\Mclip2.mat','data','hdr');
%start at sample 552000 to get start of Ns4 file

%% xcorr

E9 = data(9,:);
E10 = data(10,:);
E6 = data(6,:);

[C9,lag1] = xcorr(E9,E10);
[C6,lag2] = xcorr(E6,E10);

figure
subplot(2,1,1);
plot(lag1,C9/max(C9));
ylabel('C9');
grid on
title('Cross-Correlations')
subplot(2,1,2);
plot(lag2,C6/max(C6));
ylabel('C6');
grid on
xlabel('Samples')

[~,I1] = max(abs(C9));     % Find the index of the highest peak
[~,I2] = max(abs(C6));     % Find the index of the highest peak
t9 = lag1(I1)              % Time difference between the signals s2,s1
t6 = lag2(I2)              % Time difference between the signals s3,s1

pad = zeros(abs(t9),1);
E9b = [pad' E9];
%E9 = E9(t109:end);
%E11 = E11(t1011:end);

figure
ax(1) = subplot(311);
plot(E10);
grid on;
title('E10');
axis tight
ax(2) = subplot(312);
plot(E9b);
grid on;
title('E9b');
axis tight
ax(3) = subplot(313);
plot(E11);
grid on;
title('E11');
axis tight
linkaxes(ax,'xy')

%% Correlation Coeff

Emat = [E9b(1:size(E10,2))' E10' E11'];

R = corrcoef(Emat);


