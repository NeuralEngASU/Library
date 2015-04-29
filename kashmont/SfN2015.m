
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
=======
data = openNSx('D:\Kari\201101\20110323-185852\20110323-185852-001.ns4','read','t:1:10000','sample');

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


Mclip1 = rcd(:,(27000000:28000000));
