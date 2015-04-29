
% fileList{1} = {'E:\data\human CNS\EMD\Sz\clips\2014PP02Sz1.mat'};
% fileList{2} = {'E:\data\human CNS\EMD\Sz\clips\2014PP02Sz2.mat'};
% fileList{3} = {'E:\data\human CNS\EMD\Sz\clips\2014PP02Sz3.mat'};
% fileList{4} = {'E:\data\human CNS\EMD\Sz\clips\2014PP02Sz4.mat'};
% fileList{5} = {'E:\data\human CNS\EMD\Sz\clips\2014PP02Sz5.mat'};
% fileList{6} = {'E:\data\human CNS\EMD\Sz\clips\2014PP02Sz6.mat'};

% fileList{1} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP01NonSz1_DN.mat'};
% fileList{2} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP01NonSz2_DN.mat'};
% fileList{3} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP01NonSz3_DN.mat'};
% fileList{1} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP01Sz7_DN.mat'};
fileList{1} = {'E:\data\human CNS\PLI_long_data\LongPLIclip2.mat'};
% fileList{1} = {'E:\data\human CNS\PLI_long_data\LongPLIclip3.mat'};
% fileList{3} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP01Sz3_DN.mat'};

outputPath = 'E:\data\PLI\EMDData\LongFormData';

winSize = [1];
Fs = [500,500, 500, 500, 500, 500, 500];

for ii = 1:length(fileList)
    for jj = 1:length(winSize)
        [filePathOut] = GenPLI(fileList{ii}{1}, outputPath, 'winSize', winSize(jj), 'rawPhiFlag',0, 'Fs', Fs(ii));
    end % END FOR
end % END FOR