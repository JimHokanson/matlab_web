function writeLibraryToDisk(obj,archive)
%
%   JAH TODO: Document function
%

ARCHIVE_PATH = 'lib_archive';
ARCHIVE_NAME = regexprep(datestr(now),'-|:| ','_');

if ~exist('archive','var')
    archive = false;
end

libPath  = obj.client_obj.user_libMat_path;

%LIBRARY TO STRUCTURE
s = struct;
s.VERSION       = obj.VERSION;
s.entries       = obj.entries;
s.ids           = obj.ids;
s.lastRead      = obj.lastRead;
s.created       = obj.created;
s.authors       = obj.authors;
s.title         = obj.title;
s.year          = obj.year;
s.publication   = obj.publication;
s.docType       = obj.docType;

if archive
    basePath = fileparts(libPath);
    libPath  = fullfile(basePath,ARCHIVE_PATH,[ARCHIVE_NAME '.mat']);
end

save(libPath,'s');