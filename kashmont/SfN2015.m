
% Use OUTPUT = openNSx(fname, 'read', 'report', 'e:xx:xx', 'c:xx:xx', 't:xx:xx', 'mode', 'precision', 'skipfactor').
%1,2,4,11,16,17,28,29,30,31,32,36,37,38,41,42,43,46,60,62,65,76,83,85,96,120

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