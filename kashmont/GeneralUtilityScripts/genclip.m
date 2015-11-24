%This script uses binary counting to extract short time segments (clips)
%from larger EDF files.

%Scripts called:
%edfread.m

% EDF FORMAT SPEC: Source: http://www.edfplus.info/specs/edf.html SEE ALSO:
% http://www.dpmi.tu-graz.ac.at/~schloegl/matlab/eeg/edf_spec.htm
%
% The first 256 bytes of the header record specify the version number of
% this format, local patient and recording identification, time information
% about the recording, the number of data records and finally the number of
% signals (ns) in each data record. Then for each signal another 256 bytes
% follow in the header record, each specifying the type of signal (e.g.
% EEG, body temperature, etc.), amplitude calibration and the number of
% samples in each data record (from which the sampling frequency can be
% derived since the duration of a data record is also known). In this way,
% the format allows for different gains and sampling frequencies for each
% signal. The header record contains 256 + (ns * 256) bytes.

% HEADER RECORD
% 8 ascii : version of this data format (0)
% 80 ascii : local patient identification
% 80 ascii : local recording identification
% 8 ascii : startdate of recording (dd.mm.yy)
% 8 ascii : starttime of recording (hh.mm.ss)
% 8 ascii : number of bytes in header record
% 44 ascii : reserved
% 8 ascii : number of data records (-1 if unknown)
% 8 ascii : duration of a data record, in seconds
% 4 ascii : number of signals (ns) in data record
% ns * 16 ascii : ns * label (e.g. EEG FpzCz or Body temp)
% ns * 80 ascii : ns * transducer type (e.g. AgAgCl electrode)
% ns * 8 ascii : ns * physical dimension (e.g. uV or degreeC)
% ns * 8 ascii : ns * physical minimum (e.g. -500 or 34)
% ns * 8 ascii : ns * physical maximum (e.g. 500 or 40)
% ns * 8 ascii : ns * digital minimum (e.g. -2048)
% ns * 8 ascii : ns * digital maximum (e.g. 2047)
% ns * 80 ascii : ns * prefiltering (e.g. HP:0.1Hz LP:75Hz)
% ns * 8 ascii : ns * nr of samples in each data record
% ns * 32 ascii : ns * reserved

% Following the header record, each of the subsequent data records contains
% 'duration' seconds of 'ns' signals, with each signal being represented by
% the specified (in the header) number of samples. In order to reduce data
% size and adapt to commonly used software for acquisition, processing and
% graphical display of polygraphic signals, each sample value is
% represented as a 2-byte integer in 2's complement format. Figure 1 shows
% the detailed format of each data record.

% DATA RECORD
% nr of samples[1] * integer : first signal in the data record
% nr of samples[2] * integer : second signal
% ..
% nr of samples[ns] * integer : last signal

%Data channels are binned using "records", with "ns" number of signals per
%record

%file = EDF file to be read
%time = Time of interest (clip will be centered on)
%clplen = Clip length, in minutes (the program will approximate the length of the closest record)
%numchan = Number of electrodes patient had

%example: [header,data] = genclip('E:\data\human CNS\Utah\nu\edf\Nu_20090801_101340_1de4','11.00.00',2,129);
%%
function  [header,data] = genclip(file,time,clplen,numchan)
%clear all

flstrt = [];
clpbeg = [];
clpstartrec = [];
l=0;

%Read in the header of the file
%Should end up with file looking like: 'D:\ECoGData\2014PP01\2014PP01_D01.edf'
%\\tsclient\E\
filename = [file '.edf'];
[header] = edfread(filename);

%Pull the number of signals (channels) from the header
ns = header.ns;

%Read total number of channels desired
totch = numchan;

%Scale data (linear scaling)
scalefac = (header.physicalMax - header.physicalMin)./(header.digitalMax - header.digitalMin);
dc = header.physicalMax - scalefac .* header.digitalMax;

%Calculate sampling frequency
Fs = ceil(1/(header.duration/header.samples(1)));

%Calculate the number of records that matches the length of clip
%desired
%Pull the number of samples per record (this assumes all records have the same number of samples)
samps = header.samples(1);

%Divide total number of records desired in half
halfclp = ceil(((clplen*60*Fs)/samps)/2);

