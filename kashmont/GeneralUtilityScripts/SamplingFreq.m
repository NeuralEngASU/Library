%This function calculates the sampling frequency of an .edf file that was
%exported from XLTek and write the caluated frequency to a specified excel
%sheet.

function SamplingFreq (drive,xlfile)
%clear all
Fs = [];

%Open excel file and read filenames and seizure numbers into array 'clpnum'

% [~,clpnum] = xlsread(xlfile,'Sheet1','A3:A100');
% [~,day] = xlsread(xlfile,'Sheet1','E3:E100');
[~,clpnum] = xlsread(xlfile,'Full','A3:A100');
[~,day] = xlsread(xlfile,'Full','B3:B100');

%Loop through array 'clpnum' to open each file and form the clips
for n = 1:length(clpnum)
    
    %Read in the header of the file
    %Should end up with file looking like: 'D:\ECoGData\2014PP01\2014PP01_D01.edf'
    %\\tsclient\E\
    filename = [drive '\' clpnum{n} '\' clpnum{n} '_' day{n} '.edf'];
    disp (filename)
    [header] = edfread(filename);
    
    %Calculate sampling frequency
    Fs{end+1} = ceil(1/(header.duration/header.samples(1)));
    
    %     xlswrite (xlfile,Fs','Sheet1','H3');
    xlswrite (xlfile,Fs,'Full','C3');
    
end