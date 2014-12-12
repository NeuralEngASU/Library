function files = fsearch(root,expr,varargin)

% FILES = FSEARCH(ROOT,EXPR) recursively searches through subdirectories 
% starting at ROOT for files matching the expression EXPR.  Returns an 
% array of structs equivalent to the output of the DIR command.
%
% FILES = FSEARCH(ROOT,EXPR,'depth',DEPTH)limits the recursive search depth
% to DEPTH.  Default is -1, indicating no limit.
%
% FILES = FSEARCH(ROOT,EXPR,'regexp') interprets EXPR as a regular
% expression rather than the simpler wildcard matching inherent in the DIR
% command.
%
% FILES = FSEARCH(ROOT,EXPR,'flat') returns a cell array of strings 
% containing full file paths instead of an array of structs.

% initialize file collection
files=struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{});

% set defaults
depth=-1;   % recursively search subdirectories without limit
reflag=0;   % no regexp matching (just normal dir expr matching)
flatflag=0; % return array of structs, not cell array of strings

% parse inputs
for k=1:length(varargin)
    if(strcmpi(varargin{k},'depth'))
        depth=varargin{k+1};
    elseif(strcmpi(varargin{k},'regexp'))
        reflag=1;
    elseif(strcmpi(varargin{k},'flat'))
        flatflag=1;
    end
end

% clean up inputs
if(strcmp(root(end),'/') || strcmp(root(end),'\'))
    root=root(1:end-1);
end

% check validity of inputs
if(~exist(root,'dir'))
    error('search:exist','''%s'' does not exist or is not a directory',root);
end

% check search depth limit
if(depth==0)
    return;
end

% get sub directories
list=dir(root);

% remove ref to current, parent directories
list(~cellfun('isempty',regexp({list.name},'^.{1,2}$','match')))=[];

% pull out just directories
dlist=list([list.isdir]==1);

% recursively search directories
for k=1:length(dlist)
    if(reflag)
        tmpfiles=fsearch([root '/' dlist(k).name],expr,'depth',depth-1,'regexp');
    else
        tmpfiles=fsearch([root '/' dlist(k).name],expr,'depth',depth-1);
    end
    files=cat(1,files,tmpfiles);
end

% match EXPR to files
if(reflag)
    % pull out just files
    flist=list([list.isdir]==0);
    
    % test the filename against the search parameter
    flist(cellfun('isempty',regexp({flist.name},regexp,'match')))=[];
else
    % use built-in dir wildcard expression matching
    flist=dir(fullfile(root,expr));
end

% add directory path to the filename
for k=1:length(flist)
    flist(k).name=fullfile(root,flist(k).name);
end

% concat file listing
if(~isempty(flist))
    files=cat(1,files,flist);
end

% create cell array of strings if requested
if(flatflag)
    files={files.name}';
end