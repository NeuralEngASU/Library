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

%Drive = Location of file to be read in (give only letter)
%xlfile = Path to Excel file containing seizure information (in form 'D:\Kari\ECoG\Patient Database.xlsx')
%clplen = Clip length, in minutes (the program will approximate the length of the closest record)
%ictal_state = either 'Sz' or 'NonSz'
%%
function [flstrt,clpbeg,clpend] = clip(drive,xlfile,ictal_state,clplen)
%clear all

flstrt = [];
clpbeg = [];
clpend = [];
clpstartrec = [];
finrec = [];

%Open excel file and read filenames and seizure numbers into array 'clpnum'

[~,clpnum] = xlsread(xlfile,ictal_state,'A3:A4');
[~,day] = xlsread(xlfile,ictal_state,'E3:E4');
%sznum = xlsread(xlfile,ictal_state,'E3:E4');
%
% [~,clpnum] = xlsread(xlfile,ictal_state,'A3:A4');
% [~,day] = xlsread(xlfile,ictal_state,'D3:D4');
% sznum = xlsread(xlfile,ictal_state,'E3:E4');

%Loop through array 'clpnum' to open each file and form the clips
for n = 1:length(clpnum)
    l = 0;
    
    %Read in the header of the file
    %Should end up with file looking like: 'D:\ECoGData\2014PP01\2014PP01_D01.edf'
    %\\tsclient\E\
    filename = [drive '\' clpnum{n} '\' clpnum{n} '_' day{n} '.edf'];
    disp (filename)
    [header] = edfread(filename);
    
    %Pull the number of signals (channels) from the header
    ns = header.ns;
    
    %Read total number of channels from excel file
    totch = xlsread(xlfile,ictal_state,'O3:O4');
    
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
    convflstrt(n,:) = ((flhr*3600) + (flmm*60) + flss)*Fs;
    
    %load seizure onset times from excel file
    %     [~,clonset] = xlsread(xlfile,ictal_state,'L9:L10');
    [~,clonset] = xlsread(xlfile,ictal_state,'L3:L7');
    %
    %     if (clonset{n}(1:2)) < (flstrt{1}(1:2))
    %         new_hr = str2double(clonset{n}(1:2)) + 24;
    %         clonset{n}(1:2) = num2str(new_hr);
    %     end
    
    %convert seizure onset times to number of samples
    szhr = str2double(clonset{n}(1:2));
    szmm = str2double(clonset{n}(4:5));
    szss = str2double(clonset{n}(7:8));
    
    %         %convert seizure onset times to number of samples
    %     szhr = str2double(clonset(1:2));
    %     szmm = str2double(clonset(4:5));
    %     szss = str2double(clonset(7:8));
    
    if (szhr) < (flhr)
        l = 1;
        szhr = szhr + 24;
    end
    
    convonset(n,:) = ((szhr*3600) + (szmm*60) + szss)*Fs;
    
    %Calculate offset (difference between file start time and seizure onset
    %time) in number of samples
    offset(n,:) = convonset(n) - convflstrt(n);
    
    %Determine the record number that matches the onset time
    center = ceil(offset(n)/samps);
    
    %Calculate the record to start extracting.  Note this is different
    %from the sample
    clpstartrec(n,:) = center - halfclp;
    
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
        fseek(fid,((samps*2)*ns*(clpstartrec(n,:)-1)),'cof');
        
        %"r" determines the number of records desired (which correlates to the length of time in each clip)
        r = clpstartrec(n,:);
        
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
    
    for ch = 1:totch(n)
        data(ch,:) = P((rmzeros:end),ch);
    end
    
    clpstart(n,:) = rmzeros;
    clpfin(n,:) = clpstart(n,:)+size(data(n,:),2);
    
    clear P rmzeros
    
    clear P rmzeros
    
    %Determine the sample number associated with the clip start, if the
    %sampling began at 00:00:00.
    clpstart_samps(n,:) = convflstrt(n,:) + clpstart(n,:);
    
    %Convert the clip start sample number to a time (24hr clock)
    cls_hr(n,:) = floor((clpstart_samps(n,:)/Fs)/3600);
    cls_mm(n,:) = floor(((clpstart_samps(n,:)/Fs)-(cls_hr(n,:)*3600))/60);
    cls_ss(n,:) = (clpstart_samps(n,:)/Fs)-(cls_hr(n,:)*3600)-(cls_mm(n,:)*60);
    
    if l==1
        cls_hr(n,:) = cls_hr(n,:) - 24;
    end
    
    clpshr = num2str(cls_hr(n,:));
    clpsmm = num2str(cls_mm(n,:));
    clpsss = num2str(cls_ss(n,:));
    
    clpbeg{end+1} = ([clpshr '.' clpsmm '.' clpsss]);
    
    %Determine the sample number associated with the clip end, if the
    %sampling began at 00:00:00.
    clpfin_samps(n,:) = convflstrt(n,:) + clpfin(n,:);
    
    %Convert the clip start sample number to a time (24hr clock)
    clf_hr(n,:) = floor((clpfin_samps(n,:)/Fs)/3600);
    clf_mm(n,:) = floor(((clpfin_samps(n,:)/Fs)-(clf_hr(n,:)*3600))/60);
    clf_ss(n,:) = (clpfin_samps(n,:)/Fs)-(clf_hr(n,:)*3600)-(clf_mm(n,:)*60);
    
    if l==1
        clf_hr(n,:) = clf_hr(n,:) - 24;
    end
    
    clpfhr = num2str(clf_hr(n,:));
    clpfmm = num2str(clf_mm(n,:));
    clpfss = num2str(clf_ss(n,:));
    
    clpend{end+1} = ([clpfhr '.' clpfmm '.' clpfss]);
    
    %Create a patient number
    %sz = num2str(sznum(n));
    %patnum = ([clpnum{n}(1:8) 'Sz' sz]);
    patnum = ([clpnum{n}(1:8)]);
    
    % %%
    % %Kevin
    disp('PLI info')
    PLIoffset = [];
    [~,sztimes] = xlsread(xlfile,'PLItest','P3:P7');
    
    for s = 1:size(sztimes,1)
        
        %convert seizure onset times to number of samples
        kszhr = str2double(sztimes{s}(1:2));
        kszmm = str2double(sztimes{s}(4:5));
        kszss = str2double(sztimes{s}(7:8));
        
        if l==1
            kszhr = kszhr + 24;
        end
        
        %convert seizure onset times to number of samples
        convszstrt(s,:) = ((kszhr*3600) + (kszmm*60) + kszss)*Fs;
        
        %calculate seizure offset from start of clip in number of samples
        koffset(s,:) = convszstrt(s) - clpstart_samps(n);
        
        %     koffset = offset;
        
        %Convert the offset sample number to a time (24hr clock)
        ofset_hr = floor((koffset(s,:)/Fs)/3600);
        ofset_mm = floor(((koffset(s,:)/Fs)-(ofset_hr*3600))/60);
        ofset_ss = (koffset(s,:)/Fs)-(ofset_hr*3600)-(ofset_mm*60);
        
        PLIoffset{end+1} = ([num2str(ofset_hr) ':' num2str(ofset_mm) ':' num2str(ofset_ss)]);
        
    end
    
    %Create header
    header.Fs = Fs;
    header.GlobalClipStartTime = clpbeg;
    header.SeizureOnsetTime = sztimes;
    header.SzOffset = PLIoffset;
    header.PatNum = patnum;
    header.day = day{1};
    
    %%
    disp('saving')
    %Save the data structure as the patient number created above
    %save(['D:\Kari\ECoG\Data\' ictal_state '\clips\longsamp\' patnum '.mat'],'data');
    %save(['E:\data\human CNS\EMD\' ictal_state '\clips\' patnum '.mat'],'data','-v7.3');
    %     save(['D:\Kari\ECoG\Data\PLI\' patnum '_PLIclip1.mat'],'data','header', '-v7.3');
%     save(['D:\data\human CNS\PLI_long_data\', patnum, '_', day{1}, '_long_form.mat'],'data','header','-v7.3');
    save(['E:\data\human CNS\PLI_long_data\', patnum, '_', day{1}, '_long_form.mat'],'data','header','-v7.3');
    
    %     figure;
    %     plot(data(50,:));
    %     title (patnum);
    %
    %     xlswrite (xlfile,flstrt',ictal_state,'I3');
    %     xlswrite (xlfile,clpbeg',ictal_state,'J3');
    %     xlswrite (xlfile,clpend',ictal_state,'K3');
    
    clear l Fs clonset clpstart_samps convflstrt convonset fid halfclp offset rec cls_hr cls_mm clp data d P header ns filename n scalefac samps dc center ch clf_hr clf_mm clf_ss clpfhr clpfin clpfin_samps clpfmm clpfss clpshr clpsmm clpsss clpstart patnum szss szmm szhr sz rmzeros r flmm flhr flss cls_ss cls_mmcls_hr
    
    
end

% header.PatientID = 'Utah2011 Clip2';
% header.Grid = 'Ad-Tech QGD7A-MP12X-000 Macro/Micro Grid';
% header.Data = '23.03.2011';
% header.StartofClip = '24:05:00';
% header.LengthOfFile = '10 min';
% header.OffsetTme = '9:41:57';
% header.OffsetSamples = '34917000';
% header.Fs = '1000';
%
% % data2 = data((1:100),:);
% % data = data2;
%  save(['E:\data\human CNS\MacroVmicro\2011clip2.mat'],'data','header','-v7.3');




