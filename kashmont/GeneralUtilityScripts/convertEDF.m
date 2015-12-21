%This script converts full EDF files listed on a spreadsheet to MAT files and saves them to the designated location.

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
function convertEDF(drive,xlfile)
%clear all

%Open excel file and read filenames and seizure numbers into array 'clpnum'

[~,clpnum] = xlsread(xlfile,'Full','A3:A33');
[~,day] = xlsread(xlfile,'Full','B3:B33');

%Loop through array 'clpnum' to open each file and form the clips
for n = 1:length(clpnum)
    
    %Read in the header of the file
    %Should end up with file looking like: 'D:\ECoGData\2014PP01\2014PP01_D01.edf'
     filename = [drive '\' clpnum{n} '\' clpnum{n} '_' day{n} '.edf'];
    disp (filename)
    [hdr,data] = edfread(filename);
    
    %Calculate sampling frequency
    Fs = ceil(1/(hdr.duration/hdr.samples(1)));
     
    %Remove empty channels
    %Read total number of channels from excel file
    totch = xlsread(xlfile,'Full','D3:D100');
    data = data((2:totch(n)+1),:);
    
    %Create a patient number
     patnum = ([clpnum{n}(1:8) 'Fl']);
     
     %Calculate length of file
     lgth = num2str([hdr.records*hdr.samples(1)/Fs 's']);
    
    %Create header
    header.PatNum = hdr.patientID;
    header.Day = hdr.recordID;
    header.Datatype = 'full file';
    header.StartTime = hdr.starttime;
    header.FileLength = lgth;
    header.Fs = Fs;
    header.NumChannels = totch(n);

    

    
    %%
    disp('saving')
    %Save the data structure as the patient number created above
    save(['E:\data\human CNS\EMD\FullFile\' patnum '.mat'],'data','header','-v7.3');
    
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




