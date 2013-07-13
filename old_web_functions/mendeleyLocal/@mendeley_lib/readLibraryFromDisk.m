function readLibraryFromDisk(obj)
%
%   readLibraryFromDisk(obj)
%
%   JAH TODO: DOCUMENTATION
%
%   NOTE: This function should really only be called from getLibrary()
%
%   See Also:
%       mendeley_lib.updateDocIDsUser
%       mendeley_lib.getLibrary


libPath  = obj.client_obj.user_libMat_path;
userName = obj.client_obj.user_name;

if ~exist(libPath,'file')
    formattedWarning(sprintf('Warning: library file for %s doesn''t exist, using default',userName))
    initLibStruct(obj,0);
    return
end

h  = load(libPath);
s  = h.s;

oldVersion  = s.VERSION;
sameVersion = oldVersion == obj.VERSION;

%This will eventually need to be reworked ...
obj.entries     = s.entries;
obj.ids         = s.ids;
obj.lastRead    = s.lastRead;
obj.created     = s.created;
obj.authors     = s.authors;
obj.title       = s.title;
obj.year        = s.year;
obj.publication = s.publication;
obj.docType     = s.docType;

%%ASSUMPTION
%------------------------------------------
%entries can always be reparsed by version
%SHOULD TRY AND AVOID REQUESTS TO MENDELEY
if ~sameVersion
    formattedWarning(['Mismatch in versions, old: ' ...
        '%0g, new %0g, Updating ...'],...
        oldVersion,obj.VERSION);
    parseEntries(obj,1:length(s.entries))
    formattedWarning('Done Updating')
end

if ~sameVersion
   writeLibraryToDisk(obj,true);
   writeLibraryToDisk(obj);
end