%Read the file start time from the header and write it to excel
%sheet
flstrt{end+1} = header.starttime;
%     flstrt_r = sprintf('H%i', r);
%     xlswrite (xlfile,flstrt','Sheet1',flstrt_r);

%convert file start times to number of samples
flhr = str2double(header.starttime(1:2));
flmm = str2double(header.starttime(4:5));
flss = str2double(header.starttime(7:8));
convflstrt = ((flhr*3600) + (flmm*60) + flss)*Fs;

%convert seizure onset times to number of samples
hr = str2double(time(1:2));
mm = str2double(time(4:5));
ss = str2double(time(7:8));

if (hr) < (flhr)
    l = 1;
    hr = hr + 24;
end

convtime = ((hr*3600) + (mm*60) + ss)*Fs;

%Calculate offset (difference between file start time and seizure onset
%time) in number of samples
offset = convtime - convflstrt;

%Determine the record number that matches the onset time
center = ceil(offset/samps);

%Calculate the record to start extracting.  Note this is different
%from the sample
clpstartrec = center - halfclp;

%If the seizure occured too close to the start of the file, the clip will
%start at the beginning of the file.
clpstartrec(clpstartrec<0)=1;

%Calculate the last record to extract.  Note this is different from the
%sample
finrec = center + halfclp;

%Open EDF file for reading only
fid = fopen(filename,'r');

%Read consecutive records for each channel of interest
for ch = 1:ns
    
    %Skip header
    %fseek reads in bytes
    %Each data points consists of 2 bytes
    %Brings cursor to beginning of first record of channel desired
    fseek(fid,((256+(ns * 256))+(samps*2*ch)),'bof');
    
    %Brings cursor to beginning of desired record within the desired
    %channel
    fseek(fid,((samps*2)*ns*(clpstartrec-1)),'cof');
    
    %"r" determines the number of records desired (which correlates to the length of time in each clip)
    r = clpstartrec;
    
    info = ['concatinating records for ch',num2str(ch)];
    disp(info)
    while r < finrec
        rec = fread(fid,(samps),'int16').* scalefac(2) + dc(2);
        clp(r,:) = rec;
        fseek(fid,((samps*2)*(ns-1)),0);
        r = r+1;
    end
    
    d{ch} = clp;
    
end

fclose(fid);

clear clp header

%Reshape cell array into (channel x data) matrix.
%Remove leading zeros (rmzeros is the first data point that is not zero and
%represents the beginning of the clip)
disp('reshaping')
for ch = 1:ns
    disp(ch)
    P(:,ch) = reshape(((d{ch})'),((length(d{ch}))*238),1);
end
clear d
rmzeros = find(P(:,1),1,'first');

for ch = 1:totch
    data(ch,:) = P((rmzeros:end),ch);
end

clpstart = rmzeros;
clpfin = clpstart+size(data,2);

clear P rmzeros

%Determine the sample number associated with the clip start, if the
%sampling began at 00:00:00.
clpstart_samps = convflstrt + clpstart;

%Convert the clip start sample number to a time (24hr clock)
cls_hr = floor((clpstart_samps/Fs)/3600);
cls_mm = floor(((clpstart_samps/Fs)-(cls_hr*3600))/60);
cls_ss = (clpstart_samps/Fs)-(cls_hr*3600)-(cls_mm*60);

if l==1
    cls_hr = cls_hr - 24;
end

clpshr = num2str(cls_hr);
clpsmm = num2str(cls_mm);
clpsss = num2str(cls_ss);

clpbeg = ([clpshr '.' clpsmm '.' clpsss]);

%Create header
header.PatNum = filename(18:25);
header.Day = filename(46:48);
header.Fs = Fs;
header.ClipStartTime = clpbeg;
header.FileStartTime = flstrt;
header.ClipLength = clplen;


%%
% disp('saving')
% %Save the data structure as the patient number created above
% save(['E:\data\human CNS\EMD\' ictal_state '\clips\' patnum '.mat'],'data','header','-v7.3');

clear l Fs clonset clpstart_samps convflstrt convonset fid halfclp offset rec cls_hr cls_mm clp d P ns filename n scalefac samps dc center ch clf_hr clf_mm clf_ss clpfhr clpfin clpfin_samps clpfmm clpfss clpshr clpsmm clpsss clpstart patnum szss szmm szhr sz rmzeros r flmm flhr flss cls_ss cls_mmcls_hr


end
