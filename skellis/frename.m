function frename(root,str)
% prepend the dirname to IIS/AP files that don't have it

files=fsearch(root,str,'flat');

for f=1:length(files)
    [pathstr,basename,ext]=fileparts(files{f});

    if(~isempty(strfind(basename,'___')))
        dirname=basename(1:strfind(basename,'___')-1);
        basename=basename(strfind(basename,'___')+3:end);
        movefile(files{f},fullfile(pathstr,[basename ext]));
    end
    
    % % % dirname=basename(1:strfind(basename,'_idx')-5);
    % % % movefile(files{f},fullfile(pathstr,[dirname '___' basename ext]));
end