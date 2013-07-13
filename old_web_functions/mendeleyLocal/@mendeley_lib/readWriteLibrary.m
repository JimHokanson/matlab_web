function libraryContentsOut = readWriteLibrary(obj,option,libraryContentsIn,archive)
%mendeley_local_readWriteLibrary
%
%   READ OPTION
%   ---------------------------------
%   libraryContents = mendeley_local_readWriteLibrary('read',userName)
%
%   WRITE OPTION
%   ---------------------------------
%   libraryContents = ...
%       mendeley_local_readWriteLibrary('write',userName,libraryContentsIn,*archive)
%
%   OUTPUTS
%   ========================================
%   libraryContents (struct) : see mendeley_local_initLibStruct
%
%   INPUTS
%   ========================================
%   option        : 'read' or 'write'
%   userName      : account username
%   libContentsIn : structure from local_getLibrary
%   archive       : (default false), if true, saves library as a backup
%
%   See Also:
%       mendeley_local_getUnsortedDocs    
%       mendeley_local_readWriteLibrary
%

ARCHIVE_PATH = 'lib_archive';
ARCHIVE_NAME = regexprep(datestr(now),'-|:| ','_');

if ~ismember(nargin,[2 3 4])
    error('The number of input arguments must be 2 for read, 3 for write')
end

if ~exist('archive','var')
    archive = false;
end

pOut     = obj.client_obj.pathsStruct;
libPath  = pOut.libPath;
userName = obj.client_obj.user_name;

switch lower(option)
    case 'read'
        if ~exist(libPath,'file')
           formattedWarning(sprintf('Warning: library file for %s doesn''t exist, using default',userName))
            libraryContentsOut = initLibStruct(obj,0);
        else
           h = load(libPath,'libraryContentsIn');
           libraryContentsOut = h.libraryContentsIn;
        end
    case 'write'
        libraryContentsOut = libraryContentsIn;
        if archive
           basePath = fileparts(libPath);
           libPath  = fullfile(basePath,ARCHIVE_PATH,[ARCHIVE_NAME '.mat']);
        end
        save(libPath,'libraryContentsIn');
    otherwise
        error('Input option must be ''read'' or ''write'', not %s',option)
end